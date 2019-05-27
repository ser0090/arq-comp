#include "spi_fetch.h"

void get_fetch_stat(fetch_stat *state){
	spi_get(CS_FETCH, F_READ_INST_LATCH, 0, &state->inst_latch);
	spi_get(CS_FETCH, F_READ_PC_LATCH  , 0, &state->pc_latch);
	spi_get(CS_FETCH, F_READ_PC        , 0, &state->pc);
}

void write_instruction(u16 addr, u32 instruction){
	u32 aux;
	spi_get(CS_FETCH, F_DATA_HL   , (u16)(instruction & 0x0000FFFF), &aux);
	spi_get(CS_FETCH, F_DATA_HU   , (u16)(instruction >> 16), &aux);
	spi_get(CS_FETCH, F_DATA_ADDR , addr, &aux);
	spi_get(CS_FETCH, F_WRITE_INST, addr, &aux);
}