#include "spi_decode.h"



void get_decode_stat(decode_stat *state){
	spi_get(CS_DECODE, D_READ_PC_4,0, &state->pc_4);
	spi_get(CS_DECODE, D_READ_PC_4,0, &state->rs);
	spi_get(CS_DECODE, D_READ_PC_4,0, &state->rt);
	spi_get(CS_DECODE, D_READ_PC_4,0, &state->sign_ext);

	for (int i = 0; i < 30; ++i)
	{
		spi_get(CS_DECODE,
		        D_READ_REG|(i+1)<<REG_ADDR_POSITION,
		        0,
		        (u32*)state + i);
	}
}
