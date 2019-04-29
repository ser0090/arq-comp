from . import opcode
from . import reg_file

def to_16_bit_str(value):
	value = int(value)
	string = ''
	for i in range (0,16):
		res = '1' if (value % 2) else '0'
		value = value // 2
		string = string+res
	return string[::-1] #reverse string

def addi(parsed_params):
	rt = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	inmediate = parsed_params.group(4).strip()	
	return(opcode['addi']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def slti(parsed_params):
	rt = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	inmediate = parsed_params.group(4).strip()	
	return(opcode['slti']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def andi(parsed_params):
	rt = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	inmediate = parsed_params.group(4).strip()	
	return(opcode['andi']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate)) 

def ori(parsed_params):
	rt = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	inmediate = parsed_params.group(4).strip()	
	return(opcode['ori']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))
def xori(parsed_params):
	rt = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	inmediate = parsed_params.group(4).strip()	
	return(opcode['xori']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))

def lui(parsed_params):
	rs = '$0'
	rt = parsed_params.group(2).strip()
	inmediate = parsed_params.group(3).strip()	
	return(opcode['lui']+
		  reg_file[rs]+
		  reg_file[rt]+
		  to_16_bit_str(inmediate))














