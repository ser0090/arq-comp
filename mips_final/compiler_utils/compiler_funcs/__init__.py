
import re

def three_args_parser(strg):
	return re.search(r'(.*),(.*),(.*)',strg)

def two_args_parser(strg):
	return re.search(r'(.*),(.*)',strg)




opcode = {}
opcode['special'] = '000000'
opcode['addi']    = '001000'
opcode['slti']    = '001010'
opcode['andi']    = '001100'
opcode['ori']     = '001101'
opcode['xori']    = '001110'
opcode['lui']     = '001111'
opcode['lb']      = '100000'
opcode['lh']      = '100001'
opcode['lw']      = '100011'
opcode['lbu']     = '100100'
opcode['lhu']     = '100101'
opcode['lwu']     = '100111'
opcode['sb']      = '101000'
opcode['sh']      = '101001'
opcode['sw']      = '101011'
opcode['beq']     = '000100'
opcode['bne']     = '000101'
opcode['j']       = '000010'
opcode['jal']     = '000011'
opcode['jr']      = '000000'
opcode['jalr']    = '000000'
opcode['halt']    = '101111'









reg_file = {}
reg_file['$0']    = "00000"
reg_file['$1']    = "00001"
reg_file['$2']    = "00010"
reg_file['$3']    = "00011"
reg_file['$4']    = "00100"
reg_file['$5']    = "00101"
reg_file['$6']    = "00110"
reg_file['$7']    = "00111"
reg_file['$8']    = "01000"
reg_file['$9']    = "01001"
reg_file['$10']   = "01010"
reg_file['$11']   = "01011"
reg_file['$12']   = "01100"
reg_file['$13']   = "01101"
reg_file['$14']   = "01110"
reg_file['$15']   = "01111"
reg_file['$16']   = "10000"
reg_file['$17']   = "10001"
reg_file['$18']   = "10010"
reg_file['$19']   = "10011"
reg_file['$20']   = "10100"
reg_file['$21']   = "10101"
reg_file['$22']   = "10110"
reg_file['$23']   = "10111"
reg_file['$24']   = "11000"
reg_file['$25']   = "11001"
reg_file['$26']   = "11010"
reg_file['$27']   = "11011"
reg_file['$28']   = "11100"
reg_file['$29']   = "11101"
reg_file['$30']   = "11110"
reg_file['$31']   = "11111"

