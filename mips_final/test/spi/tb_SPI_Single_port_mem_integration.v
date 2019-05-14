`timescale 1ns/1ps

/* test de integracion del modulo SPI paralelo
* con una SinglePortRam para ver si funciona bien la temporizacion
*/

module tb_SPI_Singel_port_mem_integration ();
	parameter NB_BITS     = 32;
	parameter RAM_DEPTH   = 10;



	wire [NB_BITS-1:0] o_MISO;
	wire [NB_BITS-1:0] data_from_SPI;
	wire [NB_BITS-1:0] data_from_mem;

	
	reg i_rst;
	reg i_clk;
	reg [NB_BITS-1:0]   i_MOSI;
	reg                 i_SCLK;
	reg                 i_cs;
	reg [RAM_DEPTH-1:0] addr;
	reg [NB_BITS-1:0]   data_to_mem;
	reg [NB_BITS-1:0]   data_to_SPI;


	localparam MOSI_VALUE_1 = {8'b00010000,8'h0,16'hFFFF};
	localparam MOSI_VALUE_2 = {8'b00100000,8'h0,16'hF0F0};
	localparam MOSI_VALUE_3 = {8'b00110100,8'h0,16'hFFFF};
	localparam MOSI_VALUE_4 = {8'b10000000,8'h0,16'hFFFF};
	localparam MOSI_VALUE_5 = {8'b00000100,8'h0,16'h0};



	/* Estructura de lo recibido desde el micro
	 * 31: operaciones sobre la memoria ; 1 = write, 0 = nada
	 * 30: operaciones sobre la memoria ; 1 = read , 0 = nada
	 * 29-28: contiene un dato: 00 = operar sobre memoria ,  
	 *													01 = HL_DATA
	 *													10 = HU_DATA
	 *													11 = ADDRESS
	 * 27: unused
	 * 26-25: selector para extraer datos : 00 = PC
	 *																			01 = PC_LATCHED
	 *																			10 = INSTRUCTION_LATCHED
	 * 24-16: unused
	 * 15- 0: half-word data				
	 */

	always @(*) begin
		case(data_from_SPI[26:25])
			2'b00:   data_to_SPI = {{(NB_BITS-RAM_DEPTH){1'b0}},addr}; //PC
			2'b01:   data_to_SPI = {{(NB_BITS-RAM_DEPTH){1'b0}},addr-1}; //PC
			2'b10:   data_to_SPI = data_from_mem;
			default: data_to_SPI = {NB_BITS{1'b0}};
		endcase
	end

	always @(posedge i_clk) begin
		if (i_rst) begin
			addr        <= {RAM_DEPTH{1'b0}};
			data_to_mem <= {NB_BITS{1'b0}};
		end
		else if (data_from_SPI[29:28] == 2'b01) begin //HL
			data_to_mem[15:0] <= data_from_SPI[15:0];
		end
		else if (data_from_SPI[29:28] == 2'b10) begin //HU
			data_to_mem[31:16] <= data_from_SPI[15:0];
		end
		else if (data_from_SPI[29:28] == 2'b11) begin //ADDR
			 addr <= data_from_SPI[RAM_DEPTH-1:0];
		end
	end

	// clock
	initial begin
		i_clk  = 1'b0;
		i_rst  = 1'b1;
		i_MOSI = {NB_BITS{1'b0}};
		i_SCLK  = 1'b0;
		i_cs   = 1'b0;
		
		#34
		i_rst = 1'b0;
		#11
		i_cs   = 1'b1;
		i_MOSI = MOSI_VALUE_1;

		#30 
		i_SCLK  = 1'b1;
		#30 
		i_SCLK  = 1'b0;


		i_MOSI = MOSI_VALUE_2;
		#30 
		i_SCLK  = 1'b1;
		#30 
		i_SCLK  = 1'b0;
		

		i_MOSI = MOSI_VALUE_3;
		#30
		i_SCLK  = 1'b1;
		#30 
		i_SCLK  = 1'b0;
		

		i_MOSI = MOSI_VALUE_4;
		#30
		i_SCLK  = 1'b1;
		#30 
		i_SCLK  = 1'b0;


		i_MOSI = MOSI_VALUE_5;
		#30
		i_SCLK  = 1'b1;
		#30 
		i_SCLK  = 1'b0;


		#30
		i_MOSI  = {NB_BITS{1'b0}};		
		i_cs = 1'b0;
		#200
		$finish();

	
	end

	always #5 i_clk = ~i_clk;

	SPI_Slave_Parallel #(
			.NB_BITS(NB_BITS)
		) inst_SPI_Slave (
			.o_MISO (o_MISO),
			.o_data (data_from_SPI),
			.i_MOSI (i_MOSI),
			.i_SCLK (i_SCLK),
			.i_cs   (i_cs),
			.i_data (data_to_SPI),
			.i_rst  (i_rst),
			.i_clk  (i_clk)
		);

	Single_port_ram #
     (
      .RAM_WIDTH       (NB_BITS),        // Specify RAM data width
      .NB_DEPTH        (RAM_DEPTH),
      .SSL             (0) // NOP operation sll $0 $0 0
      )
   inst_ram_instruction
     (
      .o_data      (data_from_mem), // RAM output data,  RAM_WIDTH
      .i_addr      (addr),          // Address bus, width determined from RAM_DEPTH
      .i_data      (data_to_mem),   // RAM input data, width determined from RAM_WIDTH
      .i_clk       (i_clk),         // Clock
      .i_wea       (data_from_SPI[31]),          // Write enable
      //.i_ena     (i_if_id_we)     // RAM Enable
      .i_ctr_flush (1'b0),
      .i_if_id_we  (1'b1)
      );


endmodule
