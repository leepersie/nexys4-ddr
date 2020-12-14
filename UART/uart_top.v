`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 19:06:37
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input clk,
    input rx,
    output tx
    );

wire clk_div, rdsig, wrsig;
wire frameerror, dataerror;
wire [7:0] datarx, datatx;

clk_div u0(
    .clk(clk),
    .clk_div(clk_div)
    );
    
uart_ctrl u1(
    .clk(clk_div),
    .datain(datarx),
    .rdsig(rdsig),
    .dataout(datatx),
    .wrsig(wrsig)
);

uart_rx u2(
    .clk(clk_div),
    .rx(rx),
    .dataout(datarx),
    .rdsig(rdsig),
    .frameerror(frameerror),
    .dataerror(dataerror)
    );
    
uart_tx u3(
    .clk(clk_div),
    .datain(datatx),
    .wrsig(wrsig),
    .tx(tx),
    .idle()
);
endmodule
