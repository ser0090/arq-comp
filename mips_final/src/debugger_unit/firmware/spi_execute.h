#ifndef SPI_EXECUTE_H
#define SPI_EXECUTE_H

#include "SPI.h"
#define CS_EXEC   (u32)(1<<27)
/*FORMATO DE PETICION
* bits: 17-16: 00 = alu_out
*              01 = rt_reg
*              10 = rd
*/

#define E_READ_ALU (u32)(00<<16)
#define E_READ_RT  (u32)(01<<16)
#define E_READ_RD  (u32)(10<<16)

typedef struct{
	u32 alu;
	u32 rt;
	u32 rd;
}exec_stat;

void get_exec_stat(exec_stat *stat);


#endif
