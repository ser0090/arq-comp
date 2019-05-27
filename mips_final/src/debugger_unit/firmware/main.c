
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "spi_fetch.h"
#include "spi_decode.h"
#include "spi_execute.h"
#include "spi_mem.h"

#define ADDR_WINDOW 10

int main()
{
	u32 mem_data[ADDR_WINDOW];
	fetch_stat  fetch_status;
    decode_stat decode_status;
    exec_stat   exec_status;
    mem_stat    mem_status;
    init_platform();
    spi_initialize();

    for(int i=0;i<16;i++){
    	write_instruction((u16)i,0xFFFFFFFF);
    }



while(1){
	step();
	get_fetch_stat(&fetch_status);
	get_decode_stat(&decode_status);
	get_exec_stat(&exec_status);
	get_mem_stat(&mem_status);
	for(int i=0;i<ADDR_WINDOW;i++)
		get_mem_data(i*4,mem_data+i);

}

    return 0;
}
