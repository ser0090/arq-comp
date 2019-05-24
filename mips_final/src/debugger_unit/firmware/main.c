
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "spi_fetch.h"



int main()
{
	fetch_state fs;
    init_platform();
    spi_initialize();

    fs.pc=0;
    fs.pc_latch=0;
    fs.inst_latch=0;

while(1){
	step();
	get_fetch_state(&fs);
}

    return 0;
}
