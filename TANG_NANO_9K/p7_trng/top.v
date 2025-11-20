// === trng.v ===

module top(
    input  wire clk,
    input  wire uartRx,
    output wire uartTx,
    output wire led,
    output reg  p1,
    output reg  p2,
    output reg  p3
);

    localparam PERIOD = 13500;  // (27 000 000 Hz / 2 000)
    reg  [23:0] count = 0;
    wire [31:0] rnd;
    reg  start = 0;

    assign p1 = clk;            // D0 3 MHz (167 ns + 167 ns = 333 ns) (27 MHz / 9)
    assign p2 = start;          // D1 1 kHz (0.5 ms + 0.5 ms = 1 ms)
    assign p3 = uartTx;         // D2 1 kHz (115200 BAUD)

    always @(posedge clk) begin
        if (count < PERIOD) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
            start <= ~start;
            led   <= ~led;
        end
    end

    trng32 u(
        .clk(clk),
        .rnd(rnd)
    );

    uart #(.DELAY_FRAMES(234)) uart_inst (
        .clk(clk),
        .start(start),
        .rnd(rnd),
        .uart_rx(uartRx),
        .uart_tx(uartTx)
    );

endmodule

// ===== TRNG =====

module trng32(
    input  wire clk,
    output reg  [31:0] rnd
);

    wire [31:0] ro_bits;
    wire xor_mix = ^ro_bits;
    reg [31:0] lfsr = 32'hACE1ACE1;

    always @(posedge clk) begin
        lfsr <= {lfsr[30:0], xor_mix ^ lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
        rnd  <= lfsr;
    end

    trng_simple u_ro (
        .rnd(ro_bits)
    );

endmodule

module trng_simple(
    output wire [31:0] rnd
);

    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin: R
            (* KEEP = "TRUE", DONT_TOUCH = "TRUE" *)
            ro #(.STAGES(7 + k % 5))
            u_ro (.out(rnd[k]));
        end
    endgenerate
    
endmodule

module ro #(parameter STAGES = 5) (
    output wire out
);

    wire [STAGES:0] w;
    assign w[0] = ~w[STAGES];

    genvar i;
    generate
        for (i = 1; i <= STAGES; i = i + 1) begin: g
            (* KEEP = "TRUE", DONT_TOUCH = "TRUE" *)
            LUT4 #(.INIT(16'h2)) delay_lut (
                .F(w[i]),
                .I0(w[i-1]),
                .I1(1'b0),
                .I2(1'b0),
                .I3(1'b0)
            );
        end
    endgenerate

    assign out = w[STAGES];

endmodule

// ===== UART =====

module uart
#(
    parameter DELAY_FRAMES = 234    // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input wire clk,
    input wire start,
    input wire [31:0] rnd,
    input wire uart_rx,
    output reg uart_tx
);

    localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

    reg [3:0] rxState = 0;
    reg [12:0] rxCounter = 0;
    reg [2:0] rxBitNumber = 0;
    reg [7:0] dataIn = 0;
    reg byteReady = 0;

    reg [3:0] txState = 0;
    reg [24:0] txCounter = 0;
    reg [7:0] dataOut = 0;
    reg txPinRegister = 1;
    reg [2:0] txBitNumber = 0;
    reg [3:0] txByteCounter = 0;

    assign uart_tx = txPinRegister;

    localparam MEMORY_LENGTH = 10;
    reg [7:0] testMemory [MEMORY_LENGTH-1:0];

    localparam RX_STATE_IDLE = 0;
    localparam RX_STATE_START_BIT = 1;
    localparam RX_STATE_READ_WAIT = 2;
    localparam RX_STATE_READ = 3;
    localparam RX_STATE_STOP_BIT = 4;

    localparam TX_STATE_IDLE = 0;
    localparam TX_STATE_START_BIT = 1;
    localparam TX_STATE_WRITE = 2;
    localparam TX_STATE_STOP_BIT = 3;
    localparam TX_STATE_DEBOUNCE = 4;

    initial begin
        testMemory[8] = "\r";
        testMemory[9] = "\n";
    end

    integer i;
    reg [3:0] nibble;

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            nibble = rnd[31 - i*4 -: 4];
            if (nibble < 10)
                testMemory[i] = "0" + nibble;
            else
                testMemory[i] = "A" + (nibble - 10);
        end
    end

    always @(posedge clk) begin
        case (rxState)
            RX_STATE_IDLE: begin
                if (uart_rx == 0) begin
                    rxState <= RX_STATE_START_BIT;
                    rxCounter <= 1;
                    rxBitNumber <= 0;
                    byteReady <= 0;
                end
            end 
            RX_STATE_START_BIT: begin
                if (rxCounter == HALF_DELAY_WAIT) begin
                    rxState <= RX_STATE_READ_WAIT;
                    rxCounter <= 1;
                end else 
                    rxCounter <= rxCounter + 1;
            end
            RX_STATE_READ_WAIT: begin
                rxCounter <= rxCounter + 1;
                if ((rxCounter + 1) == DELAY_FRAMES) begin
                    rxState <= RX_STATE_READ;
                end
            end
            RX_STATE_READ: begin
                rxCounter <= 1;
                dataIn <= {uart_rx, dataIn[7:1]};
                rxBitNumber <= rxBitNumber + 1;
                if (rxBitNumber == 3'b111)
                    rxState <= RX_STATE_STOP_BIT;
                else
                    rxState <= RX_STATE_READ_WAIT;
            end
            RX_STATE_STOP_BIT: begin
                rxCounter <= rxCounter + 1;
                if ((rxCounter + 1) == DELAY_FRAMES) begin
                    rxState <= RX_STATE_IDLE;
                    rxCounter <= 0;
                    byteReady <= 1;
                end
            end
        endcase

        case (txState)
            TX_STATE_IDLE: begin
                if (start == 1) begin
                    txState <= TX_STATE_START_BIT;
                    txCounter <= 0;
                    txByteCounter <= 0;
                end
                else begin
                    txPinRegister <= 1;
                end
            end
            TX_STATE_START_BIT: begin
                txPinRegister <= 0;
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    txState <= TX_STATE_WRITE;
                    dataOut <= testMemory[txByteCounter];
                    txBitNumber <= 0;
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end
            TX_STATE_WRITE: begin
                txPinRegister <= dataOut[txBitNumber];
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    if (txBitNumber == 3'b111) begin
                        txState <= TX_STATE_STOP_BIT;
                    end else begin
                        txState <= TX_STATE_WRITE;
                        txBitNumber <= txBitNumber + 1;
                    end
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end
            TX_STATE_STOP_BIT: begin
                txPinRegister <= 1;
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    if (txByteCounter == MEMORY_LENGTH - 1) begin
                        txState <= TX_STATE_DEBOUNCE;
                    end else begin
                        txByteCounter <= txByteCounter + 1;
                        txState <= TX_STATE_START_BIT;
                    end
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end
            TX_STATE_DEBOUNCE: begin
                if (txCounter == 23'b000000011111111111) begin
                    if (start == 0) 
                        txState <= TX_STATE_IDLE;
                end else
                    txCounter <= txCounter + 1;
            end
        endcase
    end

endmodule

/*
// === tangnano9k.cst ===
IO_LOC  "clk" 52;
IO_PORT "clk" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "led" 10;
IO_PORT "led" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "uartTx" 17;
IO_PORT "uartTx" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "uartRx" 18;
IO_PORT "uartRx" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "p1" 38;
IO_PORT "p1" DRIVE=8 IO_TYPE=LVCMOS33;

IO_LOC  "p2" 37;
IO_PORT "p2" DRIVE=8 IO_TYPE=LVCMOS33;

IO_LOC  "p3" 36;
IO_PORT "p3" DRIVE=8 IO_TYPE=LVCMOS33;
*/
