#ifndef SPI_H
#define SPI_H

#include "xparameters.h"
#include "xgpio.h"


/* el gpio de salida tiene el formato:
 *
 * 31        29   28   27                24            15                 0
 *  |CONTINUE|STEP|SCLK|..chip_eneables..|...control...|..half-word data..|
 *
 * continue : señal de inicionhasta el final del codigo 
 * step : dar un paso (un ciclo de clok)
 * SCLK : señal de clock de SPI
 * chip enables: para habilitar los esclavos SPI. Debe definirse para cada periferico en su .h 
 * control : señales de control propias del periferico. debe definirse en cada .h especifico
 *
 */


#define CS_DECODE (u32)(1<<26)
#define CS_EXEC   (u32)(1<<27)
#define CS_MEM    (u32)(1<<28)

#define SCLK      (u32)(1<<29)
#define STEP      (u32)(1<<30)
#define CONTINUE  (u32)(1<<31)

#define SUCCESS   0
#define ERROR    -1


#define PORT_IN	 		XPAR_GPIO_0_DEVICE_ID
#define PORT_OUT 		XPAR_GPIO_0_DEVICE_ID


int spi_initialize();

void spi_get(u32 cs,u32 ctl,u16 data,u32 *res);

void step();



#endif /* SPI_h */
