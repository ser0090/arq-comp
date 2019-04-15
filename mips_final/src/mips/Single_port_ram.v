`timescale 1ns / 1ps

//  Xilinx Single Port Write First RAM
//  This code implements a parameterizable single-port write-first memory where when data
//  is written to the memory, the output reflects the same data being written to the memory.
//  If the output data is not needed during writes or the last read value is desired to be
//  it is suggested to use a No Change as it is more power efficient.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.
//  Modify the parameters for the desired RAM characteristics.

module Single_port_ram #
  (
   parameter RAM_WIDTH       = 32,            // Specify RAM data width
   parameter NB_DEPTH        = 10,            // Specify RAM depth (number of entries)
   parameter RAM_PERFORMANCE = "LOW_LATENCY", // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
   parameter INIT_FILE       = "",            // Specify name/location of RAM initialization file if using one (leave blank if not)
   localparam RAM_DEPTH      = 2**NB_DEPTH
   )
   (
    output [RAM_WIDTH-1:0] o_data,  // RAM output data
    input [NB_DEPTH-1:0]   i_addr,  // Address bus, width determined from RAM_DEPTH
    input [RAM_WIDTH-1:0]  i_data,  // RAM input data
    input                  i_clk,   // Clock
    input                  i_wea,   // Write enable
    input                  i_ena,   // RAM Enable, for additional power savings, disable port when not in use
    input                  i_rst,   // Output reset (does not affect memory contents)
    input                  i_regcea // Output register enable
    );
   
   reg [RAM_WIDTH-1:0]     BRAM [RAM_DEPTH-1:0];
   reg [RAM_WIDTH-1:0]     ram_data = {RAM_WIDTH{1'b0}};
   
   // The following code either initializes the memory values to a specified file or to all zeros to match hardware
   generate
      if (INIT_FILE != "") begin: use_init_file
         initial
           $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
      end
      else begin: init_bram_to_zero
         integer ram_index;
         initial
           for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
             BRAM[ram_index] = ram_index; //{RAM_WIDTH{1'b0}};
      end
   endgenerate

   always @(posedge i_clk) begin
      if (i_ena) begin
         if (i_wea) begin
            BRAM[i_addr]  <= i_data;
            ram_data      <= i_data;
         end
         else
           ram_data <= BRAM[i_addr];
      end
   end
   //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
   generate
      if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register
         // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
         assign o_data = ram_data;
      end
      else begin: output_register
         // The following is a 2 clock cycle read latency with improve clock-to-out timing
         reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
         always @(posedge i_clk)
           if (i_rst)
             douta_reg <= {RAM_WIDTH{1'b0}};
           else if (i_regcea)
             douta_reg <= ram_data;
           assign o_data = douta_reg;
        end
   endgenerate

   //  The following function calculates the address width based on specified RAM depth
   function integer clogb2;
      input integer          depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction
endmodule

// The following is an instantiation template for xilinx_single_port_ram_write_first
/*
  //  Xilinx Single Port Write First RAM
  xilinx_single_port_ram_write_first #(
    .RAM_WIDTH(18),                       // Specify RAM data width
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .addra(addra),     // Address bus, width determined from RAM_DEPTH
    .dina(dina),       // RAM input data, width determined from RAM_WIDTH
    .clka(clka),       // Clock
    .wea(wea),         // Write enable
    .ena(ena),         // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),       // Output reset (does not affect memory contents)
    .regcea(regcea),   // Output register enable
    .douta(douta)      // RAM output data, width determined from RAM_WIDTH
  );
*/
