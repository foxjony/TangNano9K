// === Bitcoin Satoshi Puzzle 130 ===
// PrivateKey:  33e7665705359f04f28b88cf897c603c9
//  PublikKey:  03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c09937852
//    SHA-256:  92d0bf55a6ecef50e36e9a605e4216c20f38c70635c2fb627de9d404689956b2
//    Address:  1Fo65aKq8s8iquMt6weF1rku1moWVEd5Ua

// https://sopkit.github.io/Encoding/sha256.html    (Change the Input type to Hex)
// Input: 03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c09937852
//  Hash: 92d0bf55a6ecef50e36e9a605e4216c20f38c70635c2fb627de9d404689956b2

// $display - виводить значення лише один раз
// $monitor - перевиводить щоразу, коли значення змінюється

module test();
reg  clk = 0;
reg  reset = 0;
reg  [511:0] data;                      // PublikKey
wire [255:0] hash;                      // SHA-256
reg  [255:0] rez;                       // SHA-256 (for check)
wire ready;
integer i;
integer check;

always #10 clk = ~clk;                  // real #1 (#10 for test zoom in .vcd)

initial begin
    $dumpfile("sha256.vcd");
    $dumpvars(0, test);

    // data len: 33*8 = 264 => 0x0108
    data  = 512'h03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785280000000000000000000000000000000000000000000000000000000000108;
    rez   = 256'h92d0bf55a6ecef50e36e9a605e4216c20f38c70635c2fb627de9d404689956b2;      // SHA-256 (for check)
    check = 0;
    reset = 1;
    #20;                                // real minimum #2 (#20 for test zoom in .vcd)
    reset = 0;

    i = 0;
    while (ready == 0) begin
        @(posedge clk) i++;
    end

    if (hash == rez) check = 1;

    $display("\nCycles1: %d", i);       // Cycles1: 35
    $display("Data1: %h", data);        // Data1: 03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785280000000000000000000000000000000000000000000000000000000000108
    $display("Hash1: %h", hash);        // Hash1: 92d0bf55a6ecef50e36e9a605e4216c20f38c70635c2fb627de9d404689956b2
    $display("Check1: %d\n", check);    // Check1: 1

    data  = 512'h03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785380000000000000000000000000000000000000000000000000000000000108;
    rez   = 256'h03497feb0e4fafd392f8fe9ef6eed2c4ea1d942051dda7aaf211c0743df1a7a5;      // SHA-256 (for check)
    check = 0;
    reset = 1;
    #30;                                // real minimum #3 (#30 for test zoom in .vcd)
    reset = 0;

    i = 0;
    while (ready == 0) begin
        @(posedge clk) i++;
    end

    if (hash == rez) check = 1;

    $display("Cycles2: %d", i);         // Cycles2: 35
    $display("Data2: %h", data);        // Data2: 03633cbe3ec02b9401c5effa144c5b4d22f87940259634858fc7e59b1c0993785380000000000000000000000000000000000000000000000000000000000108
    $display("Hash2: %h", hash);        // Hash2: 03497feb0e4fafd392f8fe9ef6eed2c4ea1d942051dda7aaf211c0743df1a7a5
    $display("Check2: %d\n", check);    // Check2: 1
    $finish;
end

sha256 u(
    .data(data),
    .clk(clk),
    .reset(reset),
    .ready(ready),
    .hash(hash)
);
endmodule