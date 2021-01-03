`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/03 10:07:34
// Design Name: 
// Module Name: bcd
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


module bcd(
    input clk,
    input rst_n,
    input [31:0] cnt,
    input [7:0] bin,
    output reg [3:0] one,ten,
    output reg [1:0] hun
    );

reg [3:0] count;
reg [17:0]shift_reg;
// 计数部分
always @ ( posedge clk or negedge rst_n ) begin
    if( !rst_n )
        count<=0;
    else begin
        if(cnt <= 31'd1_000_000) begin   //计数大于该值停止转换，使数码管数值保持稳定稳定
            if(count == 9)
                count<=0;
            else
                count <= count + 1'b1;
        end
    end
end

//二进制转换为十进制 /
always @ (posedge clk or negedge rst_n ) begin
    if (!rst_n)
        shift_reg=0;
    else if (count==0)
        shift_reg={10'b0000000000,bin};
    else if ( count<=8) begin                //实现8次移位操作
        if(shift_reg[11:8]>=5) begin         //判断个位是否>5，如果是则+3  
            if(shift_reg[15:12]>=5) begin    //判断十位是否>5，如果是则+3  
                shift_reg[15:12]=shift_reg[15:12]+2'b11;   
                shift_reg[11:8]=shift_reg[11:8]+2'b11;
                shift_reg=shift_reg<<1;      //对个位和十位操作结束后，整体左移
            end
            else begin
                shift_reg[15:12]=shift_reg[15:12];
                shift_reg[11:8]=shift_reg[11:8]+2'b11;
                shift_reg=shift_reg<<1;
            end
        end              
        else begin
            if(shift_reg[15:12]>=5) begin
                shift_reg[15:12]=shift_reg[15:12]+2'b11;
                shift_reg[11:8]=shift_reg[11:8];
                shift_reg=shift_reg<<1;
            end
            else begin
                shift_reg[15:12]=shift_reg[15:12];
                shift_reg[11:8]=shift_reg[11:8];
                shift_reg=shift_reg<<1;
            end
        end        
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        one<=0;
        ten<=0;
        hun<=0; 
    end
    else if (count==9) begin //此时8次移位全部完成，将对应的值分别赋给个,十,百位
        one<=shift_reg[11:8];
        ten<=shift_reg[15:12];
        hun<=shift_reg[17:16]; 
    end
end
endmodule
