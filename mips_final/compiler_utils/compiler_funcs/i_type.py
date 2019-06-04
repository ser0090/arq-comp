from . import opcode
from . import reg_file
from . import three_args_parser
from . import two_args_parser
from . import num_or_label
import re

def to_16_bit_str(value):
	value_aux = 0 
	if value[0:2] == '0x':
		value_aux = int(value[2:],16)
	else:
		value_aux = int(value)

	sign = (value_aux) > 0
	string = ''
	for i in range (0,16):
		res = '1' if (value_aux % 2) else '0'
		value_aux = value_aux // 2
		string = string+res
	string = string[::-1] #reverse string
	return string if sign > 0 else complementar(string)

def complementar(binary_string):
	binary_string = binary_string[::-1] 
	complemented = ''
	for i in range(0,len(binary_string)):
		complemented = complemented + binary_string[i]
		if binary_string[i] is '1':
			break;
	for i in range(len(complemented),len(binary_string)):
		complemented = (complemented + '0') if binary_string[i] is '0' else (complemented + '1')
	return complemented[::-1]


def mem_args_parser(strg):
	return re.search(r'(.*),(.*)\((.*)\)',strg)


def addi(params):
	params = three_args_parser(params)
	rt = params.group(1).strip()
	rs = params.group(2).strip()
	inmediate = params.group(3).strip()	
	return(opcode['addi']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def slti(params):
	params = three_args_parser(params)
	rt = params.group(1).strip()
	rs = params.group(2).strip()
	inmediate = params.group(3).strip()	
	return(opcode['slti']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def andi(params):
	params = three_args_parser(params)
	rt = params.group(1).strip()
	rs = params.group(2).strip()
	inmediate = params.group(3).strip()	
	return(opcode['andi']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate)) 

def ori(params):
	params = three_args_parser(params)
	rt = params.group(1).strip()
	rs = params.group(2).strip()
	inmediate = params.group(3).strip()	
	return(opcode['ori']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))
def xori(params):
	params = three_args_parser(params)
	rt = params.group(1).strip()
	rs = params.group(2).strip()
	inmediate = params.group(3).strip()	
	return(opcode['xori']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lui(params):
	params = two_args_parser(params)
	rs = '$0'
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	
	return(opcode['lui']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lb(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lb']+ 
		  reg_file[rs]+ 
		  reg_file[rt]+ 
		  to_16_bit_str(inmediate))

def lh(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lh']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lw(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lw']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lbu(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lbu']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lhu(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lhu']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lwu(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['lwu']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def sb(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['sb']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def sh(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['sh']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def sw(params):
	params = mem_args_parser(params)
	rs = params.group(3).strip() #base
	rt = params.group(1).strip()
	inmediate = params.group(2).strip()	#offset
	return(opcode['sw']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))


def beq(params,labels,n):
	params = three_args_parser(params)
	rs = params.group(1).strip()
	rt = params.group(2).strip()
	inmediate = params.group(3).strip()	
	offset = num_or_label(inmediate,labels)
	offset = int(offset[2:],16) if offset[0:2] == '0x' else int(offset)
	if inmediate in labels:
		offset = offset - n - 1
	return(opcode['beq']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(str(offset)))

def bne(params,labels,n):
	params = three_args_parser(params)
	rs = params.group(1).strip()
	rt = params.group(2).strip()
	inmediate = params.group(3).strip()	
	offset = num_or_label(inmediate,labels)
	offset = int(offset[2:],16) if offset[0:2] == '0x' else int(offset)
	if inmediate in labels:
		offset = offset - n - 1
	return(opcode['bne']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(str(offset)))








