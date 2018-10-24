// This is a simple example.
// You can make a your own header file and set its path to settings.
// (Preferences > Package Settings > Verilog Gadget > Settings - User)
//
//    "header": "Packages/Verilog Gadget/template/verilog_header.v"
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2018 All rights reserved
// -----------------------------------------------------------------------------
// Author : yongchan jeon (Kris) poucotm@gmail.com
// File   : BIP.v
// Create : 2018-10-24 13:31:09
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
module BIP #
  (
   parameter DATA_WIDTH = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter DATA_MEM_DEPTH = 2048,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   parameter PROGRAM_FILE = "",
   localparam NB_SELA = 2
   )
   (
    output [DATA_WIDTH-1:0]               o_acc,
    output [clogb2(INS_MEM_DEPTH-1)-2:0]  o_addr_bus_per,
    output                                o_cs_perif,
    output                                o_w_r_per,
    input                                 i_clk,
    input                                 i_rst,
    inout [DATA_WIDTH-1:0]                   io_per_data_bus // data bus to peripherals
    );

   wire [clogb2(INS_MEM_DEPTH-1)-1:0] addr_ins;
   wire [clogb2(INS_MEM_DEPTH-1)-1:0] addr_data;
   wire [DATA_WIDTH-1:0]                 data_cpu_to_memory;
   wire [DATA_WIDTH-1:0]                 instruction; // RAM output data
   wire [DATA_WIDTH-1:0]                 data_memory_to_cpu;
   wire                               wr;
   wire                               rd;
   
   CPU #
     (
      .NB_BITS(DATA_WIDTH),
      .INS_MEM_DEPTH(INS_MEM_DEPTH),
      .NB_SIGX(NB_SIGX)
      )
   inst_CPU 
     (
      .o_addr_ins    (addr_ins),
      .o_addr_data   (addr_data),
      .o_acc         (o_acc),
      .o_data        (data_cpu_to_memory),
      .o_wr          (wr),
      .o_rd          (rd),
      .i_instruction (instruction),
      .i_data_mem    (data_memory_to_cpu),
      .i_clk         (i_clk),
      .i_rst         (i_rst)
      );
   

     wire [clogb2(INS_MEM_DEPTH-1)-2:0] addr_bus_per;
     //wire [DATA_WIDTH-1:0]              data_bus_per;
     wire                               r_w;
     wire                               cs_perif;
     assign o_cs_perif = cs_perif;
     assign o_addr_bus_per = addr_bus_per;
     //assign io_per_data_bus = data_bus_per;
     assign o_cs_perif = cs_perif;
     assign o_w_r_per = r_w;

    Mem_IO #(
      .RAM_WIDTH(DATA_WIDTH),
      .RAM_DEPTH(DATA_MEM_DEPTH/2),
      .PERIPHERALS_SPACE(1024),
      .INIT_FILE("")
    ) inst_Mem_IO (
      .o_data      (data_memory_to_cpu),
      .o_addr_bus  (addr_bus_per),
      .o_r_w       (r_w),
      .o_cs_perif  (cs_perif),
      .i_addr      (addr_data),
      .i_data      (data_cpu_to_memory),
      .i_clk       (i_clk),
      .i_wr        (wr),
      .i_rd        (rd),
      .i_rst       (i_rst),
      .io_data_bus (io_per_data_bus)
    );

   Program_Memory #
     (
      .RAM_WIDTH(DATA_WIDTH),
      .RAM_DEPTH(INS_MEM_DEPTH),
      .INIT_FILE(PROGRAM_FILE)
      ) 
   inst_Program_Memory 
     (
      .o_data (instruction),
      .i_addr (addr_ins),
      .i_clk  (i_clk),
      .i_enb  (1'b1),
      .i_rst  (i_rst)
      );
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2

endmodule // BIP
