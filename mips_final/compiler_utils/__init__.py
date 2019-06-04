from .compiler_funcs import r_type
from .compiler_funcs import i_type
from .compiler_funcs import j_type


instruction = {'nop':(lambda args, labels, n_line: '0'*32)};

instruction['sll']  = lambda args, labels, n_line: r_type.sll(args)
instruction['srl']  = lambda args, labels, n_line: r_type.srl(args)
instruction['sra']  = lambda args, labels, n_line: r_type.sra(args)
instruction['sllv'] = lambda args, labels, n_line: r_type.sllv(args)
instruction['srlv'] = lambda args, labels, n_line: r_type.srlv(args)
instruction['srav'] = lambda args, labels, n_line: r_type.srav(args)
instruction['addu'] = lambda args, labels, n_line: r_type.addu(args)
instruction['subu'] = lambda args, labels, n_line: r_type.subu(args)
instruction['and']  = lambda args, labels, n_line: r_type.and_f(args)
instruction['or']   = lambda args, labels, n_line: r_type.or_f(args)
instruction['xor']  = lambda args, labels, n_line: r_type.xor(args)
instruction['nor']  = lambda args, labels, n_line: r_type.nor(args)
instruction['slt']  = lambda args, labels, n_line: r_type.slt(args)

instruction['addi'] = lambda args, labels, n_line: i_type.addi(args)
instruction['slti'] = lambda args, labels, n_line: i_type.slti(args)
instruction['andi'] = lambda args, labels, n_line: i_type.andi(args)
instruction['ori']  = lambda args, labels, n_line: i_type.ori(args)
instruction['xori'] = lambda args, labels, n_line: i_type.xori(args)
instruction['lui']  = lambda args, labels, n_line: i_type.lui(args)

instruction['lb']   = lambda args, labels, n_line: i_type.lb(args)
instruction['lh']   = lambda args, labels, n_line: i_type.lh(args)
instruction['lw']   = lambda args, labels, n_line: i_type.lw(args)
instruction['lbu']  = lambda args, labels, n_line: i_type.lbu(args)
instruction['lhu']  = lambda args, labels, n_line: i_type.lhu(args)
instruction['lwu']  = lambda args, labels, n_line: i_type.lwu(args)
instruction['sb']   = lambda args, labels, n_line: i_type.sb(args)
instruction['sh']   = lambda args, labels, n_line: i_type.sh(args)
instruction['sw']   = lambda args, labels, n_line: i_type.sw(args)

instruction['beq']  = lambda args, labels, n_line: i_type.beq(args)
instruction['bne']  = lambda args, labels, n_line: i_type.bne(args)

instruction['j']    = lambda args, labels, n_line: j_type.j(args,labels)
instruction['jal']  = lambda args, labels, n_line: j_type.jal(args,labels)
instruction['jr']   = lambda args, labels, n_line: j_type.jr(args)
instruction['jalr'] = lambda args, labels, n_line: j_type.jalr(args)

instruction['halt'] = lambda args, labels, n_line: j_type.halt(args)














