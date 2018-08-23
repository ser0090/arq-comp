`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8
`define NB_OPE 6

module Top #(
   parameter NB_BITS = `NB_BITS,
   parameter NB_OPE = `NB_OPE 
   )(
    output [NB_BITS-1:0] o_led,
    input [NB_BITS-1:0]  i_sw,
	input [2:0]          i_bnt,
	input                i_clk,
	input                i_rst
 	);
   
    reg [NB_BITS-1:0]    reg_a;
    reg [NB_BITS-1:0]    reg_b;
    reg [NB_OPE-1:0]     reg_op;

	always @(posedge i_clk) begin
    	if (i_rst) begin
			reg_a <= 8'h00;
			reg_b <= 8'h00;
			reg_op <= 6'h00;
		end
		else begin
			case(i_bnt)
				3'b001: reg_a <= i_sw;
				3'b010: reg_b <= i_sw;
				3'b100: reg_op <= i_sw[5:0];
				default: begin
             		reg_a <= reg_a;
             		reg_b <= reg_b;
             		reg_op <= reg_op;
          		end
        	endcase // case (i_bnt)
	    end
	end // always @ (posedge i_clk)
   
   Alu #(.NB_BITS(NB_BITS), .NB_OPE(NB_OPE)) /* asigancion de parametro local */
     	u_alu(.o_led(o_led),
        	  .i_dato_a(reg_a),
           	  .i_dato_b(reg_b),
           	  .i_ope_sel(reg_op));
endmodule
