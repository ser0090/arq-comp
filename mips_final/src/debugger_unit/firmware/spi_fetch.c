#include "spi_fetch.h"

void get_fetch_state(fetch_state *state){
	spi_get(CS_FETCH, F_READ_INST_LATCH, 0, &((*state).inst_latch));
	spi_get(CS_FETCH, F_READ_PC_LATCH  , 0, &((*state).pc_latch));
	spi_get(CS_FETCH, F_READ_PC        , 0, &((*state).pc));
}
