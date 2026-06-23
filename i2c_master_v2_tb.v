`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 21:39:26
// Design Name: 
// Module Name: i2c_master_v2_tb
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



module i2c_master_v2_tb;

reg clk;
reg rst;
reg start;

// Simulated Slave ACK
reg slave_ack;

wire scl;
wire [2:0] state;
wire ack_error;

// SDA Bus
wire sda;

assign sda = (slave_ack) ? 1'b0 : 1'bz;

i2c_master_v2 uut(

    .clk(clk),
    .rst(rst),
    .start(start),

    .sda(sda),

    .scl(scl),
    .state(state),
    .ack_error(ack_error)

);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;
    start = 0;

    slave_ack = 0;

    #20;
    rst = 0;

    #20;
    start = 1;

    // Simulate ACK from slave
    #100;
    slave_ack = 1;

    #100;
    slave_ack = 0;

    #100;
    start = 0;

    #2000;

    $finish;

end

endmodule


