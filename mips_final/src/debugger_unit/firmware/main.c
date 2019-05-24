
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "spi_fetch.h"
#include "spi_decode.h"


int main()
{
	fetch_stat fetch_status;
    decode_stat decode_status;
    init_platform();
    spi_initialize();


while(1){
	step();
	get_fetch_stat(&fetch_status);
	get_decode_stat(&decode_status);
}

    return 0;
}
