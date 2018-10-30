`timescale 1ns / 1ps
//`include "/home/sergio/Documentos/ADC/arq-comp/ADC-TP2_UART/src/Baud_rate_gen.v"
//`include "/home/sergio/Documentos/ADC/arq-comp/ADC-TP2_UART/src/Tx_uart.v"
//`include "/home/sergio/Documentos/ADC/arq-comp/ADC-TP2_UART/src/Rx_uart.v"
/* definicion de parametros globales */


module UART #
  (
   parameter NB_BITS = 8,
   parameter DATA_BUS_WIDTH = 16,
   parameter ADDR_BUS_WIDTH = 11,
   localparam INIT_ADDR = {ADDR_BUS_WIDTH{1'b0}}
   )
  (
   output                     o_tx,
   output                     o_cpu_enable,
   input                      i_rx,
   input                      i_clk,
   input                      i_rst,
   input                      i_cs, // chip select to use de bus
   input                      i_w_r,
   input [ADDR_BUS_WIDTH-1:0] i_addr_bus,
   inout [DATA_BUS_WIDTH-1:0] io_data_bus
  );
   
   reg [DATA_BUS_WIDTH-1:0]   tx_reg; 			// 000
   reg [DATA_BUS_WIDTH-1:0]   tx_done_reg; 		// 001
   reg [DATA_BUS_WIDTH-1:0]   tx_data_ready_reg;	// 010
   reg [DATA_BUS_WIDTH-1:0]   rx_reg;  			// 011
   reg [DATA_BUS_WIDTH-1:0]   rx_done_reg; 		// 100
   
   wire                       rate;
   wire                       tx;
   wire [NB_BITS-1:0]         rx_data;
   wire                       rx_done;
   wire [NB_BITS-1:0]         tx_data;
   wire                       tx_done;
   wire                       tx_data_ready;
   
   reg [DATA_BUS_WIDTH-1:0] data_bus;
   assign io_data_bus = ((i_w_r == 0) && 
                         (i_addr_bus >= INIT_ADDR) && 
                         (i_addr_bus <= (INIT_ADDR+3'd4)) && 
                         (i_cs == 1'b1))? data_bus: 'bz;
   assign o_tx = tx;

   assign tx_data = tx_reg;
   assign tx_data_ready = tx_data_ready_reg[0];
   assign o_cpu_enable = rx_done_reg[0];
   //assign o_rx_data = rx_data;
   //assign o_rx_done = rx_done;
   //assign o_tx_done = tx_done;
   
   // si llego algo, lo paso a los registros de acceso memoria.
	 always @(posedge i_clk) begin
		  if(i_rst)begin
			   data_bus <= {DATA_BUS_WIDTH{1'b0}};
			   tx_reg <= {DATA_BUS_WIDTH{1'b0}}; //000
  		   tx_done_reg <= {DATA_BUS_WIDTH{1'b0}}; //001
  			 tx_data_ready_reg<= {DATA_BUS_WIDTH{1'b0}};
			   rx_reg <= {DATA_BUS_WIDTH{1'b0}};  //011
  			 rx_done_reg <= {DATA_BUS_WIDTH{1'b0}}; //100
	    end
		  else begin
			   if(i_cs) begin
				    if(i_w_r == 0) begin // lectura
					     case(i_addr_bus)
						     INIT_ADDR: data_bus <= tx_reg;
						     (INIT_ADDR+3'd1): data_bus<= tx_done_reg;
						     (INIT_ADDR+3'd2): data_bus<= tx_data_ready_reg;
						     (INIT_ADDR+3'd3): data_bus<= rx_reg;
						     (INIT_ADDR+3'd4): data_bus<= rx_done_reg;
						     default: data_bus <= data_bus;
					     endcase // case (i_addr_bus)
				    end
				    else begin
					     case(i_addr_bus)
						     INIT_ADDR:begin
									  tx_reg <= io_data_bus;
									  tx_done_reg <=tx_done_reg;
									  tx_data_ready_reg <= tx_data_ready_reg;
									  rx_reg <= rx_reg;
									  rx_done_reg <= rx_done_reg;
								 end
						     (INIT_ADDR+3'd1):begin
										tx_reg <= tx_reg;
										tx_done_reg <= io_data_bus;
										tx_data_ready_reg <= tx_data_ready_reg;
										rx_reg <= rx_reg;
										rx_done_reg <= rx_done_reg;
								 end
						     (INIT_ADDR+3'd2):begin
										tx_reg <= tx_reg;
										tx_done_reg <=tx_done_reg;
										tx_data_ready_reg <= io_data_bus;
										rx_reg <= rx_reg;
										rx_done_reg <= rx_done_reg;
								 end
						     (INIT_ADDR+3'd3):begin
										tx_reg <= tx_reg;
										tx_done_reg <=tx_done_reg;
										tx_data_ready_reg <= tx_data_ready_reg;
										rx_reg <= io_data_bus;
										rx_done_reg <= rx_done_reg;
								 end
						     (INIT_ADDR+3'd4):begin
										tx_reg <= tx_reg;
										tx_done_reg <=tx_done_reg;
										tx_data_ready_reg <= tx_data_ready_reg;
										rx_reg <= rx_reg;
										rx_done_reg <= io_data_bus;
								 end
						     default: begin
									  tx_reg <= tx_reg;
									  tx_done_reg <=tx_done_reg;
									  tx_data_ready_reg <= tx_data_ready_reg;
									  rx_reg <= rx_reg;
									  rx_done_reg <= rx_done_reg;
								 end
					     endcase // case (i_addr_bus)
				    end // else: !if(i_w_r == 0)
			   end // if (i_cs)
			   else begin
				    if(rx_done == 1'b1)begin
				       rx_reg <= {{(DATA_BUS_WIDTH-NB_BITS){1'b0}},rx_data};
				       rx_done_reg <= {{(DATA_BUS_WIDTH-1){1'b0}},1'b1};
				    end
				    else begin
				       rx_reg <= rx_reg;
				       rx_done_reg <= rx_done_reg;
				    end
				    if(tx_done == 1'b1)begin
				       tx_done_reg <= {{(DATA_BUS_WIDTH-1){1'b0}},1'b1};
				       tx_data_ready_reg <= {DATA_BUS_WIDTH{1'b0}};
				    end
				    else begin
				       tx_done_reg <= tx_done_reg;
				       tx_data_ready_reg <= tx_data_ready_reg;
				    end
			   end // else: !if(i_cs)
		  end // else: !if(i_rst)
	 end // always @ (posedge i_clk)
   
  	Baud_rate_gen
      inst_Baud_rate_gen 
        (
			   .o_rate (rate),
			   .i_clk  (i_clk),
			   .i_rst  (i_rst)
		     );

	Rx_uart #(.NB_BITS(NB_BITS)) 
      inst_Rx_uart
        (
			   .o_data    (rx_data),
			   .o_rx_done (rx_done),
			   .i_clk     (i_clk),
			   .i_rate    (rate),
			   .i_rx      (i_rx),
			   .i_rst     (i_rst)
		     );

	Tx_uart #(.NB_BITS(NB_BITS)) 
      inst_Tx_uart
        (
			   .o_tx         (tx),
			   .o_tx_done    (tx_done),
			   .i_data_ready (tx_data_ready),
			   .i_clk        (i_clk),
			   .i_rate       (rate),
			   .i_rst        (i_rst),
			   .i_data       (tx_data)
		     );
   
endmodule // UART

