/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"


#include <stdio.h>
#include <string.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xgpio.h"
#include "platform.h"

#include "xuartlite.h"
//#include "encender_led.h"
#include "microblaze_sleep.h"




//CANALES DE GPIO       XPAR_AXI_GPIO_1_DEVICE_ID
#define PORT_IN	 		XPAR_GPIO_0_DEVICE_ID
#define PORT_OUT 		XPAR_GPIO_0_DEVICE_ID
//#define PORT_OUT_PARAM 	XPAR_AXI_GPIO_2_DEVICE_ID

//Device_ID Operaciones
#define def_SOFT_RST            16
#define def_ENABLE_MODULES      17
#define def_LOG_RUN             23
#define def_LOG_READ            24

//Device_ID Respuestas
#define def_ACK 				1
#define def_ERROR 				2
#define def_ID_NOT_FOUND		4
#define def_LOG_READ_SRRC       17

void send_trama(int id);
void send_ack(int from_id);

XGpio GpioOutput;
XGpio GpioParameter;
XGpio GpioInput;
u32 GPO_Value;
u32 GPO_Param;
XUartLite uart_module;

short int num_ber;
#include "funciones.h"


#define CS_FET (1<<1)
#define CS_DEC (1<<2)
#define CS_EXE (1<<3)
#define CS_MEM (1<<4)

#define PIN_SCLK     29
#define PIN_CONTINUE 31
#define PIN_STEP     30


int main()
{
	init_platform();
	int Status;
	XUartLite_Initialize(&uart_module, 0);

	GPO_Value=0x00000000;
	GPO_Param=0x00000000;

	//u16 tamano_datos;
	Status=XGpio_Initialize(&GpioInput, PORT_IN);
	if(Status!=XST_SUCCESS){
		send_trama(def_ERROR);
		return XST_FAILURE;
	}

	Status=XGpio_Initialize(&GpioOutput, PORT_OUT);
	if(Status!=XST_SUCCESS){
		send_trama(def_ERROR);
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(&GpioOutput, 1, 0x00000000);
	XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF);

	u32 value;
    while (1){
    	/* pulso de step */
    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)1<<PIN_STEP);
    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)0);

    	/* SPI */
    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)((CS_FET<<24) | (0b00000010<<16)));
    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)((CS_FET<<24) | (0b00000010<<16) | 1<<PIN_SCLK ));
    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)(CS_FET<<24));

    	value = XGpio_DiscreteRead(&GpioInput, 1);

    	XGpio_DiscreteWrite(&GpioOutput,1, (u32)0);

    }

    cleanup_platform();
    return 0;
}

void send_ack(int from_id){
	unsigned char cabecera[4]={0xA1,0x00,0x00,0x00};
	unsigned char fin_trama[1]={0x41};
	unsigned char datos[1];
	datos[0]=from_id;
	cabecera[3]=def_ACK;
	XUartLite_Send(&uart_module, cabecera,4);
	while(XUartLite_IsSending(&uart_module)){}
	XUartLite_Send(&uart_module, datos,1);
	XUartLite_Send(&uart_module, fin_trama,1);
}

void send_trama(int id){
	unsigned char cabecera[4]={0xA0,0x00,0x00,0x00};
	unsigned char fin_trama[1]={0x40};
	cabecera[3]=id;
	XUartLite_Send(&uart_module, cabecera,4);
	while(XUartLite_IsSending(&uart_module)){}
	XUartLite_Send(&uart_module, fin_trama,1);
}
