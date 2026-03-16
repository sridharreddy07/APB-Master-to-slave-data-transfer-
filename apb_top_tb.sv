`timescale 1ns/1ps
module apb_top_tb;

    logic clk;
    logic rst;

    logic       PSEL;
    logic       PENABLE;
    logic       PWRITE;
    logic [7:0] PADDR;
    logic [7:0] PWDATA;
    logic [7:0] PRDATA;
    logic       PREADY;

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 1;
        #1 rst = 0;
    end

    apb_master master (
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

    initial begin
        $dumpfile("apb_wave.vcd");
        $dumpvars(0, apb_top_tb);
        #500;
        $finish;
    end

endmodule
