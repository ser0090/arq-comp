
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "SPI.h"
#include "xuartlite.h"
#include "requests.h"

#define ADDR_WINDOW 10
/*static u32 		   mem_data[ADDR_WINDOW];
static fetch_stat  fetch_status;
static decode_stat decode_status;
static exec_stat   exec_status;
static mem_stat    mem_status;
*/

void start();
void write_inst();
void uart_blok_recv(XUartLite*,u8*,unsigned int);
int main()
{	
	static XUartLite   uart_module;
    init_platform();
    XUartLite_Initialize(&uart_module, 0);
    XUartLite_ResetFifos(&uart_module);
    spi_initialize();
u8 header;
while(1){
	header = 0; // reset header
	uart_blok_recv(&uart_module,&header,1);
	switch(header){
		case FETCH_STATUS_REQ:
			fetch_status_req(&uart_module);
			break;
		case DECODE_STATUS_REQ:
			decode_status_req(&uart_module);
			break;
		case EXEC_STATUS_REQ:
			exec_status_req(&uart_module);
			break;
		case MEM_STATUS_REQ:
			mem_status_req(&uart_module);
			break;
		case MEM_DATA_REQ:
			mem_data_req(&uart_module);
			break;
		case WRITE_INST_REQ:
			write_instruction_req(&uart_module);
			break;
		case STEP_REQ:
			step_req(&uart_module);
			break;
	}

}
    return 0;
}


