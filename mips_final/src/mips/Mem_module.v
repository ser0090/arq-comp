`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar


module Mem_module #(
    parameter NB_BITS = 32,
    parameter NB_DEPTH =10
    )
    (
    output [NB_BITS-1:0]  o_mem_data,
    output [NB_BITS-1:0]  o_alu_data,
    output [`BYTE-1:0]      o_wb_ctl,
    output [4:0]            o_reg_dst,

    
    input  [NB_BITS-1:0]    i_addr,
    input  [NB_BITS-1-1:0]  i_data, 
    input  [1:0]            i_write_ctl,
    input  [1:0]            i_read_ctl,
    input  [4:0]            i_reg_dst,
    input  [7:0]            i_wb_ctl,
    input i_clk,
    input i_rst
    );

    localparam COL_WIDTH       = 8;
    localparam NB_COL         = 4;
    
    reg [80-1:0] latched_out;

    wire [NB_BITS-1:0] mem_out;


    assign o_wb_ctl   = latched_out[7:0]   ;
    assign o_mem_data = mem_out;//latched_out[39:8]  ;
    assign o_alu_data = latched_out[71:40] ;
    assign o_reg_dst  = latched_out[76:72] ;



    always @(posedge i_clk) begin
         if (i_rst) begin
             latched_out <= 80'd0;
         end
         else begin
            latched_out [7:0]   <= i_wb_ctl;
            latched_out [39:8]  <= mem_out;
            latched_out [71:40] <= i_addr; // normalmente ingresa una addr de la alu pero puede ser un dato
            latched_out [76:72] <= i_reg_dst;
            latched_out [79:77] <= 3'd0;
         end
     end 
/*

    Single_port_ram #(
            .RAM_WIDTH(NB_BITS),
            .NB_DEPTH(8)
        ) inst_Single_port_ram (
            .o_data   (mem_out),
            .i_addr   (i_addr[9:2]),
            .i_data   (i_data),
            .i_clk    (i_clk),
            .i_wea    (i_write_ctl[0] | i_write_ctl[1]),
            .i_ena    (i_write_ctl[0] | 
                       i_write_ctl[1] | 
                       i_read_ctl[0]  |
                       i_read_ctl[1]    ),
            .i_rst    (i_rst)
//            .i_regcea (i_regcea)
        );
*/
    Data_Memory #(
            .NB_DEPTH(NB_DEPTH),
            .NB_COL(NB_COL),
            .COL_WIDTH(COL_WIDTH)
        ) inst_Data_Memory (
            .o_data         (mem_out),
            .i_addr         (i_addr[9:2]),
            .i_data         (i_data),
            .i_write_enable (i_write_enable),
            .i_read_enable  (i_read_enable),
            .i_clk          (i_clk)
        );



/*
    Data_Memory #(
            .RAM_WIDTH(NB_BITS),
            .NB_DEPTH(NB_DEPTH)
        ) inst_Data_Memory (
            .o_data         (mem_out),
            .i_addr         (i_addr),
            .i_data         (i_data),
            .i_write_enable (i_write_ctl),
            .i_read_enable  (i_read_ctl),
            .i_clk          (i_clk)
        );
*/

endmodule