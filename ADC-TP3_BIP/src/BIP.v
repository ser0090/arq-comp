module BIP #
  (
   parameter NB_BITS = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter DATA_MEM_DEPTH = 1024,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   parameter PROGRAM_FILE = "",
   localparam NB_SELA = 2
   )
   (
    input                 i_clk,
    input                 i_rst
    );


    wire wr;
    wire rd;
    wire [clogb2(INS_MEM_DEPTH-1)-1:0]  addr_ins;
    wire [clogb2(INS_MEM_DEPTH-1)-1:0]  addr_data;
    wire [NB_BITS-1:0]                  data_cpu_to_memory;
    wire [NB_BITS-1:0]                  instruction; // RAM output data
    wire [NB_BITS-1:0]                  data_memory_to_cpu;
   

    CPU #(
      .NB_BITS(NB_BITS),
      .INS_MEM_DEPTH(INS_MEM_DEPTH),
      .NB_SIGX(NB_SIGX),
      .NB_SELA(NB_SELA)
    ) inst_CPU (
      .o_addr_ins    (addr_ins),
      .o_addr_data   (addr_data),
      .o_data        (data_cpu_to_memory),
      .o_wr          (wr),
      .o_rd          (rd),
      .i_instruction (instruction),
      .i_data_mem    (data_memory_to_cpu),
      .i_clk         (i_clk),
      .i_rst         (i_rst)
    );


      Data_Memory #(
      .RAM_WIDTH(NB_BITS),
      .RAM_DEPTH(DATA_MEM_DEPTH)
     // .INIT_FILE(INIT_FILE)
    ) inst_Data_Memory (
      .o_data (data_memory_to_cpu),
      .i_addr (addr_data),
      .i_data (data_cpu_to_memory),
      .i_clk  (i_clk),
      .i_wr   (wr),
      .i_rd   (rd),
      .i_rst  (i_rst)
    );


      Program_Memory #(
      .RAM_WIDTH(NB_BITS),
      .RAM_DEPTH(INS_MEM_DEPTH),
      .INIT_FILE(PROGRAM_FILE)
    ) inst_Program_Memory (
      .o_data (instruction),
      .i_addr (addr_ins),
      .i_clk  (i_clk),
      .i_enb  (1'b1)
    );

function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2


endmodule