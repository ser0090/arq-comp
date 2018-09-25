`timescale 1ns / 1ps

module Tx_uart #
  (
   parameter NB_BITS = 8 /* asigancion de parametro local */
   )
   (
    output              o_tx,
    output              o_tx_done,
    input               i_data_ready,
    input               i_clk,
    input               i_rate,
    input               i_rst,
    input [NB_BITS-1:0] i_data /* N bits more carry */
    );

   localparam idle = 1'b0;
   localparam sending = 1'b1;
   
   reg                tx_done;
   reg                tx;
   reg                state;
   reg                next_state;
   reg [3:0]          data_count;
   reg [4:0]          time_count;
   reg [NB_BITS+1:0]  shift_register; // tamaño NB_BITs + bit start + bit stop

   assign o_tx = tx;
   assign o_tx_done = tx_done;

   always @(posedge i_clk) begin
	    if (i_rst) begin
		     state <= idle;
		     data_count <= 4'h0;
		     shift_register <= {NB_BITS+2{1'b1}};
		     tx_done <= 1'b0;
		     tx <= 1'b1;
		     time_count <= 5'h0;
	    end
	    else begin
         if(i_rate == 1'b1) begin 	
      	    time_count <= time_count + 1;
	       end
         else begin
            time_count <= time_count;
         end
         
         case (state)
           idle: begin
	            tx_done <= 1'b0;
              if(i_data_ready == 1'b1)begin
                 shift_register[NB_BITS:0] <= {i_data,1'b0}; //StopBit + data + StartBit
                 shift_register[NB_BITS+1] <= 1'b1;
                 data_count <= 4'h0;
                 state <= sending;
                 time_count <= 5'h0;
              end
              else begin
                 state <= state;
                 shift_register <= shift_register;
                 data_count <= data_count;
                 state <= state;
                 //time_count <= time_count;
              end // else: !if(i_data_ready == 1'b1)
           end // case: idle
           
           sending: begin
           	  if(data_count == NB_BITS + 2)begin
           	     tx_done <= 1'b1;
           	     state <= idle;
           	  end
           	  else if(time_count[4] == 1'b1) begin
           	     {shift_register,tx} <= {shift_register,tx} >> 1;
           	     data_count <= data_count + 1;
           	     time_count[4] <= 1'b0;
           	  end
           	  else begin
           	     state <= state;
           	     data_count <= data_count;
                 //time_count <= time_count;
                 shift_register <= shift_register;
           	     tx_done <= tx_done;
           	     tx <= tx;
           	  end // else: !if(time_count[4] == 1'b1)
           end // case: sending
         endcase // case (state)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)
   
endmodule // Tx_uart
