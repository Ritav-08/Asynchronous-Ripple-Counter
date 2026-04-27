`timescale 1ns / 1ps

module aCounter(
   input mode_i,  //0 (UP), 1 (DOWN)
   input clk_i, 
   input rst_i, 
   output [3:0]dout_o
);

//instantiation
wire Qa;
wire Qb;
wire Qc;
wire Qd;
wire QaBar;
wire QbBar;
wire QcBar;
wire QdBar;
wire clkb;
wire clkc;
wire clkd;

//internal connections
assign clkb = mode_i? QaBar : Qa;
assign clkc = mode_i? QbBar : Qb;
assign clkd = mode_i? QcBar : Qc;

assign dout_o = {Qd, Qc, Qb, Qa};

//Structural connections
JKff FF1(.J_i(1'b1), 
   .K_i(1'b1), 
   .clk_i(clk_i), 
   .rst_i(rst_i), 
   .Q_o(Qa), 
   .Qbar_o(QaBar)
);
JKff FF2(.J_i(1'b1), 
   .K_i(1'b1), 
   .clk_i(clkb), 
   .rst_i(rst_i), 
   .Q_o(Qb), 
   .Qbar_o(QbBar)
);
JKff FF3(.J_i(1'b1), 
   .K_i(1'b1), 
   .clk_i(clkc), 
   .rst_i(rst_i), 
   .Q_o(Qc), 
   .Qbar_o(QcBar)
);
JKff FF4(.J_i(1'b1), 
   .K_i(1'b1), 
   .clk_i(clkd), 
   .rst_i(rst_i), 
   .Q_o(Qd), 
   .Qbar_o(QdBar)
);

endmodule

module JKff(
   input J_i, 
   input K_i, 
   input clk_i, 
   input rst_i, 
   output reg Q_o, 
   output Qbar_o
);

assign Qbar_o = ~Q_o;

always@(posedge clk_i) begin
   if(rst_i)  //common if (reset) statement in both designs
      Q_o <= 1'b0;
      
//Design 1
//   else if(J_i && K_i)
//      Q_o <= ~Q_o;
//   else if(J_i == 1'b1 && K_i == 1'b0)
//      Q_o <= 1'b1;
//   else if(J_i == 1'b0 && K_i == 1'b1)
//      Q_o <= 1'b0; */

//Design 2
   else begin
      case({J_i, K_i})
         2'b00: Q_o <= Q_o;
         2'b01: Q_o <= 1'b0;
         2'b10: Q_o <= 1'b1;
         2'b11: Q_o <= ~Q_o;
         default: Q_o <= Q_o;
      endcase
   end
end

endmodule
