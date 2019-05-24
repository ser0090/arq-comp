#ifndef SPI_FETCH_H
#define SPI_FETCH_H

#include "SPI.h"

#define CS_FETCH (u32)(1<<25)

/* control */
/* formato de la instruccion de control
	  * 22: operaciones sobre la memoria ; 1 = write, 0 = nada
	  * 20-19: contiene un dato: 00 = operar sobre memoria ,  
	  *													 01 = HL_DATA
	  *													 10 = HU_DATA
	  *													 11 = ADDRESS
	  * 18: unused
	  * 17-16: selector para extraer datos : 00 = PC
	  *																			 01 = PC_LATCHED
	  *																			 10 = INSTRUCTION_LATCHED
	  * 15- 0: half-word data				
	  *
	  */

#define F_WRITE_INST   (u32)(1<<22)

#define F_DATA_NO_DATA (u32)(00<<19)
#define F_DATA_ADDR    (u32)(01<<19)
#define F_DATA_HU      (u32)(10<<19)
#define F_DATA_HL      (u32)(11<<19)

#define F_READ_PC         (u32)(00<<16)
#define F_READ_PC_LATCH   (u32)(01<<16)
#define F_READ_INST_LATCH (u32)(10<<16)

typedef struct {
	u32 pc;
	u32 pc_latch;
	u32 inst_latch;
} fetch_state;

void get_fetch_state(fetch_state *state);

#endif
