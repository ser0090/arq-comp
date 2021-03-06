`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

/** ####################### instrucction file init ########################## **/
`define INSTRUCTION_FILE "/home/sergio/arq-comp/mips_final/include/mem_instr.txt" //Comentar
//`define INSTR_FILE "/home/ssulca/arq-comp/mips_final/out.hex" //Comentar
//`define INSTRUCTION_FILE "/home/tincho/Documentos/ADC/arq-comp/mips_final/bin_str_file" //Comentar
//`define INSTRUCTION_FILE "/home/martin/Documentos/arq-comp/mips_final/out.bin" //Comentar

`define FILE_DEPTH 26

module Mips #
  (
   parameter NB_BITS    = `NB_BITS, /* asigancion de parametro local */
   parameter NB_REG     = `NB_REG,
   parameter NB_JMP     = `NB_JUMP,
   parameter NB_EXEC    = `NB_CTR_EXEC,
   parameter NB_MEM     = `NB_CTR_MEM,
   parameter NB_WB      = `NB_CTR_WB,
   parameter NB_MUX_FW  = `NB_MUX_FW,
   localparam NB_FUN    = `NB_FUN
   )
   (
    //output [31:0]         o_led,
    //output [5:0]          o_operation,
    //output [5:0]          o_function,
    output [NB_BITS-1:0]  o_MISO,
    output                o_halt,
    //output [NB_BITS-1:0] o_alu_data,
    //output [`NB_REG-1:0] o_reg_dst,
    //output [7:0]         o_wb_ctl,
    //input [NB_BITS-1:0]  i_wb_data,
    //input [NB_REG-1:0]   i_reg_dst,
    //input                i_wb_rf_webn,
    input                i_continue,
    input                i_valid,    // por flanco ascendente
    input                i_clk,
    input                i_rst,
    input [NB_BITS-1:0]  i_MOSI,
    input                i_SCLK,
    input [3:0]          i_SPI_cs

    );

   /* ##### SECUENCIAL ###### */

   /* ##### COMBINACIONAL ###### */

   /* #### WIRES #####*/
   wire                  debug_enb;
   // --- Wire Connectios FET/DEC ---
   wire [NB_BITS-1:0]    fet_2_dec_pc;
   wire [NB_BITS-1:0]    fet_2_dec_instr;
   wire [NB_BITS-1:0]    dec_2_fet_brh_addr;
   wire [NB_BITS-1:0]    dec_2_fet_jmp_addr;
   wire                  dec_2_fet_pc_beq;
   wire                  dec_2_fet_pc_src;
   wire                  dec_2_fet_flush;
   // --- Wire Connectios DEC/EXE ---
   wire [NB_BITS-1:0]    dec_2_ex_pc;
   wire [NB_BITS-1:0]    dec_2_ex_rs;
   wire [NB_BITS-1:0]    dec_2_ex_rt;
   wire [NB_BITS-1:0]    dec_2_ex_sgext;
   wire [NB_EXEC-1:0]    dec_2_ex_exec;
   wire [NB_FUN-1:0]     dec_2_ex_func;
   wire [NB_MEM-1:0]     dec_2_ex_mem;
   wire [NB_WB-1:0]      dec_2_ex_wrback;
   wire [NB_REG-1:0]     dec_2_ex_rt_num;
   wire [NB_REG-1:0]     dec_2_fw_rs_num;
   wire [NB_REG-1:0]     dec_2_ex_rd_num;
   /* ########## SALIDAS ############ */
   /* --- EX/MEM latch --- */
   wire [NB_BITS-1:0]    exe_2_mem_addr;
   wire [NB_BITS-1:0]    exe_2_mem_data;
   wire [NB_MEM-1:0]     exe_2_mem_ctl;
   wire [NB_WB-1:0]      exe_2_mem_wb_ctl;
   //wire [1:0]            exe_2_mem_write_ctl;
   //wire [1:0]            exe_2_mem_read_ctl;
   wire [`NB_REG-1:0]    exe_2_mem_reg_dst;
   //wire [`NB_CTR_WB-1:0] exe_2_mem_wb_ctl;

   /* --- MEM/WRITE BACK latch --- */
   wire [NB_BITS-1:0]    mem_2_wb_data;
   wire [NB_BITS-1:0]    mem_2_wb_alu_data;
   wire [NB_WB-2:0]      mem_2_wb_ctl;

   /* --- WRITE BACK signals --- */
   wire [NB_BITS-1:0]    wb_2_reg_data;
   wire                  wb_reg_enb;
   wire [NB_REG-1:0]     wb_reg_dst;

   /* --- FORWARFING UNITS signals --- */
   wire [NB_MUX_FW-1:0]  fw_2_exe_mux_a_hz;
   wire [NB_MUX_FW-1:0]  fw_2_exe_mux_b_hz;
   /* --- BUBBLE UNITS signals --- */
   wire [NB_REG-1:0]     dec_2_bub_rd;
   wire                  bub_2_dec_bubble;
   wire                  bub_2_fet_latch_we;
   wire                  bub_2_fet_pc_we;
   wire                  dec_2_bmb_branch;
   wire                  dec_2_bmb_rjump;
   /* --------- HALT signal ---------- */
   wire                  dec_halt;

   // wires para los spi de debug
   wire [NB_BITS-1:0]    SPI_2_Fetch;
   wire [NB_BITS-1:0]    Fetch_2_SPI;

   wire [NB_BITS-1:0]    SPI_2_Decode;
   wire [NB_BITS-1:0]    Decode_2_SPI;

   wire [NB_BITS-1:0]    SPI_2_Exe;
   wire [NB_BITS-1:0]    Exe_2_SPI;

   wire [NB_BITS-1:0]    SPI_2_Mem;
   wire [NB_BITS-1:0]    Mem_2_SPI;

   assign o_halt = ~dec_halt;//esta negado para que la salida sea activa por alto
   assign o_led       = wb_2_reg_data;// [31:0];
   assign o_operation = fet_2_dec_instr[31:26];
   assign o_function  = fet_2_dec_instr[5:0];

   /**#################################################################
    ###################### Unidad de Debugg  ##########################
    ##################################################################**/
   Debugger_interface #()
   inst_Debugger_interface
     (
      .o_debug_enb (debug_enb),
      .i_continue  (i_continue),
      .i_valid     (i_valid),
      .i_clk       (i_clk),
      .i_rst       (i_rst)
      );

   /**#################################################################
    #########################  UNIT FETCH  ############################
    ##################################################################**/
   Fetch_module #
     (
      //.FILE_DEPTH (`FILE_DEPTH),
      //.INIT_FILE  (`INSTR_FILE) //Comentar
      )
   inst_Fetch_module
     (
      .o_if_id_pc    (fet_2_dec_pc),
      .o_if_id_instr (fet_2_dec_instr),
      .o_to_SPI      (Fetch_2_SPI), // TODO: conectar con debuuger

      .i_brq_addr    (dec_2_fet_brh_addr),
      .i_jmp_addr    (dec_2_fet_jmp_addr),
      .i_ctr_beq     (dec_2_fet_pc_beq),
      .i_ctr_jmp     (dec_2_fet_pc_src),
      .i_ctr_flush   (dec_2_fet_flush),
      .i_pc_we       (bub_2_fet_pc_we),
      .i_if_id_we    (bub_2_fet_latch_we),
      .i_clk         (i_clk),
      .i_rst         (i_rst),

      .i_from_SPI    (SPI_2_Fetch), //conectar con debugger
      .i_debug_enb   (debug_enb & dec_halt),   // conectar con micro
      .i_cs_debug    (i_SPI_cs[0])  // conectar al chip sel del spi
      );

   //#########################  UNIT SPI  ############################
   SPI_Slave_Parallel #
     (
      .NB_BITS(NB_BITS)
      )
   inst_SPI_Slave_Parallel_Fetch
     (
      .o_MISO (o_MISO),
      .o_data (SPI_2_Fetch),
      .i_MOSI (i_MOSI),
      .i_SCLK (i_SCLK),
      .i_cs   (i_SPI_cs[0]),
      .i_data (Fetch_2_SPI),
      .i_rst  (i_rst),
      .i_clk  (i_clk)
      );

   /**#################################################################
    #########################  UNIT DECODE  ############################
    ##################################################################**/
   Decode_module #()
   inst_Decode_module
     (
      .o_id_ex_pc     (dec_2_ex_pc),
      .o_id_ex_rs     (dec_2_ex_rs),
      .o_id_ex_rt     (dec_2_ex_rt),
      .o_id_ex_sgext  (dec_2_ex_sgext),
      .o_id_ex_rt_num (dec_2_ex_rt_num),
      .o_id_ex_rs_num (dec_2_fw_rs_num),
      .o_id_ex_rd_num (dec_2_ex_rd_num),
      .o_id_ex_func   (dec_2_ex_func),

      .o_id_ex_wrback (dec_2_ex_wrback),
      .o_id_ex_mem    (dec_2_ex_mem),
      .o_id_ex_exec   (dec_2_ex_exec),

      .o_brh_addr     (dec_2_fet_brh_addr),
      .o_jmp_addr     (dec_2_fet_jmp_addr),
      .o_pc_beq       (dec_2_fet_pc_beq),
      .o_pc_src       (dec_2_fet_pc_src),
      .o_flush        (dec_2_fet_flush),
      .o_bmb_brch     (dec_2_bmb_branch), //signal brach instr
      .o_bmb_rjmp     (dec_2_bmb_rjump),  //signal r jump instr
      .o_halt         (dec_halt),         //HATL signal

      .o_to_SPI       (Decode_2_SPI),     // TODO: conectar SPI-salve

      .i_pc           (fet_2_dec_pc),
      .i_instr        (fet_2_dec_instr),
      .i_wb_data      (wb_2_reg_data),
      .i_reg_dst      (wb_reg_dst),
      .i_clk          (i_clk),
      .i_rst          (i_rst),

      .i_wb_rf_webn   (wb_reg_enb),

      .i_bubble       (bub_2_dec_bubble),

      .i_from_SPI     (SPI_2_Decode),     // conectar al debugger
      .i_cs_debug     (i_SPI_cs[1]),      // conectar al chip sel del spi
      .i_debug_enb    (debug_enb)         // conectar con micro
      );

   //#########################  UNIT SPI  ############################
   SPI_Slave_Parallel #
      ( // conectado al fetch
        .NB_BITS(NB_BITS)
        )
   inst_SPI_Slave_Parallel_Decode
     (
      .o_MISO (o_MISO),
      .o_data (SPI_2_Decode),
      .i_MOSI (i_MOSI),
      .i_SCLK (i_SCLK),
      .i_cs   (i_SPI_cs[1]),
      .i_data (Decode_2_SPI),
      .i_rst  (i_rst),
      .i_clk  (i_clk)
      );
   /**#################################################################
    #####################  UNIT EXECUTIOn  ############################
    ##################################################################**/

   Execution_module #()
   inst_Execution_module
     (
      .o_alu_out       (exe_2_mem_addr),
      .o_data_reg      (exe_2_mem_data),
      .o_reg_dst       (exe_2_mem_reg_dst),
      .o_wb_ctl        (exe_2_mem_wb_ctl),
      .o_mem_ctl       (exe_2_mem_ctl),
      .o_num_rd        (dec_2_bub_rd),
      .o_to_SPI        (Exe_2_SPI), // : conectar SPI-salve

      .i_mux_a_hz      (fw_2_exe_mux_a_hz),
      .i_mux_b_hz      (fw_2_exe_mux_b_hz),
      .i_ex_mem_reg_hz (exe_2_mem_addr),
      .i_mem_wb_reg_hz (wb_2_reg_data),
      .i_alu_op_ctl    (dec_2_ex_exec[8:5]),
      .i_mux_rs_ctl    (dec_2_ex_exec[4:3]),
      .i_mux_rt_ctl    (dec_2_ex_exec[0]),
      .i_mux_dest_ctl  (dec_2_ex_exec[2:1]),
      .i_rt            (dec_2_ex_rt_num),
      .i_rd            (dec_2_ex_rd_num),
      .i_sign_ext      (dec_2_ex_sgext),
      .i_rt_reg        (dec_2_ex_rt),
      .i_rs_reg        (dec_2_ex_rs),
      .i_pc_4          (dec_2_ex_pc),
      .i_function      (dec_2_ex_func),
      .i_wb_ctl        (dec_2_ex_wrback),
      .i_mem_ctl       (dec_2_ex_mem),
      .i_clk           (i_clk),
      .i_rst           (i_rst),

      .i_from_SPI      (SPI_2_Exe),  // : conectar al debugger
      .i_debug_enb     (debug_enb) // : conectar al micro
      );

   //#########################  UNIT SPI  ############################
   SPI_Slave_Parallel #
     ( // conectado al fetch
       .NB_BITS(NB_BITS)
       )
   inst_SPI_Slave_Parallel_Execution
     (
      .o_MISO (o_MISO),
      .o_data (SPI_2_Exe),
      .i_MOSI (i_MOSI),
      .i_SCLK (i_SCLK),
      .i_cs   (i_SPI_cs[2]),
      .i_data (Exe_2_SPI),
      .i_rst  (i_rst),
      .i_clk  (i_clk)
      );

   /**#################################################################
    #####################  UNIT EXECUTION  ############################
    ##################################################################**/

   Mem_module #()
   inst_Mem_module
     (
      .o_mem_data   (mem_2_wb_data),
      .o_alu_data   (mem_2_wb_alu_data),
      .o_wb_ctl     ({wb_reg_enb, mem_2_wb_ctl}),
      .o_reg_dst    (wb_reg_dst),
      .o_to_SPI     (Mem_2_SPI), // TODO:conectar al debugger

      .i_addr       (exe_2_mem_addr),
      .i_data       (exe_2_mem_data),
      .i_write_ctl  (exe_2_mem_ctl[1:0]),
      .i_read_ctl   (exe_2_mem_ctl[3:2]),
      .i_reg_dst    (exe_2_mem_reg_dst),
      .i_wb_ctl     (exe_2_mem_wb_ctl),
      .i_clk        (i_clk),
      .i_rst        (i_rst),
      .i_from_SPI   (SPI_2_Mem),  // TODO: conectar al debugger
      .i_debug_enb  (debug_enb)   // TODO: conectar al micro
      );

   //#########################  UNIT SPI  ############################

   SPI_Slave_Parallel #
     ( // conectado al fetch
       .NB_BITS(NB_BITS)
       )
   inst_SPI_Slave_Parallel_Mem
     (
      .o_MISO (o_MISO),
      .o_data (SPI_2_Mem),
      .i_MOSI (i_MOSI),
      .i_SCLK (i_SCLK),
      .i_cs   (i_SPI_cs[3]),
      .i_data (Mem_2_SPI),
      .i_rst  (i_rst),
      .i_clk  (i_clk)
      );

   /**#################################################################
    ########################  UNIT WRITE BACK #########################
    ##################################################################**/
   WriteBack_module #()
   inst_WriteBack_module
     (
      .o_data           (wb_2_reg_data),
      .i_mem_data       (mem_2_wb_data),
      .i_alu_data       (mem_2_wb_alu_data),
      .i_mux_mem_to_reg (mem_2_wb_ctl)
      );

   /**#################################################################
    ####################### UNIT FORWARDING ###########################
    ##################################################################**/

   Forwarding_Unit #()
   inst_Forwarding_Unit
     (
			.o_mux_a_hz     (fw_2_exe_mux_a_hz),
			.o_mux_b_hz     (fw_2_exe_mux_b_hz),
			.i_ex_mem_rd    (exe_2_mem_reg_dst),
			.i_mem_wb_rd    (wb_reg_dst),
			.i_id_ex_rs     (dec_2_fw_rs_num),
			.i_id_ex_rt     (dec_2_ex_rt_num),
			.i_ex_mem_wr_en (exe_2_mem_wb_ctl[2]),
			.i_mem_wb_wr_en (wb_reg_enb)
		  );
   /**#################################################################
    ########################### UNIT HAZARD ###########################
    ##################################################################**/

   Bubble_unit #()
   inst_Bubble_unit
     (
			.o_if_id_we (bub_2_fet_latch_we),
			.o_pc_we    (bub_2_fet_pc_we),
			.o_bubble   (bub_2_dec_bubble),
			.i_if_rs    (fet_2_dec_instr[25:21]), // rs
			.i_if_rt    (fet_2_dec_instr[20:16]), // rt
 			.i_idc_rd   (dec_2_bub_rd),           // rd from DEC
			.i_exe_rd   (exe_2_mem_reg_dst),      // rd from EXE
			.i_mem_rd   (wb_reg_dst),             // rd from MEM
			.i_read_mem (|dec_2_ex_mem[3:2]),     // read mem from DEC (or reduction 2 signals)
			.i_branch   (dec_2_bmb_branch),
			.i_jump     (dec_2_bmb_rjump),
			//.i_write_fr (dec_2_ex_wrback[2] | exe_2_mem_wb_ctl[2] | wb_reg_enb) //  fr
			.i_idc_wfr  (dec_2_ex_wrback[2]), // write back enabl fr
			.i_exe_wfr  (exe_2_mem_wb_ctl[2]), // write back enabl fr
			.i_mem_wfr  (wb_reg_enb) // write back enabl fr
		  );

endmodule // Mpis


