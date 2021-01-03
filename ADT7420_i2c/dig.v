`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/31 23:45:59
// Design Name: 
// Module Name: dig
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


module dig(
    input clk1,
    input rst_n,
    input [1:0] SW,
    output reg [7:0] dig,
    output reg [6:0] seg,
    input [15:0] dis_data,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] huns
    );

reg [15:0] cnt;
reg [3:0] num;
parameter AN0=8'b11111110,AN1=8'b11111101,AN2 = 8'b11111011,AN3 = 8'b11110111,AN4 = 8'b11101111,AN5 = 8'b11011111,
    AN6=8'b10111111,AN7=8'b01111111,//数码管位选定义  
    zero = 7'b100_0000,one = 7'b111_1001,two = 7'b010_0100,three = 7'b011_0000,four = 7'b001_1001,  
    five = 7'b001_0010,six = 7'b000_0010,seven = 7'b111_1000,eigth = 7'b000_0000,nine = 7'b001_0000,
    a = 7'b000_1000,b = 7'b000_0011,c = 7'b100_0110,d = 7'b010_0001,e = 7'b000_0110, f = 7'b000_1110;

always @ (posedge clk1) begin
    if(SW[0]) begin                 //2位数显示
        cnt <= cnt + 1'b1;
        if(num == 4'd2) begin
            num <= 0;
        end
        else if(cnt == 16'hffff) begin
            num <= num + 1'b1;
        end
    end
    else if(SW[1]) begin            //5位数显示
        cnt <= cnt + 1'b1;
        if(num == 4'd5) begin
            num <= 0;
        end
        else if(cnt == 16'hffff) begin
            num <= num + 1'b1;
        end
    end
end

always @(*) begin
    if(SW[0]) begin
        case(num)
            1:begin
                case(dis_data[7:4])
                    0 : seg <= zero;
                    1 : seg <= one;
                    2 : seg <= two;
                    3 : seg <= three;
                    4 : seg <= four;
                    5 : seg <= five;
                    6 : seg <= six;
                    7 : seg <= seven;
                    8 : seg <= eigth;
                    9 : seg <= nine;
                    10: seg <= a;
                    11: seg <= b;
                    12: seg <= c;
                    13: seg <= d;
                    14: seg <= e;
                    15: seg <= f;
                    default:seg <= 7'b1111111;
                endcase  
                dig <= AN1;
            end
            0: begin
                case(dis_data[3:0])
                    0 : seg <= zero;
                    1 : seg <= one;
                    2 : seg <= two;
                    3 : seg <= three;
                    4 : seg <= four;
                    5 : seg <= five;
                    6 : seg <= six;
                    7 : seg <= seven;
                    8 : seg <= eigth;
                    9 : seg <= nine;
                    10: seg <= a;
                    11: seg <= b;
                    12: seg <= c;
                    13: seg <= d;
                    14: seg <= e;
                    15: seg <= f;
                    default:seg <= 7'b1111111;
                endcase
                dig <= AN0;
            end
        endcase
    end
    
    else if(SW[1]) begin
        case(num)
            4:begin
                case(dis_data[15])    //正负号
                    0 : seg <= 7'b111_1111;
                    1 : seg <= 7'b011_1111;
                endcase  
                dig <= AN4;
            end
            3:begin
                case(huns)
                    0 : seg <= zero;
                    1 : seg <= one;
                    2 : seg <= two;
                    3 : seg <= three;
                    4 : seg <= four;
                    5 : seg <= five;
                    6 : seg <= six;
                    7 : seg <= seven;
                    8 : seg <= eigth;
                    9 : seg <= nine;
                    default:seg <= 7'b1111111;
                endcase  
                dig <= AN3;
            end
            2:begin
                case(tens)
                    0 : seg <= zero;
                    1 : seg <= one;
                    2 : seg <= two;
                    3 : seg <= three;
                    4 : seg <= four;
                    5 : seg <= five;
                    6 : seg <= six;
                    7 : seg <= seven;
                    8 : seg <= eigth;
                    9 : seg <= nine;
                    default:seg <= 7'b1111111;
                endcase  
                dig <= AN2;
            end
            1:begin
                case(ones)
                    0 : seg <= zero;
                    1 : seg <= one;
                    2 : seg <= two;
                    3 : seg <= three;
                    4 : seg <= four;
                    5 : seg <= five;
                    6 : seg <= six;
                    7 : seg <= seven;
                    8 : seg <= eigth;
                    9 : seg <= nine;
                    default:seg <= 7'b1111111;
                endcase  
                dig <= AN1;
            end
            0: begin
                seg <= c;
                dig <= AN0;
            end
        endcase
    end
end

endmodule
