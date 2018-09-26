`timescale 1ns / 1ps

module Interface_Circuit #
  (
   parameter NB_BITS = 8,
   parameter NB_SEL = 6,
   parameter LEN = 3,
   localparam NB_STATE = 3
   )
  (
    output [NB_BITS-1:0] o_data,
    output               o_tx_start,
    input [NB_BITS-1:0]  i_rx_data,
    input                i_rx_done,
    input                i_tx_done,
    input                i_rst,
    input                i_clk
   );
   
   reg [NB_BITS-1:0]     registers[LEN-1:0]; /* register file */
   reg [NB_STATE-1:0]    state; 	/* estados de FSM */
   reg [NB_BITS-1:0]     out_alu; 	/* reg latch out alu */
   reg                   tx_start; 	/* salida aviso para el TX UART */
   
   reg                   rx_done_prev; /* reg para latch estado previo rx_done */
   reg                   tx_done_prev; /* reg para latch estado previo tx_done */
   
   reg [NB_SEL-1:0]      operator; 	/* cable para salida de la tabla traduct */
   
   wire [NB_BITS-1:0]    from_alu; 	/* wire resultado desde ALU */
   
   integer              ptr; 		/* index to "for" */

   assign o_data = {4'h03, out_alu[3:0]};
   assign o_tx_start = tx_start;
   
   always @(posedge i_clk) begin
      if(i_rst) begin
         /* reset valores del Register File */
         for(ptr = 0; ptr < LEN; ptr = ptr + 1)
            registers[ptr] <= {NB_BITS{1'b0}};
         
         state <= {NB_STATE{1'b0}};
         out_alu <= {NB_BITS{1'b0}};
         rx_done_prev <= 1'b0;
         tx_done_prev <= 1'b0;
         tx_start <= 1'b0;
      end
      else begin
         
         rx_done_prev <= i_rx_done; /* deteccion de flanco de rx_done */
         tx_done_prev <= i_tx_done; /* deteccion de flanco de tx_done */
         out_alu <= from_alu;
         
         if(state >= 3'd0 && state < 3'd3) begin
            if(i_rx_done && !rx_done_prev && !tx_start) begin
               /* desde el estado e0 - e3 se cargan datos
                             [2]| data_a |
                             [1]|operator|
                i_rx_data ==>[0]| data_b |
                se cargan en el reg[0] y se deplazada a los demas
                se agrupan los estados porque tiene el mismo comportameinto */
               registers[0] <= i_rx_data;
               for( ptr = 1; ptr < LEN; ptr = ptr +1)
                 registers[ptr] <= registers[ptr-1];
              
               state <= state +1;
            end // if (i_rx_done && rx_done_prev == 1'b0)
            else begin
               for( ptr = 0; ptr < LEN-1; ptr = ptr +1)
                 registers[ptr] <= registers[ptr]; /* mantengo el estado anterior */
               
               state <= state;
            end // else: !if(i_rx_done && rx_done_prev == 1'b0)
         end // if (state >= 3'd0 && state < 3'd3)
         else if (state == 3'd3) begin
            tx_start <= 1'b1;
            state <= 3'd4;
         end
         else if(state == 3'd4) begin
            if(i_tx_done && tx_done_prev == 1'b0) begin
               tx_start <= 1'b0;
               state <= 3'd0;
            end
            else begin
               tx_start <= tx_start;
               state <= state;
            end
         end
         else begin
            for( ptr = 0; ptr < LEN-1; ptr = ptr +1)
              registers[ptr] <= registers[ptr]; /* mantengo el estado anterior */
            
            out_alu <= out_alu;
            tx_start <= tx_start;
            state <= state;
         end // else: state
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   always @(*) begin
      case (registers[1])
        8'd43: operator = 6'b100000; /* ADD */
        8'd45: operator = 6'b100010; /* SUB */
        8'd38: operator = 6'b100100; /* AND */
        8'd124: operator = 6'b100101;/* OR  */
        default : operator = 6'd0;
      endcase // case (registers[1])
   end
   
   Alu #(.NB_BITS(NB_BITS), .NB_OPE(NB_SEL))
   u_alu(
         .o_led(from_alu),
			   .i_dato_a  ({4'h0,registers[2][3:0]}),
			   .i_dato_b  ({4'h0,registers[0][3:0]}),
			   .i_ope_sel (operator)
         );
endmodule // Interface_Circuit
