#ifndef SPI_MEM_H
#define SPI_MEM_H


#include "SPI.h"
#define CS_MEM    (u32)(0b1<<28)


/* FORMATO DE PETICION
 * bits:
 * 15-0 : direccion de memoria
 * 17-16: 00 = memory_out
 *        01 = mem_latched
 *        10 = alu_latched 
 *        11 = rd 
 */

#define M_READ_MEM_DATA  (u32)(0b00<<16)
#define M_READ_MEM_LATCH (u32)(0b01<<16)
#define M_READ_ALU_LATCH (u32)(0b10<<16)
#define M_READ_RD        (u32)(0b11<<16)


typedef struct{
	u32 mem;
	u32 alu;
	u32 rd;
}mem_stat;

void  get_mem_stat(mem_stat* stat);
void  get_mem_data(u16 addr, u32* value);





#endif
