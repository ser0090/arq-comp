`timescale 1ns / 1ps

module Program_Memory #
  (
   parameter RAM_WIDTH = 16,                       // Specify RAM data width
   parameter RAM_DEPTH = 2048,                     // Specify RAM depth (number of entries)
   parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
   )
   (
    output [RAM_WIDTH-1:0]          o_data, // RAM output data
    input [clogb2(RAM_DEPTH-1)-1:0] i_addr, // Read address bus, width determined from RAM_DEPTH
    input                           i_clk, // Clock
    input                           i_enb // Read Enable, for additional power savings, disable when not in use
    );
   
   reg [RAM_WIDTH-1:0]              BRAM [RAM_DEPTH-1:0];
   reg [RAM_WIDTH-1:0]              ram_data = {RAM_WIDTH{1'b0}};


   assign o_data = ram_data;
   integer ram_index;
   generate
      if (INIT_FILE != "") begin: use_init_file
         initial begin
           $readmemh(INIT_FILE, BRAM, 0, 19);//RAM_DEPTH-1);
           for (ram_index = 20; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
             BRAM[ram_index] = {RAM_WIDTH{1'b0}};
            end
      end 
      else begin: init_bram_to_zero
         
         initial
           for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
             BRAM[ram_index] = {RAM_WIDTH{1'b0}};
      end
   endgenerate
   
   always @(posedge i_clk) begin
      if (i_enb)
        ram_data <= BRAM[i_addr];
      else
        ram_data <= ram_data;
   end
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2
   
endmodule // Program_Memory

