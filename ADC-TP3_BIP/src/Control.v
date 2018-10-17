`timescale 1ns / 1ps

module Control #
  (
   parameter NB_BITS = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   localparam NB_SELA = 2
   )
   (
    output [NB_SIGX-1:0]  o_data_ins,
    output [NB_SELA-1:0]  o_sel_a,
    output                o_sel_b,
    output                o_wr_acc,
    output                o_op_code,
    output                o_wr,
    output                o_rd,
    input [NB_BITS-1:0]   i_instruction,
    input                 i_clk,
    input                 i_rst
    );

    reg  [clogb2(INS_MEM_DEPTH-1)-1:0] PC;
    reg  WrPC;
    reg [NB_SELA-1:0]  sel_a;
    reg                sel_b;
    reg                wr_acc;
    reg                op_code;
    reg                wr;
    reg                rd;
    assign o_sel_a = sel_a;
    assign o_sel_b = sel_b;
    assign o_wr_acc = wr_acc;
    assign o_op_code = op_code;
    assign o_wr = wr;
    assign o_rd = rd;


   /* ACTUALIZACION DEL PC */
   always @(posedge i_clk) begin
     if (i_rst) begin
       PC <= {clogb2(INS_MEM_DEPTH-1){1'b0}}; 
     end
     else if (WrPC) begin
        PC <= PC+1;
     end
     else begin
       PC <= PC;
     end
   end

   /* OPERANDO */
   assign o_data_ins = i_instruction[NB_SIGX-1:0];

   always @(*) begin
    
    case(i_instruction[NB_BITS-1:NB_SIGX])
      5'b00000:begin //halt
                WrPC = 1'b0;
                sel_a = 2'b00;
                sel_b = 1'b0;
                wr_acc = 1'b0;
                op_code = 1'b0;
                wr = 1'b0;
                rd = 1'b0;
              end    
      5'b00001:begin //Store Variable
                WrPC = 1'b1;
                sel_a = 2'b11;
                sel_b = 1'b0;
                wr_acc = 1'b0;
                op_code = 1'b0;
                wr = 1'b1;
                rd = 1'b0;
              end
      5'b00010:begin //Load Variable
                WrPC = 1'b1;
                sel_a = 2'b00;
                sel_b = 1'b0;
                wr_acc = 1'b1;
                op_code = 1'b0;
                wr = 1'b0;
                rd = 1'b1;
              end
      5'b00011:begin //Load inmediate
                WrPC = 1'b1;
                sel_a = 2'b01;
                sel_b = 1'b0;
                wr_acc = 1'b1;
                op_code = 1'b0;
                wr = 1'b0;
                rd = 1'b0;
              end
      5'b00100:begin //Add Variable
                WrPC = 1'b1;
                sel_a = 2'b10;
                sel_b = 1'b0;
                wr_acc = 1'b1;
                op_code = 1'b1;
                wr = 1'b0;
                rd = 1'b1;
              end
      5'b00101:begin //Add Inmediate
                WrPC = 1'b1;
                sel_a = 2'b10;
                sel_b = 1'b1;
                wr_acc = 1'b1;
                op_code = 1'b1;
                wr = 1'b0;
                rd = 1'b0;
              end
      5'b00110:begin //Substract Variable
                WrPC = 1'b1;
                sel_a = 2'b10;
                sel_b = 1'b0;
                wr_acc = 1'b1;
                op_code = 1'b0;
                wr = 1'b0;
                rd = 1'b1;
              end
      5'b00111:begin //Substract Inmediate
                WrPC = 1'b1;
                sel_a = 2'b10;
                sel_b = 1'b1;
                wr_acc = 1'b1;
                op_code = 1'b0;
                wr = 1'b0;
                rd = 1'b0;
              end
    endcase
   end



    function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    endfunction // clogb2

   endmodule