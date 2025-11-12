// === uart.v ===

module top(
    input wire clk,
    input wire btn1,
    input wire uartRx,
    output wire uartTx,
    output wire [5:0] led
);

uart #(.DELAY_FRAMES(234)) uart_inst (
    .clk(clk),
    .btn1(btn1),
    .uart_rx(uartRx),
    .uart_tx(uartTx),
    .led(led)
);

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

IO_LOC  "btn1" 3;
IO_PORT "btn1" IO_TYPE=LVCMOS18;

IO_LOC  "uartTx" 17;
IO_PORT "uartTx" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "uartRx" 18;
IO_PORT "uartRx" IO_TYPE=LVCMOS33 PULL_MODE=UP;
*/

/*
Device Utilisation:
VCC:                       1/      1   100%
IOB:                      10/    274     3%
LUT4:                    152/   8640     1%
OSER16:                    0/     80     0%
IDES16:                    0/     80     0%
IOLOGICI:                  0/    276     0%
IOLOGICO:                  0/    276     0%
MUX2_LUT5:                30/   4320     0%
MUX2_LUT6:                 5/   2160     0%
MUX2_LUT7:                 0/   1080     0%
MUX2_LUT8:                 0/   1080     0%
ALU:                      54/   6480     0%
GND:                       1/      1   100%
DFF:                      77/   6480     1%
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
// === uart.v ===
IOB:                      10/    274     3%
LUT4:                    152/   8640     1%
MUX2_LUT5:                30/   4320     0%
MUX2_LUT6:                 5/   2160     0%
ALU:                      54/   6480     0%
DFF:                      77/   6480     1%
*/