`timescale 1ns/1ps
module apb_master_tb;

logic clk;
logic rst;

logic PSEL;
logic PENABLE;
logic PWRITE;
logic [7:0] PADDR;
logic [7:0] PWDATA;
logic [7:0] PRDATA;
logic PREADY;

// DUT
apb_master dut(
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
apb_slave slave (
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
always #10 clk = ~clk;

// Reset and simulation time
initial begin
    rst = 1;
    #50 rst = 0;

    #500 $finish;
end

endmodule
