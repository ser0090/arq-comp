module TOP #
  (
   parameter DATA_WIDTH = 16,
   parameter UART_DATA_SIZE = 8,
   parameter INS_MEM_DEPTH = 2048,
   parameter DATA_MEM_DEPTH = 2048,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   parameter PROGRAM_FILE = "",
   localparam NB_SELA = 2
   )
   (
    output   UART_RXD_OUT,//o_tx,
    input    UART_TXD_IN,//i_rx,
    input    i_clk,
    input    BTNC//i_rst
    );

   wire i_rst;
   assign i_rst = BTNC;
   wire tx;
   assign UART_RXD_OUT = tx;
   wire i_rx;
   assign  i_rx = UART_TXD_IN ;

   wire  [clogb2(INS_MEM_DEPTH-1)-2:0]  addr_bus_per;
   wire                                 cs_perif;
   wire                                 w_r_per;
   wire [DATA_WIDTH-1:0]                per_data_bus;
   wire acc;

   wire cpu_enable;

  BIP #(
      .DATA_WIDTH(DATA_WIDTH),
      .INS_MEM_DEPTH(INS_MEM_DEPTH),
      .DATA_MEM_DEPTH(DATA_MEM_DEPTH),
      .NB_SIGX(NB_SIGX),
      .PROGRAM_FILE(PROGRAM_FILE)
    ) inst_BIP (
      .o_acc           (acc),
      .o_addr_bus_per  (addr_bus_per),
      .o_cs_perif      (cs_perif),
      .o_w_r_per       (w_r_per),
      .i_clk           (i_clk),
      .i_rst           (i_rst),//(i_rst | cpu_enable), // esto es para que arranque cuando llega algo a la uart
      .io_per_data_bus (per_data_bus)
    );


      

      UART #(
      .NB_BITS(UART_DATA_SIZE),
      .DATA_BUS_WIDTH(DATA_WIDTH),
      .ADDR_BUS_WIDTH(10)
    ) inst_UART (
      .o_tx        (tx),
      .o_cpu_enable(cpu_enable),
      .i_rx        (i_rx),
      .i_clk       (i_clk),
      .i_rst       (i_rst),
      .i_cs        (cs_perif),
      .i_w_r       (w_r_per),
      .i_addr_bus  (addr_bus_per),
      .io_data_bus (per_data_bus)
    );



  function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction // clogb2


endmodule