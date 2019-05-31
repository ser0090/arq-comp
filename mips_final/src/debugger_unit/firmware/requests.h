#ifndef REQUESTS_H
#define REQUESTS_H

#include "xuartlite.h"
#include "spi_fetch.h"
#include "spi_decode.h"
#include "spi_execute.h"
#include "spi_mem.h"
#include "SPI.h"
/* Formato de comunicacion con PC
 * cabecera de 1byte que contiene el tipo de peticion
 * de acuerdo a esto sera la longitud del paquete 
 *

 *
 *  ####  REQUESTS  ####
 * 0x01: fetch  status request
 * 0x02: decode status request
 * 0x03: execute status request
 * 0x04: mem status request
 * 0x05: mem data request
 * 0x10: write instruction request
 * 0x20: step
 */
#define FETCH_STATUS_REQ   (u8)0x01
#define DECODE_STATUS_REQ  (u8)0x02
#define EXEC_STATUS_REQ    (u8)0x03
#define MEM_STATUS_REQ     (u8)0x04
#define MEM_DATA_REQ       (u8)0x05
#define WRITE_INST_REQ     (u8)0x10
#define STEP_REQ           (u8)0x20
#define START_REQ          (u8)0x30


/*
 * write instruction request:
 *		-u16: address
 *		-u32: instruction
 * 	
 * fetch status request:
 * 		- without body
 *
 * decode status request:
 * 		- without body
 * 
 * execution status request:
 * 		- without body
 *
 * memory status request:
 * 		- without body
 *
 * mem data request:
 *		-u16: address
 *		-u32: instruction
 *


 * ####  REPLY  ####
 * 0x01: fetch  status reply
 * 0x02: decode status reply
 * 0x03: execute status reply
 * 0x04: mem status reply
 * 0x05: mem data reply
 * 0x10: write instruction ack
 * 0x20: step ack
 */

/* write instruction reply:
 * 		-no reply
 *
 * fetch status reply :
 * 		- u32 pc;
 * 		- u32 pc_latch;
 * 		- u32 inst_latch;
 * decode status reply :
 * 		-u32 pc_4
 * 		-u32 rs
 * 		-u32 rt
 * 		-u32 sign extended
 * 		-u32x31 registers
 *
 * execute status reply :
 *		-u32 alu
 *		-u32 rt
 *		-u32 rd
 *
 * mem status reply:
 *		-u32 mem
 *		-u32 alu
 *		-u32 rd
 *
 * mem data reply:
 *		-u32 mem[addr]
 *		-u32 mem[addr+0x04]
 *		-u32 mem[addr+0x08]
 *		-u32 mem[addr+0x0c]
 *		-u32 mem[addr+0x10]
 *		-u32 mem[addr+0x14]
 *		-u32 mem[addr+0x18]
 *		-u32 mem[addr+0x1c]
 *		-u32 mem[addr+0x20]
 *		-u32 mem[addr+0x24]
 *
 */

void uart_blok_recv(XUartLite* module,u8 *buffer,unsigned int n);
void uart_blok_send(XUartLite* module,u8 *buffer,unsigned int n);
void write_instruction_req(XUartLite *module);
void step_req(XUartLite *module);
void fetch_status_req(XUartLite *module);
void decode_status_req(XUartLite *module);
void exec_status_req(XUartLite *module);
void mem_status_req(XUartLite *module);





#endif
