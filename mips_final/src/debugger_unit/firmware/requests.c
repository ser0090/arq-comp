#include "requests.h"


void uart_blok_recv(XUartLite* module,u8 *buffer,unsigned int n){
	for (int i=0 ; i<n; i++)
		while(XUartLite_Recv(module,buffer+i,1) == 0);
}

void write_instruction_req(XUartLite *module){
	u16 addr;
	u32 inst;
	u8 reply = WRITE_INST_REPLY;
	uart_blok_recv(module,(u8*)&addr,2);
	uart_blok_recv(module,(u8*)&inst,4);
	write_instruction(addr,inst);
	XUartLite_Send(module,&reply,1);
}

void step_req(XUartLite *module){
	u8 reply = STEP_REPLY;
	step();
	XUartLite_Send(module,&reply,1);
/*		get_fetch_stat(&fetch_status);
		get_decode_stat(&decode_status);
		get_exec_stat(&exec_status);
		get_mem_stat(&mem_status);
		for(int i=0;i<ADDR_WINDOW;i++)
			get_mem_data(i*4,mem_data+i);*/
	}

void fetch_status_req(XUartLite *module){
	fetch_stat my_fetch;
	get_fetch_stat(&my_fetch);
	XUartLite_Send(module,(u8*)&my_fetch,sizeof(fetch_stat));
}
