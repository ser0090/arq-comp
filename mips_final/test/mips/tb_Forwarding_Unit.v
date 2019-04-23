
`timescale 1ns/1ps

module tb_Forwarding_Unit (); /* this is automatically generated */

	reg i_rst;
	reg i_clk;

	
	reg [4:0] i_ex_mem_rd;
	reg [4:0] i_mem_wb_rd;
	reg [4:0] i_id_ex_rs;
	reg [4:0] i_id_ex_rt;
	reg       i_ex_mem_wr_en;
	reg       i_mem_wb_wr_en;

	wire [1:0] o_mux_a_hz;
	wire [1:0] o_mux_b_hz;

	localparam FROM_ID_EX  = 2'b00;
	localparam FROM_EX_MEM = 2'b01;
	localparam FROM_MEM_WB = 2'b10;

	localparam REG_0 = 5'd0;
	localparam REG_4 = 5'd4;
	localparam REG_12 = 5'd12;
	localparam REG_14 = 5'd14;

	localparam ENABLE = 1'b1;
	localparam DISABLE = 1'b0;

	// clock
	initial begin
	#1

	/* test forwarding ex/mem */
	i_ex_mem_wr_en = ENABLE;
	i_mem_wb_wr_en = DISABLE;
	i_id_ex_rs = REG_14;
	i_id_ex_rt = REG_12;

	i_ex_mem_rd = REG_4;
	i_mem_wb_rd = REG_4;
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_ID_EX)
         $display("Forward from ex/mem(1) Test OK");
      else
         $display("Forward from ex/mem(1)\n    expected:  %b\n    out_a:%b\n    out_b:%b",FROM_ID_EX,o_mux_a_hz,o_mux_b_hz);

    #1
    i_ex_mem_rd = REG_0;
	i_mem_wb_rd = REG_4;
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_ID_EX)
         $display("Forward from ex/mem(2) Test OK");
      else
         $display("Forward from ex/mem(2)\n    expected:  %b\n    out_a:%b\n    out_b:%b",FROM_ID_EX,o_mux_a_hz,o_mux_b_hz);

    #1
    i_ex_mem_rd = REG_14;
	i_mem_wb_rd = REG_4;
	#2
	if(o_mux_a_hz == FROM_EX_MEM && o_mux_b_hz == FROM_ID_EX)
         $display("Forward from ex/mem(3) Test OK");
      else
         $display("Forward from ex/mem(3)\n    expected:  %b\n    out_a:%b",FROM_EX_MEM,o_mux_a_hz);

    #1
    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_4;
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_EX_MEM)
         $display("Forward from ex/mem(4) Test OK");
      else
         $display("Forward from ex/mem(4)\n    expected:  %b\n    out_b:%b",FROM_EX_MEM,o_mux_b_hz);

    #1


    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_12;
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_EX_MEM)
         $display("Forward from ex/mem(5) Test OK");
      else
         $display("Forward from ex/mem(5)\n    expected:  %b\n    out_b:%b",FROM_EX_MEM,o_mux_b_hz);

    #1
    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_12;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = ENABLE; 
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_EX_MEM)
         $display("Forward from ex/mem(6) Test OK");
      else
         $display("Forward from ex/mem(6)\n    expected:  %b\n    out_b:%b",FROM_EX_MEM,o_mux_b_hz);

    #1

    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_12;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = ENABLE; 
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_EX_MEM)
         $display("Forward from ex/mem(7) Test OK");
    else
         $display("Forward from ex/mem(7)\n    expected:  %b\n    out_b:%b",FROM_EX_MEM,o_mux_b_hz);

    #1
    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_12;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = DISABLE; 
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_MEM_WB)
         $display("Forward from ex/mem(8) Test OK");
      else
         $display("Forward from ex/mem(8)\n    expected:  %b\n    out_b:%b",FROM_MEM_WB,o_mux_b_hz);

    #1

    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_12;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = DISABLE; 
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_MEM_WB)
         $display("Forward from ex/mem(9) Test OK");
      else
         $display("Forward from ex/mem(9)\n    expected:  %b\n    out_b:%b",FROM_MEM_WB,o_mux_b_hz);

    #1

    i_ex_mem_rd = REG_14;
	i_mem_wb_rd = REG_14;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = DISABLE; 
	#2
	if(o_mux_a_hz == FROM_MEM_WB && o_mux_b_hz == FROM_ID_EX)
         $display("Forward from ex/mem(10) Test OK");
      else
         $display("Forward from ex/mem(10)\n    expected:  %b\n    out_a:%b",FROM_MEM_WB,o_mux_a_hz);

    #1
    i_ex_mem_rd = REG_12;
	i_mem_wb_rd = REG_0;
	i_mem_wb_wr_en = ENABLE;
	i_ex_mem_wr_en = DISABLE; 
	#2
	if(o_mux_a_hz == FROM_ID_EX && o_mux_b_hz == FROM_ID_EX)
         $display("Forward from ex/mem(9) Test OK");
      else
         $display("Forward from ex/mem(1)\n    expected:  %b\n    out_a:%b\n    out_b:%b",FROM_ID_EX,o_mux_a_hz,o_mux_b_hz);

    #1

    $finish;


end

	// (*NOTE*) replace reset, clock, others

	
	
	

	always #2.5 i_clk = ~i_clk;

Forwarding_Unit inst_Forwarding_Unit
		(
			.o_mux_a_hz     (o_mux_a_hz),
			.o_mux_b_hz     (o_mux_b_hz),
			.i_ex_mem_rd    (i_ex_mem_rd),
			.i_mem_wb_rd    (i_mem_wb_rd),
			.i_id_ex_rs     (i_id_ex_rs),
			.i_id_ex_rt     (i_id_ex_rt),
			.i_ex_mem_wr_en (i_ex_mem_wr_en),
			.i_mem_wb_wr_en (i_mem_wb_wr_en)
		);
	

endmodule
