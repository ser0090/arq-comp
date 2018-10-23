`timescale 1ns / 1ps

module Program_Memory #
  (
   parameter RAM_WIDTH = 16,                  // Specify RAM data width
   parameter RAM_DEPTH = 2048,                // Specify RAM depth (number of entries)
   parameter INIT_FILE = ""                   // Specify name/location of RAM initialization file if using one (leave blank if not)
   )
   (
    output [RAM_WIDTH-1:0]          o_data,   // RAM output data
    input [clogb2(RAM_DEPTH-1)-1:0] i_addr,   // Read address bus, width determined from RAM_DEPTH
    input                           i_clk,    // Clock
    input                           i_enb,    // Read Enable, for additional power savings, disable when not in use
    input                           i_rst     // Output reset (does not affect memory contents)
    );
   
   reg [RAM_WIDTH-1:0]              BRAM [RAM_DEPTH-1:0];
   reg [RAM_WIDTH-1:0]              ram_data;
   integer                          ram_idx;
   
   generate
      if (INIT_FILE != "") begin: use_init_file
         initial begin
            $readmemh(INIT_FILE, BRAM, 0, 19); // RAM_DEPTH-1);
            for (ram_idx = 20; ram_idx < RAM_DEPTH; ram_idx = ram_idx + 1)
              BRAM[ram_idx] = {RAM_WIDTH{1'b0}};
         end
      end 
      else begin: init_bram_to_zero
         initial begin
         /*BRAM[0] = 16'h1810;
           BRAM[1] = 16'h0801;
           BRAM[2] = 16'h1808;
           BRAM[3] = 16'h0802;
           BRAM[4] = 16'h1801;
           BRAM[5] = 16'h0803;
           BRAM[6] = 16'h1001;
           BRAM[7] = 16'h2801;
           BRAM[8] = 16'h0804;
           BRAM[9] = 16'h2002;
           BRAM[10] = 16'h3003;
           BRAM[11] = 16'h3810;
           BRAM[12] = 16'h0805;*/
           for (ram_idx = 0; ram_idx < RAM_DEPTH; ram_idx = ram_idx + 1)
             BRAM[ram_idx] = {RAM_WIDTH{1'b0}};
         end
      end
   endgenerate
   
   assign o_data = ram_data;
   
   always @(posedge i_clk) begin
      if(i_rst) begin
         ram_data <= {RAM_WIDTH{1'b0}};
      end
      else if (i_enb) begin
         ram_data <= BRAM[i_addr];
      end
      else begin
         ram_data <= ram_data;
      end
   end // always @ (posedge i_clk)
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2
   
endmodule // Program_Memory

