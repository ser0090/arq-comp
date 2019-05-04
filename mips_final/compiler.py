#!/usr/bin/python3

import argparse
import re
from compiler_utils import instruction

parser = argparse.ArgumentParser()
parser.add_argument("input", help="input file to be compiled")
parser.add_argument("--output","-o", help="output file to be compiled")
args = parser.parse_args()

in_file = open(args.input,'r')

if args.output:
	out_file_name = args.output
else:
	out_file_name = './bin_str_file'

out_file = open(out_file_name,'w')
if in_file.closed:
	print("file error")

while(True):
	line = in_file.readline()

	if line is None or \
	   line is "" or \
	   line is "\n": break


	so = re.search(r'(\w*) (.*)',line)

	print(so.group())
	
	#print("group1 :", so.group(1).strip())
	func = instruction[so.group(1).strip().lower()]
	inst = func(so.group(2))
	out_file.write(inst+'\n')




out_file.close()
in_file.close()