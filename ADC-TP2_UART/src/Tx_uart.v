`timescale 1ns / 1ps

module Tx_uart #(
             parameter NB_BITS = 8 /* asigancion de parametro local */
             )(
               output o_tx,
               output o_tx_done,
               input i_data_ready,
               input i_clk,
               input i_rate,
               input i_rst,
               [NB_BITS:0]  i_data /* N bits more carry */
               );

localparam idle = 1'b0;
localparam sending = 1'b1;

reg tx_done;
reg tx;
reg state;
reg next_state;
reg [3:0] data_count;
reg [4:0] time_count;
reg [NB_BITS+1:0] shift_register; // tamaño NB_BITs + bit start + bit stop

assign o_tx = tx;
assign o_tx_done = tx_done;

always @(posedge i_clk or posedge i_rst) begin

	if (i_rst) begin
		state <= idle;
		next_state <= idle;
		data_count <= 4'h0;
		shift_register <= {NB_BITS+2{1'b1}};
		tx_done <= 1'b0;
		tx <= 1'b1;
		time_count <= 5'h0;
	end
	else if(i_rate == 1'b1) begin 	
      	time_count <= time_count + 1;
	end
	state <= next_state;
	tx_done <= 1'b0;
end


always @(*) begin
  case (state)
    idle: begin
            if(i_data_ready == 1'b1)begin
            	shift_register = {i_data,1'b0}; //StopBit + data + StartBit
            	shift_register[NB_BITS+1] = 1'b1;
            	data_count = 4'h0;
            	next_state = sending;
            	time_count = 5'h0;
            end
            else
            	next_state = next_state;
            	
          end

    sending: begin
           	    if(data_count == NB_BITS + 2)begin
           	    	tx_done = 1'b1;
           	    	next_state = idle;
           	    end	
           	    else if(time_count[4] == 1'b1) begin
           	    	{shift_register,tx} = {shift_register,tx} >> 1;
           	    	data_count = data_count + 1;
           	    	time_count[4] = 1'b0;
           	    end
           	    else begin
           	    	next_state = next_state;
           	    	data_count = data_count;
           	    	tx_done = tx_done;
           	    	tx = tx;
           	    end
            	
          end
  endcase
end

endmodule