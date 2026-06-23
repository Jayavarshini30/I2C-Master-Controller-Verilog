`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 21:15:44
// Design Name: 
// Module Name: i2c_master_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





module i2c_master_tb;

reg clk;
reg rst;
reg start;

wire scl;
wire sda;
wire [2:0] state;

i2c_master uut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .scl(scl),
    .sda(sda),
    .state(state)
);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;
    start = 0;

    #20;
    rst = 0;

    #20;
    start = 1;

    // Keep start high longer
    #200;
    start = 0;

    #5000;

    $finish;

end

endmodule

