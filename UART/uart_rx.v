`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 19:39:11
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rx,
    output reg [7:0] dataout,
    output reg rdsig,
    output reg frameerror,
    output reg dataerror
    );

reg rx_r, fall, receive;
reg idle, check;
reg [7:0] cnt;
wire check_b = 1'b0;

always @ (posedge clk) begin
    fall <= rx_r & (~rx);
    rx_r <= rx;
end

always @ (posedge clk) begin
    if(fall && ~idle) begin
        receive <= 1'b1;
    end
    else if(cnt == 8'd168) begin
        receive <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(receive) begin
        idle <= 1'b1;
    end
    else begin
        idle <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(cnt == 8'd168) begin
        cnt <= 8'd0;
    end
    else if(receive) begin
        cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= 8'd0;
    end
end

always @ (posedge clk) begin
    if(receive) begin
        case(cnt)
            8'd24: begin
                dataout[0] <= rx;
                check <= check_b ^ rx;
            end
            8'd40: begin
                dataout[1] <= rx;
                check <= check ^ rx;
            end
            8'd56: begin
                dataout[2] <= rx;
                check <= check ^ rx;
            end
            8'd72: begin
                dataout[3] <= rx;
                check <= check ^ rx;
            end
            8'd88: begin
                dataout[4] <= rx;
                check <= check ^ rx;
            end
            8'd104: begin
                dataout[5] <= rx;
                check <= check ^ rx;
            end
            8'd120: begin
                dataout[6] <= rx;
                check <= check ^ rx;
            end
            8'd136: begin
                dataout[7] <= rx;
                check <= check ^ rx;
            end
            8'd152: begin
                if(rx == check) begin
                    dataerror <= 1'b0;
                end
                else begin
                    dataerror <= 1'b1;
                end
            end
            8'd168: begin
                if(rx == 1'b1) begin
                    frameerror <= 1'b0;
                end
                else begin
                    frameerror <= 1'b1;
                end
            end
        endcase
    end
    else begin
        dataerror <= 1'b0;
        frameerror <= 1'b0;
        check <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(cnt == 8'd168) begin
        rdsig <= 1'b0;
    end
    else if(cnt == 8'd136) begin
        rdsig <= 1'b1;
    end
end

endmodule
