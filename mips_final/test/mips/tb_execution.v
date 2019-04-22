`timescale 1ns / 1ps


module tb_execution();
   
   localparam NB_BITS = 32; /* asigancion de parametro local */
   localparam NB_ALU_OP_CTL = 4;
   localparam NB_FUNCTION = 6;

   reg        i_clk;
   reg        i_rst;

   reg [1:0]   i_mux_a_hz; 
   reg [1:0]   i_mux_b_hz;
   reg [NB_BITS-1:0]  i_ex_mem_reg_hz; 
   reg [NB_BITS-1:0]  i_mem_wb_reg_hz; 
   
   reg [NB_ALU_OP_CTL-1:0]  i_alu_op_ctl; 
   reg [1:0]              i_mux_rs_ctl; 
   reg                    i_mux_rt_ctl ;
   reg [1:0]              i_mux_dest_ctl; 
   
   reg [4:0]              i_rt          ; 
   reg [4:0]              i_rd          ;
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
   localparam DEST_TO_RETURN = 2'b10;

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
   localparam OP_SLTI = 4'b0011;//
   localparam OP_JAL  = 4'b1001;//

   //valores harcoded para test
   localparam RS_DATA  = 32'd15;
   localparam RT_DATA  = 32'd7;
   localparam SIGN_EXT = 32'd5;
   localparam PC_4       = 32'd55;
   localparam RT       = 5'd4;
   localparam RD       = 5'd9;



   initial begin
      i_clk = 1'b0;
      i_rst = 1'b1;
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

      #2
      i_rst =1'b0;
     /*
      *     TEST DE OPERACIONES NO INMEDIATAS
      * 
      * las instrucciones probadas 
      */
      $display("\n\n\n");
      $display("******************************************************************************");
      $display("*********  TESTS DE INSTRUCCIONES CON ARGUMENTO EN FUNCION (R-type)***********");
      $display("******************************************************************************");

      #10
      i_function = FUNC_SLL;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #10
      if(o_alu_out == (RT_DATA<<SIGN_EXT)) begin
         $display("SLL Test OK");
         end
      else begin
         $display("SLL Test fail\n    expected:  %b\n    out:%b",RT_DATA<<SIGN_EXT,o_alu_out);
       end
      
      #10
      i_function = FUNC_SRL;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #10
      if(o_alu_out == (RT_DATA>>SIGN_EXT))
         $display("SRL Test OK");
      else
         $display("SRL Test fail\n    expected:  %b\n    out:%b",(RT_DATA>>SIGN_EXT),o_alu_out);


      #10
      i_function = FUNC_SRA;
      i_mux_rs_ctl = SEXT_TO_A;
      i_mux_rt_ctl = RT_TO_B;  
      #10
      if(o_alu_out == (RT_DATA>>>SIGN_EXT))
         $display("SRA Test OK");
      else
         $display("SRA Test fail\n    expected:  %b\n    out:%b",(RT_DATA>>>SIGN_EXT),o_alu_out);



      #10
      i_function = FUNC_SLLV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RT_DATA<<RS_DATA))
         $display("SLLV Test OK");
      else
         $display("SLLV Test fail\n    expected:  %b\n    out:%b",(RT_DATA<<RS_DATA),o_alu_out);



      #10
      i_function = FUNC_SRLV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RT_DATA>>RS_DATA))
         $display("SLRV Test OK");
      else
         $display("SLRV Test fail\n    expected:  %b\n    out:%b",(RT_DATA>>RS_DATA),o_alu_out);



      #10
      i_function = FUNC_SRAV;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RT_DATA>>>RS_DATA))
         $display("SRAV Test OK");
      else
         $display("SRAV Test fail\n    expected:  %b\n    out:%b",RT_DATA>>RS_DATA,o_alu_out);



      #10
      i_function = FUNC_JR; 
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (31'b0))
         $display("JR Test OK");
      else
         $display("JR Test fail\n    expected:  %b\n    out:%b",(31'b0),o_alu_out);



      #10
      i_function = FUNC_JALR;
      i_mux_rs_ctl = PC_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (PC_4+4))
         $display("JALR Test OK");
      else
         $display("JALR Test fail\n    expected:  %b\n    out:%b",PC_4+4,o_alu_out);



      #10
      i_function = FUNC_ADDU;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RS_DATA+RT_DATA))
         $display("ADDU Test OK");
      else
         $display("ADDU Test fail\n    expected:  %b\n    out:%b",(RS_DATA+RT_DATA),o_alu_out);



      #10
      i_function = FUNC_SUBU;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RS_DATA-RT_DATA))
         $display("SUBU Test OK");
      else
         $display("SUBU Test fail\n    expected:  %b\n    out:%b",(RS_DATA-RT_DATA),o_alu_out);



      #10
      i_function = FUNC_AND;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RS_DATA&RT_DATA))
         $display("AND Test OK");
      else
         $display("AND Test fail\n    expected:  %b\n    out:%b",(RS_DATA&RT_DATA),o_alu_out);



      #10
      i_function = FUNC_OR ;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RS_DATA|RT_DATA))
         $display("OR Test OK");
      else
         $display("OR Test fail\n    expected:  %b\n    out:%b",RT_DATA<<SIGN_EXT,o_alu_out);



      #10
      i_function = FUNC_XOR;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == (RS_DATA^RT_DATA))
         $display("XOR Test OK");
      else
         $display("XOR Test fail\n    expected:  %b\n    out:%b",RS_DATA|RT_DATA,o_alu_out);



      #10
      i_function = FUNC_NOR;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B;
      #10
      if(o_alu_out == ~(RS_DATA|RT_DATA))
         $display("NOR Test OK");
      else
         $display("NOR Test fail\n    expected:  %b\n    out:%b",~(RS_DATA|RT_DATA),o_alu_out);



      #10
      i_function = FUNC_SLT;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B; 
      i_rs_reg   = 32'd256;
      i_rt_reg   = 32'd10029;
      #10
      if(o_alu_out == (1))
         $display("SLT true Test OK");
      else
         $display("SLT true Test fail\n    expected:  %b\n    out:%b",(1),o_alu_out);

      #10
      i_function = FUNC_SLT;
      i_mux_rs_ctl = RS_TO_A;
      i_mux_rt_ctl = RT_TO_B; 
      i_rs_reg   = 32'd256;
      i_rt_reg   = 32'd17;
      #10
      if(o_alu_out == (0))
         $display("SLT false Test OK");
      else
         $display("SLT false Test fail\n    expected:  %b\n    out:%b",(0),o_alu_out);

      #1   
      i_rt_reg   = RT_DATA;
      i_rs_reg   = RS_DATA;



      /*
      *     TEST DE OPERACIONES CON ARGUMENTO INMEDIATO
      * 
      * Las instrucciones utilizan un solo argumento de
      * los registros y el otro operando viene en la instruccion
      */

      $display("\n");
      $display("******************************************************************************");
      $display("***************  TESTS DE INSTRUCCIONES INMEDIATAS (I-type)  *****************");
      $display("******************************************************************************");

      /* parametros comunes a los inmediatos */
      i_mux_dest_ctl = DEST_FROM_RD;
      i_mux_rs_ctl   = RS_TO_A;
      i_mux_rt_ctl   = SEXT_TO_B;

      #10
      i_alu_op_ctl   = OP_ADD  ;//ADDI
      #10
      if(o_alu_out == ($signed(RS_DATA)+ $signed(SIGN_EXT)))
         $display("ADDI Test OK");
      else
         $display("ADDI Test fail\n    expected:  %b\n    out:%b",($signed(RS_DATA)+ $signed(SIGN_EXT)),o_alu_out);


       i_alu_op_ctl = OP_ANDI ;//
       #10
      if(o_alu_out == (RS_DATA&SIGN_EXT))
         $display("ANDI Test OK");
      else
         $display("ANDI Test fail\n    expected:  %b\n    out:%b",(RS_DATA&SIGN_EXT),o_alu_out);


       i_alu_op_ctl = OP_ORI  ;//
       #10
      if(o_alu_out == (RS_DATA|SIGN_EXT))
         $display("ORI Test OK");
      else
         $display("ORI Test fail\n    expected:  %b\n    out:%b",(RS_DATA|SIGN_EXT),o_alu_out);


       i_alu_op_ctl = OP_XORI ;//
       #10
      if(o_alu_out == (RS_DATA^SIGN_EXT))
         $display("XORI Test OK");
      else
         $display("XORI Test fail\n    expected:  %b\n    out:%b",(RS_DATA^SIGN_EXT),o_alu_out);


       i_alu_op_ctl = OP_LUI  ;//
       #10
      if(o_alu_out == (SIGN_EXT<<16))
         $display("LUI Test OK");
      else
         $display("LUI Test fail\n    expected:  %b\n    out:%b",(SIGN_EXT<<16),o_alu_out);


       i_alu_op_ctl = OP_NONE ;//
       #10
      if(o_alu_out == (0))
         $display("NONE Test OK");
      else
         $display("NONE Test fail\n    expected:  %b\n    out:%b",(0),o_alu_out);


      i_alu_op_ctl = OP_SLTI ;//
      i_sign_ext = 32'd455;
      i_rs_reg   = 32'd400;
       #10
      if(o_alu_out == (1))
         $display("SLTI true Test OK");
      else
         $display("SLTI true Test fail\n    expected:  %b\n    out:%b",(1),o_alu_out);

      i_alu_op_ctl = OP_SLTI ;//
      i_sign_ext = 32'd455;
      i_rs_reg   = 32'd500;
       #10
      if(o_alu_out == (0))
         $display("SLTI false Test OK");
      else
         $display("SLTI false Test fail\n    expected:  %b\n    out:%b",(0),o_alu_out);

      i_sign_ext = SIGN_EXT;
      i_rs_reg   = RS_DATA;




      i_alu_op_ctl = OP_JAL  ;//
      i_mux_rs_ctl= PC_TO_A;
      i_mux_dest_ctl = DEST_TO_RETURN;
      #10
      if(o_alu_out == (PC_4+4))
         $display("JAL Test OK");
      else
         $display("JAL Test fail\n    expected:  %b\n    out:%b",(PC_4+4),o_alu_out);

      /* la operacion op_sub no se prueva xq no tiene plicacion real
       *segun la arquitectura se utiliza un comparador en la etapa anterior
       para los beq/bne
       */


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
