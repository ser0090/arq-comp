import serial as sr
from . import request_codes, request_codes


def _wait_ack(serial,value):
		a = serial.read(1) #receive ack
		while(a != value): ## el ack contiene el mismo codigo de request
			print('unexpected ack: ',a)
			a = serial.read(1)

def write_bin(serial,bin_file_path):
	try:
		bin_file = open(bin_file_path,'rb')
	except FileNotFoundError:
		print ("File Not Found: ",bin_file_path)
		return
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
	_wait_ack(serial,request_codes['fetch'])
	pc     = serial.read(4)[::-1]
	pc_4   = serial.read(4)[::-1]
	inst   = serial.read(4)[::-1]
	cycles = serial.read(4)[::-1]
	print("pc  :   ",''.join(format(x, '02x') for x in pc))
	print("pc_4:   ",''.join(format(x, '02x') for x in pc_4))
	print("inst:   ",''.join(format(x, '02x') for x in inst))
	print("cycles: ",''.join(format(x, '02x') for x in cycles))


def decode_req(serial):
    serial.write(request_codes['decode'])
    _wait_ack(serial,request_codes['decode'])
    pc_4 = serial.read(4)[::-1]
    rs = serial.read(4)[::-1]
    rt = serial.read(4)[::-1]
    sign_ext = serial.read(4)[::-1]
    reg_file = {}
    for i in range(1,32):
        reg_file[i] = serial.read(4)[::-1]

    print("pc_4:     0x",''.join(format(x, '02x') for x in pc_4))
    print("rs:       0x",''.join(format(x, '02x') for x in rs))    
    print("rt:       0x",''.join(format(x, '02x') for x in rt))
    print("sign_ext: 0x",''.join(format(x, '02x') for x in sign_ext))
    print("register_file: ")
    for k,v in reg_file.items():
        print('    ${}'.format(k),": 0x",''.join(format(x, '02x') for x in v))

def exec_req(serial):
	serial.write(request_codes['exec'])
	_wait_ack(serial,request_codes['exec'])
	alu = serial.read(4)[::-1]
	rt = serial.read(4)[::-1]
	rd = serial.read(4)[::-1]
	print("alu: 0x",''.join(format(x, '02x') for x in alu))
	print("rt:  0x",''.join(format(x, '02x') for x in rt))
	print("rd:  0x",''.join(format(x, '02x') for x in rd))

def mem_req(serial):
	serial.write(request_codes['mem'])
	_wait_ack(serial,request_codes['mem'])
	mem = serial.read(4)[::-1]
	alu = serial.read(4)[::-1]
	rd = serial.read(4)[::-1]
	print("mem: 0x",''.join(format(x, '02x') for x in mem))
	print("alu: 0x",''.join(format(x, '02x') for x in alu))
	print("rd:  0x",''.join(format(x, '02x') for x in rd))

def mem_data_req(serial,addr,word_count):
	serial.write(request_codes['mem_data']) #write header
	serial.write(bytearray([(addr//4)%256 , (addr//4)//256])) # send address
	serial.write(bytearray([(word_count//4)%256 , (word_count//4)//256])) # send count
	_wait_ack(serial,request_codes['mem_data'])
	words=[]
	print('addr             value')
	for i in range(word_count):
		words.append(serial.read())
		print('0x'.join(addr+i),":  0x",''.join(format(x, '02x') for x in words[i]))