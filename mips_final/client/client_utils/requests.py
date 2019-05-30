import serial as sr
from . import request_codes, request_codes


def _wait_ack(serial,value):
	a = serial.read(1) #receive ack
	while(a != value): ## el ack contiene el mismo codigo de request
		print('unexpected ack')
		a = serial.read(1)

def write_bin(serial,bin_file_path):
	bin_file = open(bin_file_path,'rb')
	program_bytes = bin_file.read()
	bin_file.close()

	for i in range(0,len(program_bytes)-1,4):
		serial.write(request_codes['write_bin']) # send header
		serial.write(bytearray([(i//4)%256 , (i//4)//256])) # send address
		serial.write(program_bytes[i:i+4][::-1])  # send instruction
		_wait_ack(serial,request_codes['write_bin']) ## el ack contiene el mismo codigo de request


def start_req(serial):
	serial.write(request_codes['start'])

def step_req(serial):
	serial.write(request_codes['step'])
	_wait_ack(serial,request_codes['step'])

def fetch_req(serial):
	serial.write(request_codes['fetch'])
	pc = serial.read(4)[::-1]
	pc_4 = serial.read(4)[::-1]
	inst = serial.read(4)[::-1]
	print("pc  : ",pc)
	print("pc_4: ",pc_4)
	print("inst: ",inst)


