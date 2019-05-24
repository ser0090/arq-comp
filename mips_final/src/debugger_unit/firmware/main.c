
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "spi_fetch.h"
#include "spi_decode.h"
#include "spi_execute.h"

int main()
{
	fetch_stat  fetch_status;
    decode_stat decode_status;
    exec_stat   exec_status;
    init_platform();
    spi_initialize();


while(1){
	step();
	get_fetch_stat(&fetch_status);
	get_decode_stat(&decode_status);
	get_exec_stat(&exec_status);
}

    return 0;
}
