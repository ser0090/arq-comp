
`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Data_Memory_v2 #
  (
   parameter NB_DEPTH        = 8, // Specify RAM depth (number of entries)
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
    output [(NB_COL*COL_WIDTH)-1:0] o_data, // RAM oustput data
    // DEBUG singals
    output [(NB_COL*COL_WIDTH)-1:0] o_data_debug,

    input [NB_DEPTH-1:0]            i_addr, // address bus, width determined from RAM_DEPTH
    input [(NB_COL*COL_WIDTH)-1:0]  i_data, // RAM input data
    input [1:0]                     i_write_enable,
    input [1:0]                     i_read_enable,
    input                           i_clk, // Clock
    input                           i_rst, // Clock
    // DEBUG signals
    input [NB_DEPTH-3:0]            i_addr_debug,
    input                           i_debug_enb
    );

   /** CODIGO  PROPIO **/
   localparam HALFWORD = 16;
   localparam BYTE     = 8;
   localparam WORD     = 32;

   //reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
   reg [BYTE-1:0]  BRAM_0 [2**(NB_DEPTH-2)-1:0];
   reg [BYTE-1:0]  BRAM_1 [2**(NB_DEPTH-2)-1:0];
   reg [BYTE-1:0]  BRAM_2 [2**(NB_DEPTH-2)-1:0];
   reg [BYTE-1:0]  BRAM_3 [2**(NB_DEPTH-2)-1:0];

   reg [NB_DEPTH-1:0] b0_addr;
   reg [NB_DEPTH-1:0] b1_addr;
   reg [NB_DEPTH-1:0] b2_addr;
   reg [NB_DEPTH-1:0] b3_addr;

   reg [BYTE-1:0]    b0_data;
   reg [BYTE-1:0]    b1_data;
   reg [BYTE-1:0]    b2_data;
   reg [BYTE-1:0]    b3_data;

   reg [(NB_COL*COL_WIDTH)-1:0] ram_data = {(NB_COL*COL_WIDTH){1'b0}};
   reg [NB_COL-1:0]             wea;
   //DEBUG
   reg [(NB_COL*COL_WIDTH)-1:0] ram_debug = {(NB_COL*COL_WIDTH){1'b0}};

   assign o_data = ram_data;
   assign o_data_debug = ram_debug;

/* combinacional para write enables */
   always @(*) begin
      case(i_write_enable)
        WRITE_DISABLE : wea = 4'b0000;
        WRITE_BYTE    : begin
            case(i_addr[1:0])
              2'b00: wea = 4'b0001;
              2'b01: wea = 4'b0010;
              2'b10: wea = 4'b0100;
              2'b11: wea = 4'b1000;
            endcase
          end
        WRITE_HALFWORD: begin
            case(i_addr[1:0])
              2'b00: wea = 4'b0011;
              2'b01: wea = 4'b0110;
              2'b10: wea = 4'b1100;
              2'b11: wea = 4'b1001;
            endcase
          end
        WRITE_WORD    : wea = 4'b1111;
      endcase // case (i_write_enable)
   end


/* combinacional para adresses */

  always @(*) begin
    case(i_addr[1:0])
       2'b00: b0_addr = i_addr[NB_DEPTH-1:2];
       2'b01: b0_addr = i_addr[NB_DEPTH-1:2]+1;
       2'b10: b0_addr = i_addr[NB_DEPTH-1:2]+1;
       2'b11: b0_addr = i_addr[NB_DEPTH-1:2]+1;
    endcase
        case(i_addr[1:0])
       2'b00: b1_addr = i_addr[NB_DEPTH-1:2];
       2'b01: b1_addr = i_addr[NB_DEPTH-1:2];
       2'b10: b1_addr = i_addr[NB_DEPTH-1:2]+1;
       2'b11: b1_addr = i_addr[NB_DEPTH-1:2]+1;
    endcase
        case(i_addr[1:0])
       2'b00: b2_addr = i_addr[NB_DEPTH-1:2];
       2'b01: b2_addr = i_addr[NB_DEPTH-1:2];
       2'b10: b2_addr = i_addr[NB_DEPTH-1:2];
       2'b11: b2_addr = i_addr[NB_DEPTH-1:2]+1;
    endcase
    b3_addr = i_addr[NB_DEPTH-1:2];
  end

/* combinacional para datos de entrada */
  always @(*) begin
    case(i_addr[1:0])
       2'b00: b0_data = i_data[1*BYTE-1:BYTE*0];
       2'b01: b0_data = i_data[4*BYTE-1:BYTE*3];
       2'b10: b0_data = i_data[3*BYTE-1:BYTE*2];
       2'b11: b0_data = i_data[2*BYTE-1:BYTE*1];
    endcase
    case(i_addr[1:0])
       2'b00: b1_data = i_data[2*BYTE-1:BYTE*1];
       2'b01: b1_data = i_data[1*BYTE-1:BYTE*0];
       2'b10: b1_data = i_data[4*BYTE-1:BYTE*3];
       2'b11: b1_data = i_data[3*BYTE-1:BYTE*2];
    endcase
    case(i_addr[1:0])
       2'b00: b2_data = i_data[3*BYTE-1:BYTE*2];
       2'b01: b2_data = i_data[2*BYTE-1:BYTE*1];
       2'b10: b2_data = i_data[1*BYTE-1:BYTE*0];
       2'b11: b2_data = i_data[4*BYTE-1:BYTE*3];
    endcase
    case(i_addr[1:0])
       2'b00: b3_data = i_data[4*BYTE-1:BYTE*3];
       2'b01: b3_data = i_data[3*BYTE-1:BYTE*2];
       2'b10: b3_data = i_data[2*BYTE-1:BYTE*1];
       2'b11: b3_data = i_data[1*BYTE-1:BYTE*0];
    endcase
end

   generate
      integer ram_index;
      initial begin
         for (ram_index = 0; ram_index < 2**(NB_DEPTH-2); ram_index = ram_index + 1) begin
           BRAM_0[ram_index] = {8{1'b0}};
           BRAM_1[ram_index] = {8{1'b0}};
           BRAM_2[ram_index] = {8{1'b0}};
           BRAM_3[ram_index] = {8{1'b0}};
        end
      end
   endgenerate

   always @(posedge i_clk) begin
      if (wea[0])
        BRAM_0[b0_addr] <= b0_data;
      if (wea[1])
        BRAM_1[b1_addr] <= b1_data;
      if (wea[2])
        BRAM_2[b2_addr] <= b2_data;
      if (wea[3])
        BRAM_3[b3_addr] <= b3_data;
 end


   always @(posedge i_clk) begin
      if(i_rst) begin
        ram_data  <= {WORD{1'b0}};
      //  ram_debug <= {WORD{1'b0}};
      end
      else begin
         if(i_debug_enb) begin
            case(i_read_enable)
              READ_DISABLE : ram_data <= {WORD{1'b0}};
              READ_BYTE    : begin
                  case(i_addr[1:0])
                    2'b00: ram_data <= {{(HALFWORD+BYTE){1'b0}}, BRAM_0[b0_addr]};
                    2'b01: ram_data <= {{(HALFWORD+BYTE){1'b0}}, BRAM_1[b1_addr]};
                    2'b10: ram_data <= {{(HALFWORD+BYTE){1'b0}}, BRAM_2[b2_addr]};
                    2'b11: ram_data <= {{(HALFWORD+BYTE){1'b0}}, BRAM_3[b3_addr]};
                  endcase
                end
              READ_HALFWORD: begin
                  case(i_addr[1:0])
                    2'b00: ram_data <= {{HALFWORD{1'b0}}, BRAM_1[b1_addr],BRAM_0[b0_addr]};
                    2'b01: ram_data <= {{HALFWORD{1'b0}}, BRAM_2[b2_addr],BRAM_1[b1_addr]};
                    2'b10: ram_data <= {{HALFWORD{1'b0}}, BRAM_3[b3_addr],BRAM_2[b2_addr]};
                    2'b11: ram_data <= {{HALFWORD{1'b0}}, BRAM_0[b0_addr],BRAM_3[b3_addr]};
                  endcase
                end 
              READ_WORD    : begin
                  case(i_addr[1:0])
                    2'b00: ram_data <= {BRAM_3[b3_addr],BRAM_2[b2_addr],BRAM_1[b1_addr],BRAM_0[b0_addr]};
                    2'b01: ram_data <= {BRAM_0[b0_addr],BRAM_3[b3_addr],BRAM_2[b2_addr],BRAM_1[b1_addr]};
                    2'b10: ram_data <= {BRAM_1[b1_addr],BRAM_0[b0_addr],BRAM_3[b3_addr],BRAM_2[b2_addr]};
                    2'b11: ram_data <= {BRAM_2[b2_addr],BRAM_1[b1_addr],BRAM_0[b0_addr],BRAM_3[b3_addr]};
                  endcase
                end
            endcase // case (i_read_enable)
            ram_debug <= ram_debug ;
         end
         else begin
            ram_debug <= {BRAM_3[i_addr_debug],BRAM_2[i_addr_debug],BRAM_1[i_addr_debug],BRAM_0[i_addr_debug]};
            ram_data <= ram_data ;
         end // else: !if(i_debug_enb)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2
endmodule // Data_Memory
