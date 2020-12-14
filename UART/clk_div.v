`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 19:31:24
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input clk,
    output reg clk_div
    );

reg [15:0] cnt;

always @ (posedge clk) begin
    if(cnt == 16'd325) begin
        clk_div <= 1'b1;
    end
    else if(cnt == 16'd651) begin
        clk_div <= 1'b0;
    end
end

always @ (posedge clk) begin
    if(cnt == 16'd651) begin
        cnt <= 16'd0;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

endmodule
