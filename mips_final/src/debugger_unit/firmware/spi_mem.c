#include "spi_mem.h"

void get_mem_stat(mem_stat* stat){
	spi_get(CS_MEM, M_READ_RD       , 0,&stat->rd);
	spi_get(CS_MEM, M_READ_MEM_LATCH, 0,&stat->mem);
	spi_get(CS_MEM, M_READ_ALU_LATCH, 0,&stat->alu);
}

void get_mem_data(u16 addr, u32* value){
	spi_get(CS_MEM, M_READ_MEM_DATA, addr, value);
}
