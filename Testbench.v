`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 19:56:59
// Design Name: 
// Module Name: tb_aCounter
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


module tb_aCounter();
reg mode_ti;
reg clk_ti;
reg rst_ti; 
wire [3:0]dout_to;

//net(s)
integer count;
integer pass;
integer fail;
reg [3:0]exp_dout;

//instantiation
aCounter UUT(.mode_i(mode_ti), 
   .clk_i(clk_ti),
   .rst_i(rst_ti),  
   .dout_o(dout_to));

//feeding 
initial begin
mode_ti = 1'b1;
#180 @(posedge clk_ti) mode_ti = 1'b0;
#180 @(posedge clk_ti) mode_ti = 1'b1;
#100 @(posedge clk_ti) mode_ti = 1'b0;
#50 @(posedge clk_ti) mode_ti = 1'b1;
#25 @(posedge clk_ti) mode_ti = 1'b0;

#5 $display("-----------");
$display("Checks: %d, | Pass: %d, Fail: %d", count, pass, fail);
$display("-----------");
#5 $finish;
end

//initialization
initial begin
exp_dout = 4'b0000;
count = 0;
pass = 0;
fail = 0;
end

//capture
initial begin
//$monitor("Time=%0t | mode=%b | dout=%b", $time, mode_ti, dout_to);
$dumpfile("aCounter.vcd");
$dumpvars(0, tb_aCounter);
end

//clock
initial begin
   clk_ti = 1'b0;
   forever
      #5 clk_ti = ~clk_ti;
end

//Reset
initial begin
   rst_ti = 1'b1;
   #10 rst_ti = 1'b0;
end

//auto check
task check; begin 
   if(mode_ti) //UP
      exp_dout = exp_dout + 1;
   else //DOWN
      exp_dout = exp_dout - 1;

   if((exp_dout !== dout_to)) begin //result matching (mismatch)
      $display("Error | Time: %0t, Clock: %b, Reset: %b | Output: %d | Expected Output: %d", $time, clk_ti, rst_ti, dout_to, exp_dout);
      fail = fail + 1;
   end
   else begin////result matching (match)
      pass = pass + 1;
   end
   count = count + 1; //number of checks performed
end
endtask

//running auto checker
always@(posedge clk_ti)
   if(rst_ti)
      exp_dout = 4'b0000;
   else
      #7 check;

endmodule 