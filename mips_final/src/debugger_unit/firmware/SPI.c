#include "SPI.h"

static XGpio gpio_out;
static XGpio gpio_in;

int spi_initialize(){

	if(XGpio_Initialize(&gpio_in, PORT_IN)!=XST_SUCCESS){
	return ERROR;
	}

	if(XGpio_Initialize(&gpio_out, PORT_IN)!=XST_SUCCESS){
	return ERROR;
	}

	XGpio_SetDataDirection(&gpio_out, 1, 0x00000000);
	XGpio_SetDataDirection(&gpio_in, 1, 0xFFFFFFFF);

	return SUCCESS;
}

void spi_get(u32 cs,u32 ctl,u16 data,u32 *res){
	u32 aux =  cs | ctl | data ;
	XGpio_DiscreteWrite(&gpio_out,1, (u32)(aux));
    XGpio_DiscreteWrite(&gpio_out,1, (u32)( cs | ctl | SCLK ));
    XGpio_DiscreteWrite(&gpio_out,1, (u32)( cs ));

    *res = XGpio_DiscreteRead(&gpio_in, 1);

    XGpio_DiscreteWrite(&gpio_out,1, (u32)0);
    
}

void step(){
	XGpio_DiscreteWrite(&gpio_out,1, (u32)STEP);
    XGpio_DiscreteWrite(&gpio_out,1, (u32)0);
}
