`timescale 1ns / 1ps

module Data_Memory #
  (
   parameter RAM_WIDTH = 16,      // Specify RAM data width
   parameter RAM_DEPTH = 1024,    // Specify RAM depth (number of entries)
   parameter INIT_FILE = ""       // Specify name/location of RAM initialization file if using one (leave blank if not)
   )
   (
    output [RAM_WIDTH-1:0]          o_data,   // RAM output dat
    input [clogb2(RAM_DEPTH-1)-1:0] i_addr,   // Address bus, width determined from RAM_DEPTH
    input [RAM_WIDTH-1:0]           i_data,   // RAM input data
    input                           i_clk,    // Clock
    //input                           i_wr,
    //input                           i_rd,   // Write/Read enable
    input                           i_w_r,    // 0 = Read , 1 = Write
    input                           i_enb,    // RAM Enable, for additional power savings, disable port when not in use
    input                           i_rst     // Output reset (does not affect memory contents)
    //input                           regcea, // Output register enable
    );
   
   reg [RAM_WIDTH-1:0]              BRAM [RAM_DEPTH-1:0];
   reg [RAM_WIDTH-1:0]              ram_data;
   /*correccoines para ajusta al diagrama del paper*/
   //wire                             i_w_r;
   //wire                             i_enb;
   
   assign o_data = ram_data;
   //assign i_w_r = i_wr;
   //assign i_enb = i_rd ^ i_wr;
   
   // The following code either initializes the memory values 
   // to a specified file or to all zeros to match hardware
   generate
      if (INIT_FILE != "") begin: use_init_file
         initial
           $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
      end else begin: init_bram_to_zero
         integer ram_index;
         initial
           for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
             BRAM[ram_index] = {RAM_WIDTH{1'b0}};
      end
   endgenerate
   
   always @(negedge i_clk) begin
      if(i_rst) begin
         ram_data <= {RAM_WIDTH{1'b0}};
      end
      else begin
         if (i_enb) begin
            if (i_w_r) begin /* write */
               BRAM[i_addr] <= i_data;
            end
            else begin /* read */
               ram_data <= BRAM[i_addr];
            end
         end
         else begin
            ram_data <= ram_data;
         end // else: !if(i_enb)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2

endmodule // Data_Memory

