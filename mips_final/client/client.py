#!/usr/bin/python3

import argparse
import serial
import time
import client_utils.requests as cu
import sys

parser = argparse.ArgumentParser()
parser.add_argument("device", help="device to connect")
parser.add_argument("binFile", help="binary to send to MIPS processor")
args = parser.parse_args()

ser = serial.Serial(args.device, baudrate=115200, bytesize=serial.EIGHTBITS)  # open serial port

def print_help():
    print()
    print('write    write .bin file to MIPS ')
    print('echo     client-py test')
    print('start    launch MIPS to halt')
    print('step     step-by-step function, next instruction')
    print('fetch    get fetch stage status')
    print()

commands 		  = {'': lambda: print()} 
commands['exit']  = lambda: sys.exit(0) 
commands['write'] = lambda: cu.write_bin(ser,args.binFile)
commands['echo']  = lambda: print('asd')
commands['start'] = lambda: cu.start_req(ser)
commands['step']  = lambda: cu.step_req(ser)
commands['fetch'] = lambda: cu.fetch_req(ser)
commands['help']  = lambda: print_help()
                    


while True:
	line = input('>> ')
	try:
		commands[line.strip().lower()]()
	except KeyError:
		print('command don\'t exist, please see "help"')



ser.close()             # close port

