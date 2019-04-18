`timescale 1ns / 1ps


module tb_execution();
   
   localparam NB_BITS = 32; /* asigancion de parametro local */
   localparam NB_ALU_OP_CTL = 4;
   localparam NB_FUNCTION = 6;

   reg        i_clk;
   
   reg [1:0]   i_mux_a_hz; 
   reg [1:0]   i_mux_b_hz;
   reg [NB_BITS-1:0]  i_ex_mem_reg_hz; 
   reg [NB_BITS-1:0]  i_mem_wb_reg_hz; 
   
   reg [NB_ALU_OP_CTL:0]  i_alu_op_ctl; 
   reg [1:0]              i_mux_rs_ctl; 
   reg                    i_mux_rt_ctl ;
   reg                    i_mux_dest_ctl; 
   
   reg [4:0]              i_rt           ; 
   reg [4:0]              i_rd            ;
   reg [NB_BITS-1:0]      i_sign_ext ;
   reg [NB_BITS-1:0]      i_rt_reg ;
   reg [NB_BITS-1:0]      i_rs_reg ;
   reg [NB_BITS-1:0]      i_pc_4 ;
   reg [7:0]              i_wb_ctl;
   reg [7:0]              i_mem_ctl;
   reg [NB_FUNCTION-1:0]  i_function; 

   wire [NB_BITS-1:0] o_alu_out;
   wire [NB_BITS-1:0] o_data_reg;
   wire [4:0]         o_reg_dst;
   wire [7:0]         o_wb_ctl;
   wire [7:0]         o_mem_ctl;

   localparam DEF_WB_MEM_CTL = 8'd0;
   //opciones para mux a
   localparam PC_TO_A   = 2'b00;
   localparam RS_TO_A   = 2'b01;
   localparam SEXT_TO_A = 2'b10;
   
   //opciones para mux b
   localparam RT_TO_B     = 1'b0;
   localparam SEXT_TO_B   = 1'b1;

   //opciones del mux para hazzard unit
   localparam FROM_ID_EX  = 2'b00;
   localparam FROM_EX_MEM = 2'b01;
   localparam FROM_MEM_WB = 2'b10;

   //opcines para elegir registro destino
   localparam DEST_FROM_RD = 1'b0;
   localparam DEST_FROM_RT = 1'b1;

   //posibles funciones en la instruccion
   localparam FUNC_SLL  = 6'b000000; // 
   localparam FUNC_SRL  = 6'b000010; //  
   localparam FUNC_SRA  = 6'b000011; //  
   localparam FUNC_SLLV = 6'b000100; //  
   localparam FUNC_SRLV = 6'b000110; //  
   localparam FUNC_SRAV = 6'b000111; //  
   localparam FUNC_JR   = 6'b001000; //  
   localparam FUNC_JALR = 6'b001001; //  
   localparam FUNC_ADDU = 6'b100001; //  
   localparam FUNC_SUBU = 6'b100011; //  
   localparam FUNC_AND  = 6'b100100; //  
   localparam FUNC_OR   = 6'b100101; //  
   localparam FUNC_XOR  = 6'b100110; //  
   localparam FUNC_NOR  = 6'b100111; //  
   localparam FUNC_SLT  = 6'b101010; //   

   //posibles combinaciones para Alu control
   localparam OP_ADD  = 4'b0000;//
   localparam OP_FUNC = 4'b0010;//   
   localparam OP_SUB  = 4'b0001;//
   localparam OP_ANDI = 4'b0100;//
   localparam OP_ORI  = 4'b0101;//
   localparam OP_XORI = 4'b0110;//
   localparam OP_LUI  = 4'b0111;//
   localparam OP_NONE = 4'b1000;//
   localparam OP_SLTI = 4'b1000;//
   localparam OP_JAL  = 4'b1001;//

   //valores harcoded para test
   localparam RS_DATA  = 32'd7;
   localparam RT_DATA  = 32'd15;
   localparam SIGN_EXT = 32'd5;
   localparam PC_4       = 32'd55;
   localparam RT       = 5'd0;
   localparam RD       = 5'd31;



   initial begin
      i_clk = 1'b0;
      //valores de registro destino precargados
      i_wb_ctl  = DEF_WB_MEM_CTL;
      i_mem_ctl = DEF_WB_MEM_CTL;
      //incio de entradas desde hazzard
      i_mux_a_hz      = FROM_ID_EX;
      i_mux_b_hz      = FROM_ID_EX;
      i_ex_mem_reg_hz = 0;
      i_mem_wb_reg_hz = 0;

      //inicio los valores que vienen desde control
      i_alu_op_ctl   = OP_FUNC;  
      i_mux_rs_ctl   = RS_TO_A;
      i_mux_rt_ctl   = RT_TO_B;
      i_mux_dest_ctl = DEST_FROM_RD;

      //inicio los valores que vienen desde ID/EX
      i_rt       = RT;
      i_rd       = RD;
      i_sign_ext = SIGN_EXT;
      i_rt_reg   = RT_DATA;
      i_rs_reg   = RS_DATA;
      i_pc_4     = PC_4;
      i_function = 6'd0;

      // test de tods las funciones en la instruccion
     
      #10
      i_function = FUNC_SLL;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #1
      if(o_alu_out == (RT_DATA<<SIGN_EXT))
         $display("Test SLL OK");
      else
         $display("Test Fail");

      #10
      i_function = FUNC_SRL;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #1
      if(o_alu_out == (RT_DATA>>SIGN_EXT))
         $display("Test SRL OK");
      else
         $display("Test Fail");


      #10
      i_function = FUNC_SRA;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #1
      if(o_alu_out == (RT_DATA>>>SIGN_EXT))
         $display("Test SRA OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_SLLV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RT_DATA<<RS_DATA))
         $display("Test SLLV OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_SRLV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RT_DATA>>RS_DATA))
         $display("Test SRLV OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_SRAV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RT_DATA>>>RS_DATA))
         $display("Test SRAV OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_JR; 
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (31'b0))
         $display("Test JR OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_JALR;
      i_mux_rs_ctl = PC_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (PC_4+4))
         $display("Test JALR OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_ADDU;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RS_DATA+RT_DATA))
         $display("Test ADDU OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_SUBU;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RS_DATA-RT_DATA))
         $display("Test SUBU OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_AND;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RS_DATA&RT_DATA))
         $display("Test AND OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_OR ;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RS_DATA|RT_DATA))
         $display("Test OR OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_XOR;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == (RS_DATA^RT_DATA))
         $display("Test XOR OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_NOR;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #1
      if(o_alu_out == ~(RS_DATA|RT_DATA))
         $display("Test NOR OK");
      else
         $display("Test Fail");



      #10
      i_function = FUNC_SLT;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B; 
      #1
      if(o_alu_out == (1))
         $display("Test STL OK");
      else
         $display("Test Fail");


      #10 $finish;
   end

   always #2.5 i_clk = ~i_clk;

      Execution_module #(
         .NB_BITS(NB_BITS),
         .NB_ALU_OP_CTL(NB_ALU_OP_CTL),
         .NB_FUNCTION(NB_FUNCTION)
      ) inst_Execution_module (
         .o_alu_out       (o_alu_out),
         .o_data_reg      (o_data_reg),
         .o_reg_dst       (o_reg_dst),
         .o_wb_ctl        (o_wb_ctl),
         .o_mem_ctl       (o_mem_ctl),
         .i_mux_a_hz      (i_mux_a_hz),
         .i_mux_b_hz      (i_mux_b_hz),
         .i_ex_mem_reg_hz (i_ex_mem_reg_hz),
         .i_mem_wb_reg_hz (i_mem_wb_reg_hz),
         .i_alu_op_ctl    (i_alu_op_ctl),
         .i_mux_rs_ctl    (i_mux_rs_ctl),
         .i_mux_rt_ctl    (i_mux_rt_ctl),
         .i_mux_dest_ctl  (i_mux_dest_ctl),
         .i_rt            (i_rt),
         .i_rd            (i_rd),
         .i_sign_ext      (i_sign_ext),
         .i_rt_reg        (i_rt_reg),
         .i_rs_reg        (i_rs_reg),
         .i_pc_4          (i_pc_4),
         .i_function      (i_function),
         .i_wb_ctl        (i_wb_ctl),
         .i_mem_ctl       (i_mem_ctl),
         .i_clk           (i_clk),
         .i_rst           (i_rst)
      );

endmodule
