`timescale 1ns/1ps
module apb_top;

logic clk;
logic rst;

logic PSEL;
logic PENABLE;
logic PWRITE;
logic [7:0] PADDR;
logic [7:0] PWDATA;
logic [7:0] PRDATA;
logic PREADY;

// Instantiate Master
apb_master master(
    .clk(clk),
    .rst(rst),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY)
);

// Instantiate Slave
apb_slave slave(
    .PCLK(clk),
    .PRESETn(~rst),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY)
);

// Clock generation
initial clk = 0;
always #10 clk = ~clk;  // 50 MHz clock

// Reset
initial begin
    rst = 1;
    #50 rst = 0;
end

endmodule
