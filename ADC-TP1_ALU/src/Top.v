`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8
`define NB_OPE 6

module Top #(
   parameter NB_BITS = `NB_BITS,
   parameter NB_OPE = `NB_OPE
   )(
     output [NB_BITS-1:0] o_led,
     output               debug_led,
     input [NB_BITS-1:0]  i_sw,
	 input                i_btnL,
     input                i_btnC,
     input                i_btnR,
     input                i_btnU,
	 input                i_clk
 	);
   
   reg [NB_BITS-1:0]      data_a;
   reg [NB_BITS-1:0]      data_b;
   reg [NB_OPE-1:0]       sel_op;

   wire [2:0]             btn;
   wire                   rst;
   
   assign btn = {i_btnL, i_btnC, i_btnR};
   assign rst = i_btnU;
   
	always @(posedge i_clk) begin
	   if (rst) begin  /* los datos con los que inicializa */
        data_a <= 8'h00;
        data_b <= 8'h00;
        sel_op <= 6'h00;
        end
        else begin
            case(btn)
    		  3'b001: begin /* latch del dato A*/
                data_a <= i_sw;
                data_b <= data_b;
                sel_op <= sel_op;
              end
    		  3'b010: begin /* latch del dato B*/
                data_b <= i_sw;
                data_a <= data_a;
                sel_op <= sel_op;
              end
    		  3'b100: begin /* latch del codigo de operacion*/
                sel_op <= i_sw[5:0];
                data_a <= data_a;
                data_b <= data_b;
              end
    		  default: begin /* Manter el estado anterior */
                data_a <= data_a;
                data_b <= data_b;
                sel_op <= sel_op;
              end
            endcase // case (i_btn)
        end // else (rst)
	end // always @ (posedge i_clk)
   
   Alu #(.NB_BITS(NB_BITS), .NB_OPE(NB_OPE)) /* asigancion de parametro a la instancia */
      u_alu(.o_led({debug_led, o_led}),
        	.i_dato_a(data_a),
            .i_dato_b(data_b),
           	.i_ope_sel(sel_op));
endmodule
