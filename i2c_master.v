`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 21:14:54
// Design Name: 
// Module Name: i2c_master
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


module i2c_master(

    input clk,
    input rst,
    input start,

    output reg scl,
    output reg sda,
    output reg [2:0] state

);

reg [6:0] slave_addr;
reg [7:0] data_byte;

reg [2:0] bit_count;
reg [3:0] data_count;

// Clock Divider
reg i2c_clk;
reg [9:0] clk_div;

parameter IDLE      = 3'd0;
parameter START_ST  = 3'd1;
parameter SEND_ADDR = 3'd2;
parameter ADDR_ACK  = 3'd3;
parameter SEND_DATA = 3'd4;
parameter DATA_ACK  = 3'd5;
parameter STOP_ST   = 3'd6;

initial
begin
    slave_addr = 7'b1010000;
    data_byte  = 8'b10100101;
end

//--------------------------------------------------
// Clock Divider
//--------------------------------------------------
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        clk_div <= 0;
        i2c_clk <= 0;
    end

    else
    begin

        if(clk_div == 1)
        begin
            clk_div <= 0;
            i2c_clk <= ~i2c_clk;
        end

        else
        begin
            clk_div <= clk_div + 1;
        end

    end

end

//--------------------------------------------------
// FSM
//--------------------------------------------------
always @(posedge i2c_clk or posedge rst)
begin

    if(rst)
    begin
        state <= IDLE;
        bit_count <= 3'd6;
        data_count <= 4'd7;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            bit_count <= 3'd6;
            data_count <= 4'd7;

            if(start)
                state <= START_ST;
        end

        START_ST:
        begin
            state <= SEND_ADDR;
        end

        SEND_ADDR:
        begin

            if(bit_count == 0)
                state <= ADDR_ACK;
            else
                bit_count <= bit_count - 1;

        end

        ADDR_ACK:
        begin
            state <= SEND_DATA;
        end

        SEND_DATA:
        begin

            if(data_count == 0)
                state <= DATA_ACK;
            else
                data_count <= data_count - 1;

        end

        DATA_ACK:
        begin
            state <= STOP_ST;
        end

        STOP_ST:
        begin
            state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase

    end

end

//--------------------------------------------------
// Output Logic
//--------------------------------------------------
always @(*)
begin

    case(state)

    IDLE:
    begin
        scl = 1'b1;
        sda = 1'b1;
    end

    START_ST:
    begin
        scl = 1'b1;
        sda = 1'b0;
    end

    SEND_ADDR:
    begin
        scl = i2c_clk;
        sda = slave_addr[bit_count];
    end

    ADDR_ACK:
    begin
        scl = i2c_clk;
        sda = 1'b1;
    end

    SEND_DATA:
    begin
        scl = i2c_clk;
        sda = data_byte[data_count];
    end

    DATA_ACK:
    begin
        scl = i2c_clk;
        sda = 1'b1;
    end

    STOP_ST:
    begin
        scl = 1'b1;
        sda = 1'b1;
    end

    default:
    begin
        scl = 1'b1;
        sda = 1'b1;
    end

    endcase

end

endmodule