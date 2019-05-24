#ifndef SPI_DECODE_H
#define SPI_DECODE_H

#include "SPI.h"
#define CS_DECODE (u32)(1<<26)
/* FORMATO DE LA PETICION 
 * bits: accion
 * 20-16 : selector de registros: 0 = la operacion corresponde 
 *                                    a una extraccion del latch 
 *                                    y no de registro
 *                                X = numero de registro
 * 														  
 * 22-21 : selector de palabra de latch: 00 = PC_4     / primera palabra del latch
 *										 01 = RS_REG   / segunda palabra del latch
 *										 10 = RT_REG   / tercera palabra del latch
 *										 11 = SIGN_EXT / segunda palabra del latch
 *
 */

#define REG_ADDR_POSITION 16

#define D_READ_PC_4     (u32)(000<<21)
#define D_READ_RS       (u32)(001<<21)
#define D_READ_RT       (u32)(010<<21)
#define D_READ_SIGN_EXT (u32)(011<<21)
#define D_READ_REG      (u32)(100<<21)

struct reg_file{
	u32 r1;
	u32 r2;
	u32 r3;
	u32 r4;
	u32 r5;
	u32 r6;
	u32 r7;
	u32 r8;
	u32 r9;
	u32 r10;
	u32 r11;
	u32 r12;
	u32 r13;
	u32 r14;
	u32 r15;
	u32 r16;
	u32 r17;
	u32 r18;
	u32 r19;
	u32 r20;
	u32 r21;
	u32 r22;
	u32 r23;
	u32 r24;
	u32 r25;
	u32 r26;
	u32 r27;
	u32 r28;
	u32 r29;
	u32 r30;
	u32 r31;	
};
typedef struct{
	u32 pc_4;
	u32 rs;
	u32 rt;
	u32 sign_ext;
	struct reg_file registers;
}decode_stat;

void get_decode_stat(decode_stat *state);






#endif
