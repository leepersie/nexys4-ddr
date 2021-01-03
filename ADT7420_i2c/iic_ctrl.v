`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/31 14:43:30
// Design Name: 
// Module Name: iic_ctrl
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


module iic_ctrl(
    input CLK_100,
    input RSTn,
    input [1:0] SW,
    input [7:0] Data_in,
    output [7:0] dig,
    output [6:0] seg,
    output SCL,
    inout SDA
    );

wire [15:0] RdData;
reg [7:0] WrDate;
reg [15:0] dig_date;
wire Done_Sig;
reg [3:0] i,j;
reg [7:0] rAddr;
reg [2:0] isStart;          //state selector
reg [31:0] cnt;
reg [7:0] valid_values;
wire [3:0] ones,tens,huns;

always @ ( posedge CLK_100 or negedge RSTn ) begin
    if( !RSTn ) begin
        i <= 4'd0;
        j <= 4'b0;
        rAddr <= 8'd0;
        isStart <= 3'b000;
        dig_date <= 15'd0;
        cnt <= 32'd0;
    end
    else begin
        if(SW[0]) begin                     //先写入温度传感器的0x03寄存器,再从0x03读出来
            j <= 4'b0;
            case( i )
                0:
                    if( Done_Sig ) begin isStart <= 3'b000; i <= i + 1'b1; end
                    else begin isStart <= 3'b001; WrDate <= Data_in; rAddr <= 8'd3; end
                1:
                    if( Done_Sig ) begin isStart <= 3'b000; i <= i + 1'b1; end
                    else begin isStart <= 3'b010; rAddr <= 8'd3; end
                2:
                    begin  i<= 4'd0; dig_date <= RdData; end
            endcase
        end
        else if(SW[1]) begin                //0.5秒读一次温度传感器的温度值
            i <= 4'b0;
            case( j )
                0: begin
                    if( Done_Sig ) begin isStart <= 3'b000; j <= j + 1'b1; end
                    else begin isStart <= 3'b100; rAddr <= 8'h00; end
                end
                1: begin
                    dig_date <= RdData;
                    cnt <= cnt + 1'b1;
                    if(cnt == 32'd499_999_999) begin
                        cnt <= 32'd0;
                        j <= 4'd0;
                    end
                end
            endcase
        end
    end
end

always @ (posedge CLK_100 or negedge RSTn) begin  //读温度的有效位，并将负数数据转换
    if(!RSTn) begin
        valid_values <= 8'b0;
    end
    else begin
        if(SW[1]) begin
            if(valid_values[15]) valid_values <= ~(dig_date[14:7]) + 1'b1;
            else valid_values <= dig_date[14:7];
        end
    end
end

iic U1(                           //IIC读写
    .CLK(CLK_100),
    .RSTn(RSTn),
    .Start_Sig(isStart),
    .Addr_Sig(rAddr),
    .WrData(WrDate),
    .RdData(RdData),
    .Done_Sig(Done_Sig),
    .SCL(SCL),
    .SDA(SDA)
);
dig U2(                           //数码管显示
    .clk1(CLK_100),
    .dig(dig),
    .seg(seg),
    .dis_data(dig_date),
    .ones(ones),
    .tens(tens),
    .huns(huns),
    .SW(SW)
    );
    
bcd U3(                           //2进制转bcd码
        .clk(CLK_100),
        .rst_n(RSTn),
        .cnt(cnt),
        .bin(valid_values),
        .one(ones),
        .ten(tens),
        .hun(huns)
        );
endmodule
