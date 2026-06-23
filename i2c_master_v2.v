`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 21:38:05
// Design Name: 
// Module Name: i2c_master_v2
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


module i2c_master_v2(

    input clk,
    input rst,
    input start,

    inout sda,

    output reg scl,
    output reg [2:0] state,
    output reg ack_error

);

reg [6:0] slave_addr;
reg rw;

reg [7:0] addr_rw;
reg [7:0] data_byte;

reg [3:0] bit_count;
reg [3:0] data_count;

// SDA Control
reg sda_out;
reg sda_oe;

// Clock Divider
reg i2c_clk;
reg [3:0] clk_div;

// States
parameter IDLE         = 3'd0;
parameter START_ST     = 3'd1;
parameter SEND_ADDR_RW = 3'd2;
parameter ACK1         = 3'd3;
parameter SEND_DATA    = 3'd4;
parameter ACK2         = 3'd5;
parameter STOP_ST      = 3'd6;

// Tri-State SDA
assign sda = (sda_oe) ? sda_out : 1'bz;

// Initial Values
initial
begin
    slave_addr = 7'b1010000;
    rw         = 1'b0;

    addr_rw    = {slave_addr,rw};

    data_byte  = 8'b10100101;

    ack_error  = 0;
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
            clk_div <= clk_div + 1;

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
        bit_count <= 7;
        data_count <= 7;
        ack_error <= 0;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            bit_count <= 7;
            data_count <= 7;

            if(start)
                state <= START_ST;
        end

        START_ST:
        begin
            state <= SEND_ADDR_RW;
        end

        SEND_ADDR_RW:
        begin

            if(bit_count == 0)
                state <= ACK1;
            else
                bit_count <= bit_count - 1;

        end

        ACK1:
        begin

            if(sda == 1'b1)
                ack_error <= 1'b1;

            state <= SEND_DATA;

        end

        SEND_DATA:
        begin

            if(data_count == 0)
                state <= ACK2;
            else
                data_count <= data_count - 1;

        end

        ACK2:
        begin

            if(sda == 1'b1)
                ack_error <= 1'b1;

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
        scl = 1;
        sda_oe = 1;
        sda_out = 1;
    end

    START_ST:
    begin
        scl = 1;
        sda_oe = 1;
        sda_out = 0;
    end

    SEND_ADDR_RW:
    begin
        scl = i2c_clk;
        sda_oe = 1;
        sda_out = addr_rw[bit_count];
    end

    ACK1:
    begin
        scl = i2c_clk;
        sda_oe = 0;
        sda_out = 1'b1;
    end

    SEND_DATA:
    begin
        scl = i2c_clk;
        sda_oe = 1;
        sda_out = data_byte[data_count];
    end

    ACK2:
    begin
        scl = i2c_clk;
        sda_oe = 0;
        sda_out = 1'b1;
    end

    STOP_ST:
    begin
        scl = 1;
        sda_oe = 1;
        sda_out = 1;
    end

    default:
    begin
        scl = 1;
        sda_oe = 1;
        sda_out = 1;
    end

    endcase

end

endmodule

