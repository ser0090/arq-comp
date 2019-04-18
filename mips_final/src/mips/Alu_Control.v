`timescale 1ns / 1ps

module Alu_Control #
  (
   parameter NB_OPE = 5,
   parameter NB_ALU_OP_CTL = 4,
   parameter NB_FUNCTION =8
   )
   (
    output [NB_OPE-1:0] o_alu, /* N bits more carry */

    input [NB_ALU_OP_CTL-1:0]  i_alu_op_ctl,
    input [NB_FUNCTION-1:0]  i_function
    );
   
   localparam ALU_SLL = 5'b01000; // 8 shift lefth logical
   localparam ALU_SRL = 5'b01001; // 9 shift rigth logical
   localparam ALU_SRA = 5'b01010; // 10 shift right arithmetic
   localparam ALU_ADD = 5'b00010; // 2 add unsigned word
   localparam ALU_SUB = 5'b00110; // 6 subtract unsigned word
   localparam ALU_AND = 5'b00000; // 0
   localparam ALU_OR  = 5'b00001; // 1
   localparam ALU_XOR = 5'b00011; // 3
   localparam ALU_NOR = 5'b01100; // 12
   localparam ALU_SLT = 5'b00111; // 7 set on less than
   localparam ALU_JAL = 5'b01101; // 13 jump and link
   localparam ALU_LUI = 5'b01110; // 14 
   localparam ALU_NONE = 5'b01110; // 15 
   //localparam ALU_ADDU = 5'b10000; // 16 
   //localparam ALU_SUBU = 5'b10001; // 17 

   localparam FUNC_SLL = 6'b000000; // 
   localparam FUNC_SRL = 6'b000010; //  
   localparam FUNC_SRA = 6'b000011; //  
   localparam FUNC_SLLV = 6'b000100; //  
   localparam FUNC_SRLV = 6'b000110; //  
   localparam FUNC_SRAV = 6'b000111; //  
   localparam FUNC_JR = 6'b001000; //  
   localparam FUNC_JALR = 6'b001001; //  
   localparam FUNC_ADDU = 6'b100001; //  
   localparam FUNC_SUBU = 6'b100011; //  
   localparam FUNC_AND = 6'b100100; //  
   localparam FUNC_OR = 6'b100101; //  
   localparam FUNC_XOR = 6'b100110; //  
   localparam FUNC_NOR = 6'b100111; //  
   localparam FUNC_SLT = 6'b101010; //   

   localparam OP_ADD =  4'b0000;//
   localparam OP_FUNC = 4'b0010;//   
   localparam OP_SUB =  4'b0001;//
   localparam OP_ANDI = 4'b0100;//
   localparam OP_ORI =  4'b0101;//
   localparam OP_XORI = 4'b0110;//
   localparam OP_LUI =  4'b0111;//
   localparam OP_NONE = 4'b1000;//
   localparam OP_SLTI = 4'b1000;//
   localparam OP_JAL =  4'b1001;//

   //localparam JALR = 4'b1110; // jump and link register
   
   reg [NB_OPE-1:0] alu;
   reg [NB_OPE-1:0] func;
   assign o_alu = alu;
   
   /* always (*) se interpreta como combinacional
    * asignacion de la salida sintax switch case = MUX */
    always @(*) begin
       case (i_alu_op_ctl)
          OP_ADD : alu = ALU_ADD ;
          OP_SUB : alu = ALU_SUB ;
          OP_ANDI: alu = ALU_AND ;
          OP_ORI : alu = ALU_OR ;
          OP_XORI: alu = ALU_XOR ;
          OP_LUI : alu = ALU_LUI ;
          OP_NONE: alu = ALU_NONE ;
          OP_SLTI: alu = ALU_SLT ;
          OP_JAL : alu = ALU_JAL ;
          OP_FUNC: alu = func;
         default : alu = ALU_NONE; /* default */
       endcase // case (i_ope_sel)

       case(i_function)
        FUNC_SLL : func = ALU_SLL;
        FUNC_SRL : func = ALU_SRL;
        FUNC_SRA : func = ALU_SRA;
        FUNC_SLLV: func = ALU_SLL;
        FUNC_SRLV: func = ALU_SRL;
        FUNC_SRAV: func = ALU_SRA;
        FUNC_JR  : func = ALU_NONE;
        FUNC_JALR: func = ALU_JAL;
        FUNC_ADDU: func = ALU_ADD;
        FUNC_SUBU: func = ALU_SUB;
        FUNC_AND : func = ALU_AND;
        FUNC_OR  : func = ALU_OR;
        FUNC_XOR : func = ALU_XOR;
        FUNC_NOR : func = ALU_NOR;
        FUNC_SLT : func = ALU_SLT;
        default  : func = ALU_NONE;
       endcase
    end // always @ (*)
endmodule // Alu

