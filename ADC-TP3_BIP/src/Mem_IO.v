
// Es un wraper de la memoria que adapta las señales a la memoria y deja abierto el bus para conectar otros perifericos.

module Mem_IO #
  (
   parameter RAM_WIDTH = 16,                       // Specify RAM data width
   parameter RAM_DEPTH = 1024,                    // Specify RAM depth (number of entries)
   parameter PERIPHERALS_SPACE = 1024,             //Specify memory space to access peripherals        
   parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
   )
   (
    output [RAM_WIDTH-1:0]                            o_data, // RAM output data to CPU.
    output                                            o_r_w,   // select w/r operation.
    output                                            o_cs_perif,
    output[clogb2(RAM_DEPTH+PERIPHERALS_SPACE-1)-2:0] o_addr_bus,
    input [clogb2(RAM_DEPTH+PERIPHERALS_SPACE-1)-1:0] i_addr, // Address bus, width determined from RAM_DEPTH
    input [RAM_WIDTH-1:0]                             i_data, // RAM input data
    input                                             i_clk, // Clock
    input                                             i_wr,
    input                                             i_rd, // Write/Read enable
    input                                             i_rst, // Output reset (does not affect memory contents)

    inout  [RAM_WIDTH-1:0]                            io_data_bus // data bus to connect pheripherals
    );


   wire en_mem;
   assign en_mem = ~i_addr[clogb2(RAM_DEPTH+PERIPHERALS_SPACE-1)-1]; // el ultimo bit de la direccion sirve como chip enable para diferenciar si va en la memoria o a un periferico
   assign o_cs_perif = ~en_mem; // saca un cs para decir a los periferico que es para ellos.

   wire [RAM_WIDTH-1:0] data_bus;
   assign io_data_bus = ((i_rd ^ i_wr))? i_data : 'bz;;

   wire [RAM_WIDTH-1:0] mem_out; // bus de datos de la memoria, salida
   assign o_data = (en_mem)? mem_out : io_data_bus;
 
   
   wire [clogb2(RAM_DEPTH+PERIPHERALS_SPACE-1)-2:0] addr;
   assign addr = i_addr[clogb2(RAM_DEPTH+PERIPHERALS_SPACE-1)-2:0];
   assign o_addr_bus = addr;


  Data_Memory #(
      .RAM_WIDTH(RAM_WIDTH),
      .RAM_DEPTH(RAM_DEPTH),
      .INIT_FILE(INIT_FILE)
    ) inst_Data_Memory (
      .o_data (mem_out),
      .i_addr (addr),
      .i_data (i_data),
      .i_clk  (i_clk),
      .i_w_r  (i_wr),
      .i_enb  ((i_rd ^ i_wr) & en_mem ),
      .i_rst  (i_rst)
    );


  function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2

endmodule