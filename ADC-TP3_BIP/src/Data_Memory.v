`timescale 1ns / 1ps

module Data_Memory #
  (
   parameter RAM_WIDTH = 16,                       // Specify RAM data width
   parameter RAM_DEPTH = 1024,                     // Specify RAM depth (number of entries)
   parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
   )
   (
    output [RAM_WIDTH-1:0]          o_data, // RAM output dat
    input [clogb2(RAM_DEPTH-1)-1:0] i_addr, // Address bus, width determined from RAM_DEPTH
    input [RAM_WIDTH-1:0]           i_data, // RAM input data
    input                           i_clk, // Clock
    input                           i_wr,
    input                           i_rd, // Write/Read enable
//    input                           i_enb, // RAM Enable, for additional power savings, disable port when not in use
    input                           i_rst // Output reset (does not affect memory contents)
    //input                           regcea, // Output register enable
    );
   

   /*correccoines para ajusta al diagrama del paper*/
   wire i_w_r;
   wire i_enb;
   assign i_w_r = i_wr;
   assign i_enb = i_rd ^ i_wr;


   reg [RAM_WIDTH-1:0]              BRAM [RAM_DEPTH-1:0];
   reg [RAM_WIDTH-1:0]              ram_data = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
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
  end // always @ (posedge i_clk)
   
  //  The following function calculates the address width based on specified RAM depth
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2

endmodule // Data_Memory


// The following is an instantiation template for xilinx_single_port_ram_no_change
/*
  //  Xilinx Single Port No Change RAM
  xilinx_single_port_ram_no_change #(
    .RAM_WIDTH(18),                       // Specify RAM data width
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .addra(addra),    // Address bus, width determined from RAM_DEPTH
    .dina(dina),      // RAM input data, width determined from RAM_WIDTH
    .clka(clka),      // Clock
    .wea(wea),        // Write enable
    .ena(ena),        // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),      // Output reset (does not affect memory contents)
    .regcea(regcea),  // Output register enable
    .douta(douta)     // RAM output data, width determined from RAM_WIDTH
  );

*/

