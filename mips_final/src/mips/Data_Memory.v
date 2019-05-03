
`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Data_Memory #
  (
   parameter NB_DEPTH        = 10, // Specify RAM depth (number of entries)
   parameter NB_COL          = 4,  // Specify number of columns (number of bytes)
   parameter COL_WIDTH       = 8,  // Specify column width (byte width, typically 8 or 9)
   parameter INIT_FILE       = "", // Specify name/location
   localparam RAM_DEPTH      = 2**NB_DEPTH, // Specify RAM depth (number of entries)
   localparam RAM_WIDTH      = NB_COL*COL_WIDTH,
   localparam READ_DISABLE   = `READ_DISABLE,
   localparam READ_BYTE      = `READ_BYTE,
   localparam READ_HALFWORD  = `READ_HALFWORD,
   localparam READ_WORD      = `READ_WORD,
   localparam WRITE_DISABLE  = `WRITE_DISABLE,
   localparam WRITE_BYTE     = `WRITE_BYTE,
   localparam WRITE_HALFWORD = `WRITE_HALFWORD,
   localparam WRITE_WORD     = `WRITE_WORD
   )
   (
    output [(NB_COL*COL_WIDTH)-1:0] o_data, // RAM output data

    input [NB_DEPTH-1:0]            i_addr, // address bus, width determined from RAM_DEPTH
    input [(NB_COL*COL_WIDTH)-1:0]  i_data, // RAM input data
    input [1:0]                     i_write_enable,
    input [1:0]                     i_read_enable,
    input                           i_clk   // Clock
    //input [NB_COL-1:0]              wea,    // Byte-write enable
    //input                            enb    //chip select
    );

   /** CODIGO  PROPIO **/
   localparam HALFWORD = 16;
   localparam BYTE     = 8;
   localparam WORD     = 32;

   reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
   reg [(NB_COL*COL_WIDTH)-1:0] ram_data = {(NB_COL*COL_WIDTH){1'b0}};
   reg [NB_COL-1:0]             wea;
   //reg [(NB_COL*COL_WIDTH)-1:0] data_out;

   //assign enb = i_write_enable[0] | i_write_enable[1] | i_read_enable[0] | i_read_enable[1];
   assign o_data = ram_data;

   always @(*) begin
      case(i_write_enable)
        WRITE_DISABLE : wea = 4'b0000;
        WRITE_BYTE    : wea = 4'b0001;
        WRITE_HALFWORD: wea = 4'b0011;
        WRITE_WORD    : wea = 4'b1111;
      endcase // case (i_write_enable)
   end

   /*always @(*) begin
      case(i_read_enable)
        READ_DISABLE : data_out = {WORD{1'b0}};
        READ_BYTE    : data_out = {{(HALFWORD+BYTE){1'b0}},ram_data[BYTE-1:0]};
        READ_HALFWORD: data_out = {{HALFWORD{1'b0}},ram_data[HALFWORD-1:0]};
        READ_WORD    : data_out = ram_data;
      endcase
   end
   assign o_data = data_out;*/

   /*
    * CODIDO DE TEMPLATE
    */
   generate
      integer ram_index;
      initial begin
         for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
           BRAM[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
      end
   endgenerate

   generate
      genvar i;
      for (i = 0; i < NB_COL; i = i+1) begin: byte_write
         always @(posedge i_clk)
           if (wea[i])
             BRAM[i_addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= i_data[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end // end byte_write
   endgenerate

   always @(posedge i_clk) begin
      //if (enb) begin
      case(i_read_enable)
        READ_DISABLE : ram_data <= {WORD{1'b0}};
        READ_BYTE    : ram_data <= {{(HALFWORD+BYTE){1'b0}}, BRAM[i_addr][BYTE-1:0]};
        READ_HALFWORD: ram_data <= {{HALFWORD{1'b0}}, BRAM[i_addr][HALFWORD-1:0]};
        READ_WORD    : ram_data <= BRAM[i_addr];
      endcase // case (i_read_enable)
      //ram_data <= BRAM[i_addr];
      //end
   end // always @ (posedge i_clk)

   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2
endmodule // Data_Memory

// The following is an instantiation template for xilinx_simple_dual_port_byte_write_1_clock_ram
/*
//  Xilinx Simple Dual Port Single Clock RAM with Byte-write
  xilinx_simple_dual_port_byte_write_1_clock_ram #(
    .NB_COL(4),                           // Specify number of columns (number of bytes)
    .COL_WIDTH(9),                        // Specify column width (byte width, typically 8 or 9)
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .i_addr(i_addr),   // Write address bus, width determined from RAM_DEPTH
    .i_addr(i_addr),   // Read address bus, width determined from RAM_DEPTH
    .i_data(i_data),     // RAM input data, width determined from NB_COL*COL_WIDTH
    .i_clk(i_clk),     // Clock
    .wea(wea),       // Byte-write enable, width determined from NB_COL
    .enb(enb),       // Read Enable, for additional power savings, disable when not in use
    .rstb(rstb),     // Output reset (does not affect memory contents)
    .regceb(regceb), // Output register enable
    .o_data(o_data)    // RAM output data, width determined from NB_COL*COL_WIDTH
  );
*/
                        
                        








/*    
localparam HALFWORD = 16;
localparam BYTE     = 8;
localparam WORD     = 32;

reg [BYTE-1:0]   BRAM0 [RAM_DEPTH-1:0]; // memoria indexada de a bytes
reg [BYTE-1:0]   BRAM1 [RAM_DEPTH-1:0]; // memoria indexada de a bytes
reg [BYTE-1:0]   BRAM2 [RAM_DEPTH-1:0]; // memoria indexada de a bytes
reg [BYTE-1:0]   BRAM3 [RAM_DEPTH-1:0]; // memoria indexada de a bytes

reg [RAM_WIDTH-1:0]   data_out ;
reg [RAM_WIDTH-1:0]   data_in  ;

reg [RAM_WIDTH-1:0]     ram_data = {RAM_WIDTH{1'b0}};

assign o_data = data_out;

integer ram_index; 
generate
    initial begin
        for (ram_index = RAM_DEPTH; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
            BRAM[ram_index] = {BYTE{1'b0}};
    end
endgenerate

always @* begin
     case(i_write_enable)
        WRITE_DISABLE : data_in = {BRAM[i_addr+3],BRAM[i_addr+2],BRAM[i_addr+1],BRAM[i_addr]};
        WRITE_BYTE    : data_in = {BRAM[i_addr+3],BRAM[i_addr+2],BRAM[i_addr+1],i_data[BYTE-1:0]};
        WRITE_HALFWORD: data_in = {BRAM[i_addr+3],BRAM[i_addr+2],i_data[HALFWORD-1:0]};
        WRITE_WORD    : data_in = i_data;
     endcase
end

always @(*) begin
     case(i_read_enable)
        READ_DISABLE : data_out = {RAM_WIDTH{1'b0}};
        READ_BYTE    : data_out = {{HALFWORD{1'b0}},{BYTE{1'b0}},BRAM[i_addr]};
        READ_HALFWORD: data_out = {{HALFWORD{1'b0}},BRAM[i_addr+1],BRAM[i_addr]};
        READ_WORD    : data_out = {BRAM[i_addr+3],BRAM[i_addr+2],BRAM[i_addr+1],BRAM[i_addr]};
     endcase

end


always @(posedge i_clk) begin 

    

     BRAM[i_addr]   <= data_in[BYTE-1:0];
     BRAM[i_addr+1] <= data_in[HALFWORD-1:BYTE];
     BRAM[i_addr+2] <= data_in[BYTE+HALFWORD-1:HALFWORD];
     BRAM[i_addr+3] <= data_in[WORD-1:HALFWORD+BYTE];


end

endmodule
*/
