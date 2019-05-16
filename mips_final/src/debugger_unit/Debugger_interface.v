`timescale 1ns / 1ps

module Debugger_interface #()
   (
    output o_debug_enb,   // Retorna un pulso si se esta en modo no continuo
    input  i_continue,    // 1 continuo  - 0 debug espera de pulso
    input  i_valid,       // pulso en modo debugg
    input  i_clk,
    input  i_rst
    );

   /* ##### SECUENCIAL ###### */
   reg                   valid_prev;
   reg                   debug_enb;

   /* ##### OUTPUTS ###### */
   assign o_debug_enb    = debug_enb;

   always @ ( posedge i_clk ) begin
      if(i_rst) begin
         valid_prev  <= 1'b0;
         debug_enb   <= 1'b0;
      end
      else begin
         if (i_continue)
           debug_enb <= 1'b1;
         else begin
            valid_prev  <= i_valid;
            // latch por flanco ascendente
            debug_enb   <= (i_valid && !valid_prev)? 1'b1: 1'b0;
         end
      end // else: !if(i_rst)
   end // always @ ( posedge i_clk )
endmodule // Instr_memory_latch


