// === arithmetic.v ===

module top
(
    input wire [1:0] cmd,
    input wire clk,
    input wire din,
    output wire dout
);

parameter WIDTH = 16;

wire [(WIDTH-1):0] a_out;
wire [(WIDTH-1):0] b_out;
wire [(2*WIDTH-1):0] sum_in;
wire [(2*WIDTH-1):0] sum_out;
wire reset;
wire ab_ena;
wire ab_clk;
wire c_ena;
wire c_clk;
wire p_ld;

sipo_sr #(.WIDTH(WIDTH)) a
(
    .clk(ab_clk),
    .reset(reset),
    .s_in(din),
    .p_out(a_out)
);

sipo_sr #(.WIDTH(WIDTH)) b
(
    .clk(ab_clk),
    .reset(reset),
    .s_in(a_out[0]),
    .p_out(b_out)
);

pipo_sr #(.WIDTH(2*WIDTH)) c
(
    .clk(c_clk),
    .reset(reset),
    .p_ld(p_ld),
    .s_in(sum_in[2*WIDTH - 1]),
    .p_in(sum_out),
    .p_out(sum_in)
);

// Control signals
assign ab_ena = ~cmd[1];
assign c_ena = cmd[1] | ~cmd[0];
assign p_ld = cmd[1]&(~cmd[0]);
assign reset = ~(cmd[1] | cmd[0]);

// Clock gates
assign ab_clk = ab_ena & clk;
assign c_clk = c_ena & clk;

// arithmetic  
assign sum_out = a_out*b_out + sum_in;

// Output
assign dout = sum_in[31];

endmodule

/*
// === tangnano9k.cst ===
IO_LOC "clk" 35;
IO_PORT "clk" IO_TYPE=LVCMOS33 PULL_MODE=NONE PCI_CLAMP=OFF BANK_VCCIO=3.3;

IO_LOC "dout" 34;
IO_PORT "dout" IO_TYPE=LVCMOS33 PULL_MODE=NONE DRIVE=8 BANK_VCCIO=3.3;

IO_LOC "din" 40;
IO_PORT "din" IO_TYPE=LVCMOS33 PULL_MODE=NONE PCI_CLAMP=OFF BANK_VCCIO=3.3;

IO_LOC "cmd[1]" 41;
IO_PORT "cmd[1]" IO_TYPE=LVCMOS33 PULL_MODE=NONE PCI_CLAMP=OFF BANK_VCCIO=3.3;

IO_LOC "cmd[0]" 42;
IO_PORT "cmd[0]" IO_TYPE=LVCMOS33 PULL_MODE=NONE PCI_CLAMP=OFF BANK_VCCIO=3.3;
*/

/*
Device Utilisation:
VCC:                       1/      1   100%
IOB:                       5/    274     1%
LUT4:                   1390/   8640    16%
OSER16:                    0/     80     0%
IDES16:                    0/     80     0%
IOLOGICI:                  0/    276     0%
IOLOGICO:                  0/    276     0%
MUX2_LUT5:               493/   4320    11%
MUX2_LUT6:               171/   2160     7%
MUX2_LUT7:                70/   1080     6%
MUX2_LUT8:                28/   1080     2%
ALU:                      34/   6480     0%
GND:                       1/      1   100%
DFF:                      64/   6480     0%
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
// === arithmetic.v ===
IOB:                       5/    274     1%
LUT4:                   1390/   8640    16%
MUX2_LUT5:               493/   4320    11%
MUX2_LUT6:               171/   2160     7%
MUX2_LUT7:                70/   1080     6%
MUX2_LUT8:                28/   1080     2%
ALU:                      34/   6480     0%
DFF:                      64/   6480     0%
*/