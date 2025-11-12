// === counter.v ===

module top
(
    input wire clk,
    output [5:0] led
);

localparam WAIT_TIME = 2700000;             // 13500000 or 24'd1349_9999 (0.5s delay for 27 MHz)
reg [23:0] clockCounter = 0;
reg [5:0] ledCounter = 0;

always @(posedge clk) begin
    clockCounter <= clockCounter + 1;
    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;                  // <= 24'b0; // <= 24'd0; // Write 24 bit "0" 
        //ledCounter <= ~ledCounter;
        ledCounter <= ledCounter + 1;
    end
end

assign led = ledCounter;

endmodule

/*
// === tangnano9k.cst ===
IO_LOC  "clk" 52;
IO_PORT "clk" IO_TYPE=LVCMOS33 PULL_MODE=UP;

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

/*
Device Utilisation:
VCC:                       1/      1   100%
IOB:                       7/    274     2%
LUT4:                     11/   8640     0%
OSER16:                    0/     80     0%
IDES16:                    0/     80     0%
IOLOGICI:                  0/    276     0%
IOLOGICO:                  0/    276     0%
MUX2_LUT5:                 2/   4320     0%
MUX2_LUT6:                 0/   2160     0%
MUX2_LUT7:                 0/   1080     0%
MUX2_LUT8:                 0/   1080     0%
ALU:                      34/   6480     0%
GND:                       1/      1   100%
DFF:                      30/   6480     0%
RAM16SDP4:                 0/    270     0%
BSRAM:                     0/     26     0%
ALU54D:                    0/     10     0%
MULTADDALU18X18:           0/     10     0%
MULTALU18X18:              0/     10     0%
MULTALU36X18:              0/     10     0%
MULT36X36:                 0/      5     0%
MULT18X18:                 0/     20     0%
MULT9X9:                   0/     40     0%
PADD18:                    0/     20     0%
PADD9:                     0/     40     0%
GSR:                       1/      1   100%
OSC:                       0/      1     0%
rPLL:                      0/      2     0%
FLASH608K:                 0/      1     0%
BUFG:                      0/     22     0%
DQCE:                      0/     24     0%
DCS:                       0/      8     0%
DHCEN:                     0/     24     0%
CLKDIV:                    0/      8     0%
CLKDIV2:                   0/     16     0%
MIPI_IBUF:                 0/     22     0%
MIPI_OBUF:                 0/     20     0%
*/

/*
// === button.v ===
IOB:                       5/    274     1%
LUT4:                      0/   8640     0%
MUX2_LUT5:                 0/   4320     0%
ALU:                       0/   6480     0%
DFF:                       0/   6480     0%

// === blink.v ===
IOB:                       3/    274     1%
LUT4:                     25/   8640     0%
MUX2_LUT5:                 0/   4320     0%
ALU:                      48/   6480     0%
DFF:                      25/   6480     0%

// === blink_button.v ===
IOB:                       7/    274     1%
LUT4:                     25/   8640     0%
MUX2_LUT5:                 0/   4320     0%
ALU:                      48/   6480     0%
DFF:                      25/   6480     0%

// === counter.v ===
IOB:                       7/    274     2%
LUT4:                     11/   8640     0%
MUX2_LUT5:                 2/   4320     0%
ALU:                      34/   6480     0%
DFF:                      30/   6480     0%
*/
