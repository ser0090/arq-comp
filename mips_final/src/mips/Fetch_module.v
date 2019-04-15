`timescale 1ns / 1ps

module Fetch_module #
  (
   parameter NB_BITS = 32,
   parameter RAM_DEPTH = 10
   )
   (
    output [NB_BITS-1:0] o_if_id_pc,
    output [NB_BITS-1:0] o_if_id_instr,
    input [NB_BITS-1:0]  i_brq_addr,
    input [NB_BITS-1:0]  i_jmp_addr,
    input                i_ctr_beq,
    input                i_ctr_jmp,
    input                i_ctr_flush,
    input                i_pc_we,
    input                i_if_id_we,
    input                i_clk,
    input                i_rst
    );

   localparam SSL = 32'd0; // NOP operation sll $0 $0 0
   
   reg [NB_BITS-1:0]     if_id_pc;
   reg [NB_BITS-1:0]     if_id_instr;
   reg [NB_BITS-1:0]     pc;
   
   wire [NB_BITS-1:0]    data_mem;
   wire [NB_BITS-1:0]    mux_beq, mux_jmp;
   //wire                  wea, ena;
   initial
     pc =  {NB_BITS{1'b0}};
   //Muxes
   assign mux_beq = (i_ctr_beq)? i_brq_addr : pc + 4;
   assign mux_jmp = (i_ctr_jmp)? i_jmp_addr : mux_beq;

   //Outputs
   assign o_if_id_pc    = if_id_pc;
   assign o_if_id_instr = if_id_instr;
   
   always @(posedge i_clk) begin
      if(i_rst) begin
         pc       <= {NB_BITS{1'b0}};
         if_id_pc <= {NB_BITS{1'b0}};
      end
      else begin
         pc       <= (i_pc_we)? mux_jmp : pc;
         if_id_pc <= (i_if_id_we)? pc + 4: if_id_pc;
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)
   
   always @ (*) begin
      case({i_ctr_flush, i_if_id_we})
        2'b01:   if_id_instr = data_mem;
        2'b10:   if_id_instr = SSL;
        2'b11:   if_id_instr = SSL;
        default: if_id_instr = data_mem;
      endcase // case ({i_ctr_flush, i_if_id_we}
   end
   
   Single_port_ram #
     (
      .RAM_WIDTH       (NB_BITS),  // Specify RAM data width
      .NB_DEPTH        (RAM_DEPTH),
      .INIT_FILE       ("")        // Specify name/location of RAM initialization file if using one (leave blank if not)
      )
   inst_ram_instruction
        (
         .o_data (data_mem),             // RAM output data, width determined from RAM_WIDTH
         .i_addr (pc[RAM_DEPTH-1:0]>>2), // Address bus, width determined from RAM_DEPTH
         //.i_data (i_du_data),            // RAM input data, width determined from RAM_WIDTH
         .i_clk  (i_clk),                // Clock
         .i_wea  (1'b0),                 // Write enable
         .i_ena  (i_if_id_we)            // RAM Enable, for additional power savings, disable port when not in use
         );
endmodule // Fetch_module

