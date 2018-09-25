`timescale 1ns / 1ps

module Rx_uart #
  (
   parameter NB_BITS = 8 /* asigancion de parametro local */
   )
   (
    output [NB_BITS-1:0] o_data, /* N bits more carry */
    output               o_rx_done,
    input                i_clk,
    input                i_rate,
    input                i_rx,
    input                i_rst
    );
   
   reg [NB_BITS-1:0]     shift_reg; // shift register para almacenar los datos
   reg [1:0]             state;
   reg [1:0]             next_state;
   reg [4:0]             time_count; // contador que da la temporizacion entre bits
   reg [3:0]             data_count; // contador de la cantidad de datos que llegan
   reg [NB_BITS-1:0]     rx_data; // registro par asignar la salida
   reg                   rx_done; // registro para asignar la salida
   
   assign o_data = rx_data;
   assign o_rx_done = rx_done;
   
   localparam idle = 2'b00;
   localparam start = 2'b01;
   localparam receiving = 2'b10;
   localparam stop = 2'b11;
   
   always @(posedge i_clk) begin
      if (i_rst) begin
         state <= idle; // cambio a estado inicial
         time_count <= 5'h0;
         data_count <= 4'h0;
         shift_reg <= {NB_BITS{1'b0}};
         rx_data <= {NB_BITS{1'b0}};
         rx_done <= 1'b0;
      end
      else begin
         if(i_rate == 1'b1) begin
            time_count <= time_count + 1;
         end
         else begin
            time_count <= time_count;
         end
         
         case (state)
           idle: begin
              rx_done <= 1'b0;
              if(i_rx == 1'b0) begin
                 state <= start; //cambio de estado
                 time_count <= 5'h7; // precarga del contador para contar 7
              end
              else begin
                 state <= state; // queda donde esta
                 //time_count <= time_count; // precarga del contador para contar 7
              end
           end // case: idle
           
           start: begin
              data_count <= 4'h0;
              if(time_count[4] == 1'b1) begin // si desborda el contador
                 time_count[4] <= 1'b0; // reinicio el tiempo
                 state <= receiving; //cambio de estado
              end
              else begin
                 //time_count <= time_count;
                 state <= state;
              end
           end // case: start
           
           receiving: begin
              if(data_count == NB_BITS) begin // si ya recibi todos los bits
                 time_count[4] <= 1'b0; // reinicio del contador
                 state <= stop; // cambio de estado
              end
              else if(time_count[4] == 1'b1) begin // si aun faltan bits y desbordo el contador
                 shift_reg <= {i_rx , shift_reg[NB_BITS-1:1]}; // shift al registro y carga de rx en MSB       
                 data_count <= data_count + 1;
                 time_count[4] <= 1'b0; // reinicio del contador
              end
              else begin
                 state <= state;
                 data_count <= data_count;
                 //time_count <= time_count;
              end
           end // case: receiving
           
           stop: begin
              if(time_count[4] == 1'b1 && i_rx == 1'b1) begin
                 rx_data <= shift_reg;
                 rx_done <= 1'b1;
                 state <= idle;
              end
              else begin
                 rx_data <= rx_data;
                 rx_done <= rx_done;
                 state <= state;
              end
           end // case: stop
           
         endcase // case (state)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)
   
endmodule // Rx_uart

