module test();
reg clk = 0;
reg uart_rx = 1;
wire uart_tx;
wire [5:0] led;
reg btn1 = 1;

always
    #1  clk = ~clk;

// $display - виводить значення лише один раз
// $monitor - перевиводить щоразу, коли значення змінюється

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, test);
    $display("Starting UART RX");
    $monitor("LED Value %b", led);
    #10 uart_rx=0;
    #16 uart_rx=1;
    #16 uart_rx=0;
    #16 uart_rx=0;
    #16 uart_rx=0;
    #16 uart_rx=0;
    #16 uart_rx=1;
    #16 uart_rx=1;
    #16 uart_rx=0;
    #16 uart_rx=1;
    #50 $finish;
end

uart #(8'd8) uart(
    .clk(clk),
    .btn1(btn1),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .led(led)
);
endmodule