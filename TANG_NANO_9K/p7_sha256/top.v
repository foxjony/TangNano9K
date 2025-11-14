// === sha256.v ===

module top(
    input wire clk,
    input wire btn1,
    output reg [5:0] led
);

reg  ok = 0;
wire ready;
reg  [0:511] data;
wire [255:0] hash;
reg  [255:0] rez;
reg  [1:0]   por = 0;                   // power-on reset (POR)
wire reset = (por != 2'b11);            // For Auto Reset 3 clk (Only Start)

initial begin
    led  <= 6'b111111;
    data <= 512'h03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785280000000000000000000000000000000000000000000000000000000000108;
    rez  <= 256'h92d0bf55a6ecef50e36e9a605e4216c20f38c70635c2fb627de9d404689956b2;
end

reg btn_sync;
always @(posedge clk) btn_sync <= btn1;

always @(posedge clk) begin
    if (por != 2'b11) por <= por + 1;   // For Reset 3 clk

    if (ready == 1 && ok == 0) begin
        ok <= 1;
        if (hash == rez) led[0] <= 1'b0;
    end

    if (btn_sync == 0) begin
        por  <= 0;                       // (For Reset = 1)
        ok   <= 0;
        led  <= 6'b111111;
        data <= 512'h03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785380000000000000000000000000000000000000000000000000000000000108;
        rez  <= 256'h03497feb0e4fafd392f8fe9ef6eed2c4ea1d942051dda7aaf211c0743df1a7a5;
    end
end

sha256 u(
    .data(data),
    .clk(clk),
    .reset(reset),
    .ready(ready),
    .hash(hash)
);
endmodule

/*
// === tangnano9k.cst ===
IO_LOC  "clk" 52;
IO_PORT "clk" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "btn1" 3;
IO_PORT "btn1" IO_TYPE=LVCMOS18 PULL_MODE=UP;

IO_LOC  "led[0]" 10;
IO_PORT "led[0]" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "led[1]" 11;
IO_PORT "led[1]" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "led[2]" 13;
IO_PORT "led[2]" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "led[3]" 14;
IO_PORT "led[3]" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "led[4]" 15;
IO_PORT "led[4]" DRIVE=8 IO_TYPE=LVCMOS18;

IO_LOC  "led[5]" 16;
IO_PORT "led[5]" DRIVE=8 IO_TYPE=LVCMOS18;
*/
