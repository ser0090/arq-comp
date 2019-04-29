from .compiler_funcs import r_type
from .compiler_funcs import i_type



instruction = {'nop':(lambda: print("\ninvoked nop function\n"))};

instruction['sll']  = r_type.sll
instruction['srl']  = r_type.srl
instruction['sra']  = r_type.sra
instruction['sllv'] = r_type.sllv
instruction['srlv'] = r_type.srlv
instruction['srav'] = r_type.srav
instruction['jr']   = r_type.jr
instruction['jalr'] = r_type.jalr
instruction['addu'] = r_type.addu
instruction['subu'] = r_type.subu
instruction['and']  = r_type.and_f
instruction['or']   = r_type.or_f
instruction['xor']  = r_type.xor
instruction['nor']  = r_type.nor
instruction['slt']  = r_type.slt

instruction['addi']  = i_type.addi
instruction['slti']  = i_type.slti
instruction['andi']  = i_type.andi
instruction['ori']   = i_type.ori
instruction['xori']  = i_type.xori
instruction['lui']   = i_type.lui





