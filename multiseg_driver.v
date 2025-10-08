`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 01:33:44 PM
// Design Name: 
// Module Name: multiseg_driver
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
module multiseg_driver (
   input clk,                // 100 MHz FPGA clock
   input [11:0] bin_in,      // binary input (0-4095)
   output [3:0] seg_anode,   // active-LOW anodes
   output [6:0] seg_cathode  // active-LOW cathodes
);
   // Wires for BCD digits
   wire [3:0] ones, tens, hundreds, thousands;
   wire [15:0] bcd_in;
   wire [3:0] bcd_val;


   // Convert binary to BCD
   Bin2BCD u_b2b (
       .bin(bin_in),
       .ones(ones),
       .tens(tens),
       .hundreds(hundreds),
       .thousands(thousands)
   );


   assign bcd_in = {thousands, hundreds, tens, ones};


   // Select active digit + drive anode
   anode_generator u_anode_gen (
       .clk(clk),
       .bcd_in(bcd_in),
       .seg_anode(seg_anode),
       .bcd_out(bcd_val)
   );


   // Decode BCD digit into segment pattern
   seg_decoder u_seg_dec (
       .binary(bcd_val),
       .seg_cathode(seg_cathode)
   );
endmodule

// Binary to BCD (Double Dabble algorithm)
module Bin2BCD (
   input [11:0] bin,       // 12-bit binary input
   output reg [3:0] ones,
   output reg [3:0] tens,
   output reg [3:0] hundreds,
   output reg [3:0] thousands
);
   integer i;
   reg [27:0] shift_reg;


   always @* begin
       shift_reg = 28'd0;
       shift_reg[11:0] = bin;


       for (i = 0; i < 12; i = i + 1) begin
           if (shift_reg[15:12] >= 5) shift_reg[15:12] = shift_reg[15:12] + 3;
           if (shift_reg[19:16] >= 5) shift_reg[19:16] = shift_reg[19:16] + 3;
           if (shift_reg[23:20] >= 5) shift_reg[23:20] = shift_reg[23:20] + 3;
           if (shift_reg[27:24] >= 5) shift_reg[27:24] = shift_reg[27:24] + 3;
           shift_reg = shift_reg << 1;
       end


       ones      = shift_reg[15:12];
       tens      = shift_reg[19:16];
       hundreds  = shift_reg[23:20];
       thousands = shift_reg[27:24];
   end
endmodule

// Anode generator: scans through 4 digits
module anode_generator (
   input clk,
   input [15:0] bcd_in,
   output reg [3:0] seg_anode,
   output reg [3:0] bcd_out
);
   reg [15:0] counter = 0;
   reg [1:0] sel = 0;


   always @(posedge clk) begin
       counter <= counter + 1;
       if (counter == 16'd50000) begin  // refresh rate
           counter <= 0;
           sel <= sel + 1;
       end
   end


   always @* begin
       seg_anode = 4'b1111; // all off
       case(sel)
           2'd0: begin seg_anode = 4'b1110; bcd_out = bcd_in[3:0];   end
           2'd1: begin seg_anode = 4'b1101; bcd_out = bcd_in[7:4];   end
           2'd2: begin seg_anode = 4'b1011; bcd_out = bcd_in[11:8];  end
           2'd3: begin seg_anode = 4'b0111; bcd_out = bcd_in[15:12]; end
       endcase
   end
endmodule


// Seven-seg decoder (active LOW) for digits 0-9 use this version

module seg_decoder(
   input  [3:0] binary,
   output reg [6:0] seg_cathode
);
   always @* begin
       case (binary)
           4'd0: seg_cathode = 7'b1000000; // 0
           4'd1: seg_cathode = 7'b1111001; // 1
           4'd2: seg_cathode = 7'b0100100; // 2
           4'd3: seg_cathode = 7'b0110000; // 3
           4'd4: seg_cathode = 7'b0011001; // 4
           4'd5: seg_cathode = 7'b0010010; // 5
           4'd6: seg_cathode = 7'b0000010; // 6
           4'd7: seg_cathode = 7'b1111000; // 7
           4'd8: seg_cathode = 7'b0000000; // 8
           4'd9: seg_cathode = 7'b0010000; // 9
           default: seg_cathode = 7'b1111111; // blank
       endcase
   end
endmodule

