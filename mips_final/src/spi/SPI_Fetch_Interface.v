
`timescale 1ns/1ps

module SPI_Fetch_Interface#(
	parameter NB_BITS   = 32,
	parameter NB_LATCH  = 64,
	parameter RAM_DEPTH = 10
	) /* this is automatically generated */
	(
		output [RAM_DEPTH-1:0] o_addr,  //conectar a la SINGLE PORT RAM ADDR
		output [NB_BITS-1:0]   o_data,  //conectar a la singlePortRam data_in
		output    						 o_wea,   //conectar a la singlePortRam wea
		output [NB_BITS-1:0]	 o_SPI,   //conectar al SPI_Slave data_in

		input  [NB_BITS-1:0]   i_PC,    //conectar al PC_reg
		input  [NB_LATCH-1:0]  i_latch, //conectal latch (probablemente hay que concatenar regs)
		input  [NB_BITS-1:0]   i_SPI,   //conectar al SPI_Slave data_out
		input  								 i_in_use, // conectar al debug signal
		input									 i_clk,
		input									 i_rst
	);
   /* Estructura de lo recibido desde el micro
	  * 22: operaciones sobre la memoria ; 1 = write, 0 = nada
	  * 20-19: contiene un dato: 00 = operar sobre memoria ,  
	  *													01 = HL_DATA
	  *													10 = HU_DATA
	  *													11 = ADDRESS
	  * 18: unused
	  * 17-16: selector para extraer datos : 00 = PC
	  *																			01 = PC_LATCHED
	  *																			10 = INSTRUCTION_LATCHED
	  * 15- 0: half-word data				
	  */
	 reg [RAM_DEPTH-1:0]     addr;
	 reg [NB_BITS-1:0]       data;
	 reg [NB_BITS-1:0]       to_SPI;

	 assign o_addr = addr;
	 assign o_SPI  = to_SPI;
   assign o_data = data;
   assign o_wea = i_in_use & i_SPI[22];

   localparam WRITE_MEM_OR_NONE = 2'b00;
   localparam WRITE_DATA_HL     = 2'b01;
   localparam WRITE_DATA_HU     = 2'b10;
   localparam WRITE_ADDR        = 2'b11;

	 always @(posedge i_clk) begin
		  if (i_rst) begin
			   addr <= {RAM_DEPTH{1'b0}};
			   data <= {NB_BITS{1'b0}};
	    end
		  else begin
         case (i_SPI[20:19])
           WRITE_DATA_HL: begin
			        data[15:0]  <= i_SPI[15:0];
			        data[31:16] <= data[31:16];
			        addr <= addr;
           end
		       WRITE_DATA_HU: begin //HU
			        data[31:16] <= i_SPI[15:0];
			        data[15:0]  <= data[15:0];
			        addr <= addr;
		       end
		       WRITE_ADDR: begin //ADDR
			        addr <= i_SPI[RAM_DEPTH-1:0];
              data <= data;
		       end
           default: begin
			        addr <= addr;
              data <= data;
           end
         endcase // case (i_SPI[20:19])
      end // else: !if(i_rst)
	 end // always @ (posedge i_clk)


	localparam GET_PC      = 2'b00;
	localparam GET_LATCH_1 = 2'b01;
	localparam GET_LATCH_2 = 2'b10;

	always @(*) begin
		case(i_SPI[17:16])
			GET_PC:      to_SPI = i_PC; //PC
			GET_LATCH_1: to_SPI = i_latch[31:0]; //PC_larched
			GET_LATCH_2: to_SPI = i_latch[63:32]; // instruccion latcheada
			default:     to_SPI = {NB_BITS{1'b0}};
		endcase
	end

endmodule
