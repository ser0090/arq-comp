from . import opcode
from . import reg_file
from . import three_args_parser


function = {}
function['sll']  = "000000"
function['srl']  = "000010"
function['sra']  = "000011"
function['sllv'] = "000100"
function['srlv'] = "000110"
function['srav'] = "000111"
function['jr']   = "001000"
function['jalr'] = "001001"
function['addu'] = "100001"
function['subu'] = "100011"
function['and']  = "100100"
function['or']   = "100101"
function['xor']  = "100110"
function['nor']  = "100111"
function['slt']  = "101010"


def sll(params):
	params = three_args_parser(params)
	params = t
	rs = '$0'
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sll'])


def srl(params):
	params = three_args_parser(params)
	rs = '$0'
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srl'])
	
def sra(params):
	params = three_args_parser(params)
	rs = '$0'
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sra'])

def sllv(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = '00000'
	rs = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sllv'])

def srlv(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = '00000'
	rs = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srlv'])

def srav(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rt = params.group(2).strip()
	sa = '00000'
	rs = params.group(3).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srav'])

def addu(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['addu'])

def subu(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['subu'])

def and_f(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['and'])

def or_f(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['or'])

def xor(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['xor'])

def nor(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['nor'])

def slt(params):
	params = three_args_parser(params)
	rd = params.group(1).strip()
	rs = params.group(2).strip()
	rt = params.group(3).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['slt'])

