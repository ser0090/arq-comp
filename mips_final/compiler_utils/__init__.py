from .compiler_funcs import r_type
from .compiler_funcs import i_type
from .compiler_funcs import j_type


instruction = {'nop':(lambda arg: '0'*32)};

instruction['sll']  = r_type.sll
instruction['srl']  = r_type.srl
instruction['sra']  = r_type.sra
instruction['sllv'] = r_type.sllv
instruction['srlv'] = r_type.srlv
instruction['srav'] = r_type.srav
instruction['addu'] = r_type.addu
instruction['subu'] = r_type.subu
instruction['and']  = r_type.and_f
instruction['or']   = r_type.or_f
instruction['xor']  = r_type.xor
instruction['nor']  = r_type.nor
instruction['slt']  = r_type.slt

instruction['addi'] = i_type.addi
instruction['slti'] = i_type.slti
instruction['andi'] = i_type.andi
instruction['ori']  = i_type.ori
instruction['xori'] = i_type.xori
instruction['lui']  = i_type.lui

instruction['lb']   = i_type.lb
instruction['lh']   = i_type.lh
instruction['lw']   = i_type.lw
instruction['lbu']  = i_type.lbu
instruction['lhu']  = i_type.lhu
instruction['lwu']  = i_type.lwu
instruction['sb']   = i_type.sb
instruction['sh']   = i_type.sh
instruction['sw']   = i_type.sw

instruction['beq']  = i_type.beq
instruction['bne']  = i_type.bne

instruction['j']    = j_type.j
instruction['jal']  = j_type.jal
instruction['jr']   = j_type.jr
instruction['jalr'] = j_type.jalr













