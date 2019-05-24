#ifndef SPI_DECODE_H
#define SPI_DECODE_H

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




















#endif