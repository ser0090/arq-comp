#include "spi_execute.h"

void get_exec_stat(exec_stat *stat){
	spi_get(CS_EXEC, E_READ_ALU, 0, &stat->alu);
	spi_get(CS_EXEC, E_READ_RT,  0, &stat->rt);
	spi_get(CS_EXEC, E_READ_RD,  0, &stat->rd);
}
