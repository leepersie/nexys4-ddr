`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 14:12:53
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input [7:0] datain,
    input wrsig,
    output reg tx,
    output reg idle
    );

reg wrsig_r, rise, send, check;
reg [7:0] cnt;
wire check_b = 1'b0;

always @ (posedge clk) begin
    wrsig_r <= wrsig;
    rise <= (~wrsig_r) & wrsig;
end

always @ (posedge clk) begin
    if(rise && (~idle)) begin
        send <= 1'b1;
    end
    else if(cnt == 8'd168) begin
        send <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(cnt == 8'd168) begin
        cnt <= 8'd0;
    end
    else if(send) begin
        cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= 8'd0;
    end
end 

always @ (posedge clk) begin
    if(send) begin
        case(cnt)
            8'd0: begin
                tx <= 1'b0;
            end
            8'd16: begin
                tx <= datain[0];
                check <= check_b ^ datain[0];
            end
            8'd32: begin
                tx <= datain[1];
                check <= check ^ datain[1];
            end
            8'd48: begin
                tx <= datain[2];
                check <= check ^ datain[2];
            end
            8'd64: begin
                tx <= datain[3];
                check <= check ^ datain[3];
            end
            8'd80: begin
                tx <= datain[4];
                check <= check ^ datain[4];
            end
            8'd96: begin
                tx <= datain[5];
                check <= check ^ datain[5];
            end
            8'd112: begin
                tx <= datain[6];
                check <= check ^ datain[6];
            end
            8'd128: begin
                tx <= datain[7];
                check <= check ^ datain[7];
            end
            8'd144: begin
                tx <= check;
            end
            8'd160: begin
                tx <= 1'b1;
            end
        endcase
    end
    else begin
        tx <= 1'b1;
        check <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(send) begin
        idle <= 1'b1;
    end
    else begin
        idle <= 1'b0;
    end
end

endmodule
