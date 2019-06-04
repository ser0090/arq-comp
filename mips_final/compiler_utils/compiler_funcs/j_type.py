from . import opcode
from . import reg_file
from . import r_type
from . import two_args_parser
from . import num_or_label

def to_26_bit_str(value):
	value_aux = 0 
	if value[0:2] == '0x':
		value_aux = int(value[2:],16)
	else:
		value_aux = int(value)
	string = ''
	for i in range (0,26):
		res = '1' if (value_aux % 2) else '0'
		value_aux = value_aux // 2
		string = string+res

	return string[::-1] #reverse string


def j(params,labels):
	return(opcode['j']+
		  to_26_bit_str(num_or_label(params.strip(),labels)))

def jal(params,labels):
	return(opcode['jal']+
		  to_26_bit_str(num_or_label(params.strip(),labels)))


def jr(params):
	rs = params.strip()
	return(opcode['jr']+
		   reg_file[rs] +
		   ('0'*15) +
		   r_type.function['jr'])

def jalr(params):
	pars = two_args_parser(params)
	rs,rd = '',''
	rt = '$0'
	if pars is None:
		rs = params.strip()
		rd = '$31'
	else: 
		rs = pars.group(1).strip()
		rd = pars.group(2).strip()
	return(opcode['jalr']+
		   reg_file[rs] +
		   reg_file[rt] +
		   reg_file[rd] +
		   '0'*5 +
		   r_type.function['jalr'])

def halt(params):
	return(opcode['halt']+
		  to_26_bit_str('0')
		  )

