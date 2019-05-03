///////////////////////////////////////////
// NB_BITES
///////////////////////////////////////////
`define NB_BITS            32

///////////////////////////////////////////
// FETCH
///////////////////////////////////////////
`define RAM_FETCH_DEPTH    10

///////////////////////////////////////////
// DECODE
///////////////////////////////////////////
`define NB_JUMP            28
`define NOP_OPERATION      0
`define NB_FUN             6
`define NB_REG             5
// CONTROL
`define NB_CTR_EXEC        9
`define NB_CTR_MEM         4
`define NB_CTR_WB          3
// SIGN EXTEND
`define JMP_EXT            2'd0
`define SGN_EXT            2'd1
`define ZRO_EXT            2'd2
`define SPC_EXT            2'd3
///////////////////////////////////////////
////  OPS CODES  
///////////////////////////////////////////
`define OP_INSTR_J         6'b000010 // jump
`define OP_INSTR_JAL       6'b000011 // jump and link
`define OP_INSTR_BEQ       6'b000100
`define OP_INSTR_BEN       6'b000101
`define OP_INSTR_ADDI      6'b001000 // add inmediate word
`define OP_INSTR_SLTI      6'b001010 // set on less than
`define OP_INSTR_ANDI      6'b001100
`define OP_INSTR_ORI       6'b001101
`define OP_INSTR_XORI      6'b001110
`define OP_INSTR_LUI       6'b001111

`define OP_INSTR_LB        6'b100000
`define OP_INSTR_LH        6'b100001
`define OP_INSTR_LW        6'b100011
`define OP_INSTR_LBU       6'b100100
`define OP_INSTR_LHU       6'b100101
`define OP_INSTR_LWU       6'b100111
`define OP_INSTR_SB        6'b101000
`define OP_INSTR_SH        6'b101001
`define OP_INSTR_SW        6'b101011
`define OP_INSTR_SPECIAL   6'd0
`define OP_INSTR_HALT      6'b101111
///////////////////////////////////////////
/////  SPECIAL FUNC  
///////////////////////////////////////////

`define FUNC_SLL           6'b000000
`define FUNC_SRL           6'b000010
`define FUNC_SRA           6'b000011
`define FUNC_SLLV          6'b000100
`define FUNC_SRLV          6'b000110
`define FUNC_SRAV          6'b000111
`define FUNC_JR            6'b001000
`define FUNC_JALR          6'b001001
`define FUNC_ADDU          6'b100001
`define FUNC_SUBU          6'b100011
`define FUNC_AND           6'b100100
`define FUNC_OR            6'b100101
`define FUNC_XOR           6'b100110
`define FUNC_NOR           6'b100111
`define FUNC_SLT           6'b101010
///////////////////////////////////////////
// EXECUTION
///////////////////////////////////////////

/// MUX DEST
`define DEST_FROM_RD       2'b0
`define DEST_FROM_RT       2'b1
`define DEST_TO_RETURN     2'b10
// MUX R1
`define PC_TO_A            2'b00
`define RS_TO_A            2'b01
`define SEXT_TO_A          2'b10
//MUX R2 ALU
`define RT_TO_B            1'b0
`define SEXT_TO_B          1'b1
//MUX R1 ALU
`define RT_TO_B            1'b0
`define SEXT_TO_B          1'b1

// FORWARDING UNIT DEFINITIONS
 `define FROM_ID_EX        2'b00
 `define FROM_EX_MEM       2'b01
 `define FROM_MEM_WB       2'b10
///////////////////////////////////////////
///// ALU
///////////////////////////////////////////

`define OP_ALU_ADD         4'b0000//
`define OP_ALU_FUNC        4'b0010//
`define OP_ALU_SUB         4'b0001//
`define OP_ALU_ANDI        4'b0100//
`define OP_ALU_ORI         4'b0101//
`define OP_ALU_XORI        4'b0110//
`define OP_ALU_LUI         4'b0111//
`define OP_ALU_NONE        4'b1000//
`define OP_ALU_SLTI        4'b0011//
`define OP_ALU_JAL         4'b1001//

///////////////////////////////////////////
// MEM
///////////////////////////////////////////

`define READ_DISABLE       2'b00
`define READ_BYTE          2'b01
`define READ_HALFWORD      2'b10
`define READ_WORD          2'b11

`define WRITE_DISABLE      2'b00
`define WRITE_BYTE         2'b01
`define WRITE_HALFWORD     2'b10
`define WRITE_WORD         2'b11

`define HALFWORD           16
`define BYTE               8
`define WORD               32
///////////////////////////////////////////
// WRITE BACk
///////////////////////////////////////////
`define DATA_FROM_MEM      2'b00
`define DATA_FROM_ALU      2'b01
`define DATA_SIGN_BYT      2'b10
`define DATA_SIGN_HAL      2'b11

