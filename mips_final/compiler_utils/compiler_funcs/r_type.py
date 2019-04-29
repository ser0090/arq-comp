from . import opcode
from . import reg_file

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


def sll(parsed_params):
	rs = '$0'
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sll'])


def srl(parsed_params):
	rs = '$0'
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srl'])
	
def sra(parsed_params):
	rs = '$0'
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sra'])

def sllv(parsed_params):
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = '00000'
	rs = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['sllv'])

def srlv(parsed_params):
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = '00000'
	rs = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srlv'])

def srav(parsed_params):
	rd = parsed_params.group(2).strip()
	rt = parsed_params.group(3).strip()
	sa = '00000'
	rs = parsed_params.group(4).strip()	
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['srav'])

def addu(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['addu'])

def subu(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['subu'])

def and_f(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['and'])

def or_f(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['or'])

def xor(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['xor'])

def nor(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['nor'])

def slt(parsed_params):
	rd = parsed_params.group(2).strip()
	rs = parsed_params.group(3).strip()
	rt = parsed_params.group(4).strip()	
	sa = '00000'
	return(opcode['special']+
		  reg_file[rs]+
		  reg_file[rt]+
		  reg_file[rd]+
		  sa+
		  function['slt'])


def jr(parsed_params):
	print("function not implemented yet..")
	exit(1)

def jalr(parsed_params):
	print ("function not implemented yet..")
	exit(1)