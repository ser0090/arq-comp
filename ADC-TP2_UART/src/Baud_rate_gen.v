`timescale 1ns / 1ps

module Baud_rate_gen #
  (
   parameter CLK = 100,
   parameter BAUD = 250000,
   localparam CYCLES = (CLK*10**6)/(BAUD*16)
   )
   (
    output o_rate,
    input  i_clk,
    input  i_rst
    );

   reg [clog2(CYCLES)-1:0] counter;
   reg                     rate;

   assign o_rate = rate;
   
   always @(posedge i_clk or posedge i_rst) begin
      if(i_rst) begin
         rate <= 1'b0;
         counter <= 0;
      end
      else begin
         if(counter >= CYCLES) begin
            counter <= 0;
            rate <= 1'b1;
         end
         else begin
            counter <= counter + 1;
            rate <= 1'b0;
         end
      end // else: !if(i_rst)
   end // always @ (posedge i_clk or posedge i_rst)

   /**
    * Funcion clog2 , Calcula el logaritmo base 2
    */
   function integer clog2;
      input integer   depth;
      for (clog2=0; depth>0; clog2=clog2+1)
        depth = depth >> 1;
   endfunction // clog2
   
endmodule // Baud_rate_gen

