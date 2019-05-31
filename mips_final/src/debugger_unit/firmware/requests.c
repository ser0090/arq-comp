#include "requests.h"


void uart_blok_recv(XUartLite* module,u8 *buffer,unsigned int n){
	for (int i=0 ; i<n; i++)
		while(XUartLite_Recv(module,buffer+i,1) == 0);
}

void uart_blok_send(XUartLite* module,u8 *buffer,unsigned int n){
	for (int i=0 ; i<n; i++)
		while(XUartLite_Send(module,buffer+i,1) == 0);
}


void write_instruction_req(XUartLite *module){
	u16 addr;
	u32 inst;
	u8 reply = WRITE_INST_REQ;
	uart_blok_recv(module,(u8*)&addr,2);
	uart_blok_recv(module,(u8*)&inst,4);
	write_instruction(addr,inst);
	uart_blok_send(module,&reply,1);
}

void step_req(XUartLite *module){
	u8 reply = STEP_REQ;
	step();
	uart_blok_send(module,&reply,1);
/*		get_fetch_stat(&fetch_status);
		get_decode_stat(&decode_status);
		get_exec_stat(&exec_status);
		get_mem_stat(&mem_status);
		for(int i=0;i<ADDR_WINDOW;i++)
			get_mem_data(i*4,mem_data+i);*/
	}

void fetch_status_req(XUartLite *module){
	fetch_stat my_stat;
	u8 reply = FETCH_STATUS_REQ;
	get_fetch_stat(&my_stat);
	uart_blok_send(module,&reply,1);
	uart_blok_send(module,(u8*)&my_stat,sizeof(fetch_stat));
}

void decode_status_req(XUartLite *module){
	decode_stat my_stat;
	u8 reply = DECODE_STATUS_REQ;
	get_decode_stat(&my_stat);
	uart_blok_send(module,&reply,1);
	uart_blok_send(module,(u8*)&my_stat,sizeof(decode_stat));
}

void exec_status_req(XUartLite *module){
	exec_stat my_stat;
	u8 reply = EXEC_STATUS_REQ;
	get_exec_stat(&my_stat);
	uart_blok_send(module,&reply,1);
	uart_blok_send(module,(u8*)&my_stat,sizeof(exec_stat));
}

void mem_status_req(XUartLite *module){
	mem_stat my_stat;
	u8 reply = MEM_STATUS_REQ;
	get_mem_stat(&my_stat);
	uart_blok_send(module,&reply,1);
	uart_blok_send(module,(u8*)&my_stat,sizeof(mem_stat));
}
