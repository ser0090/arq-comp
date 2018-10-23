`timescale 1ns / 1ps

`define NB_BITS 16
`define INS_MEM_DEPTH 2048
`define DTA_MEM_DEPTH 2048
`define NB_SIGX 11
`define PROGRAM_FILE "/home/sergio/Documentos/ADC/arq-comp/ADC-TP3_BIP/src/program_memory.txt"


module BIP #
  (
   parameter NB_BITS = `NB_BITS,
   parameter INS_MEM_DEPTH = `INS_MEM_DEPTH,
   parameter DTA_MEM_DEPTH = `DTA_MEM_DEPTH,
   parameter NB_SIGX = `NB_SIGX, //catidad de bits sin la extension
   parameter PROGRAM_FILE = `PROGRAM_FILE
   )
   (
    output [NB_BITS-1:0]                 o_acc,
    output [NB_BITS-1:0]                 o_prog_inst,
    output [clogb2(INS_MEM_DEPTH-1)-1:0] o_pc,
    input                                i_clk,
    input                                BTNC
    );

   wire [clogb2(INS_MEM_DEPTH-1)-1:0] addr_ins;
   wire [clogb2(DTA_MEM_DEPTH-1)-1:0] addr_data;
   wire [NB_BITS-1:0]                 data_cpu_to_memory;
   wire [NB_BITS-1:0]                 prog_to_cpu; // RAM output data
   wire [NB_BITS-1:0]                 data_memory_to_cpu;
   wire                               wr;
   wire                               rd;
   
   assign o_prog_inst = prog_to_cpu;
   assign o_pc = addr_ins;
   CPU #
     (
      .NB_BITS(NB_BITS),
      .INS_MEM_DEPTH(INS_MEM_DEPTH),
      .DTA_MEM_DEPTH(DTA_MEM_DEPTH)
      )
   inst_CPU 
     (
      .o_addr_ins    (addr_ins),
      .o_addr_data   (addr_data),
      .o_acc         (o_acc),
      .o_data        (data_cpu_to_memory),
      .o_wr          (wr),
      .o_rd          (rd),
      .i_instruction (prog_to_cpu),
      .i_data_mem    (data_memory_to_cpu),
      .i_clk         (i_clk),
      .i_rst         (BTNC)
      );
   
   
   Data_Memory #
     (
      .RAM_WIDTH(NB_BITS),
      .RAM_DEPTH(DTA_MEM_DEPTH)
      ) 
   inst_Data_Memory 
     (
      .o_data (data_memory_to_cpu),
      .i_addr (addr_data),
      .i_data (data_cpu_to_memory),
      .i_clk  (i_clk),
      .i_wr   (wr),
      .i_rd   (rd),
      .i_rst  (BTNC)
      );
   
   Program_Memory #
     (
      .RAM_WIDTH(NB_BITS),
      .RAM_DEPTH(INS_MEM_DEPTH),
      .INIT_FILE(PROGRAM_FILE)
      ) 
   inst_Program_Memory 
     (
      .o_data (prog_to_cpu),
      .i_addr (addr_ins),
      .i_clk  (i_clk),
      .i_enb  (1'b1),
      .i_rst  (BTNC)
      );
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2

endmodule // BIP
