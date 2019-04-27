
`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar


module Data_Memory #(
    parameter RAM_WIDTH       = 32,            // Specify RAM data width
    parameter NB_DEPTH        = 10,            // Specify RAM depth (number of entries)
    parameter FILE_DEPTH      = 31,            // Specify RAM data width
    localparam RAM_DEPTH      = 2**NB_DEPTH,

    localparam READ_DISABLE   = `READ_DISABLE , 
    localparam READ_BYTE      = `READ_BYTE    , 
    localparam READ_HALFWORD  = `READ_HALFWORD, 
    localparam READ_WORD      = `READ_WORD    ,  

    localparam WRITE_DISABLE  = `WRITE_DISABLE ,
    localparam WRITE_BYTE     = `WRITE_BYTE    ,
    localparam WRITE_HALFWORD = `WRITE_HALFWORD,
    localparam WRITE_WORD     = `WRITE_WORD    
    )
    (
    output [RAM_WIDTH-1:0] o_data,
    
    input  [NB_DEPTH-1:0]  i_addr,
    input  [RAM_WIDTH-1:0] i_data, 
    input  [1:0]           i_write_enable,
    input  [1:0]           i_read_enable,
    input i_clk
);
localparam HALFWORD = 16;
localparam BYTE     = 8;
localparam WORD     = 32;

reg [BYTE-1:0]   BRAM [RAM_DEPTH-1:0]; // memoria indexada de a bytes
reg [RAM_WIDTH-1:0]   data_out ;
reg [RAM_WIDTH-1:0]   data_in  ;

assign o_data = data_out;

integer ram_index; 

 initial begin
    for (ram_index = RAM_DEPTH; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
      BRAM[ram_index] = {BYTE{1'b0}};
 end

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