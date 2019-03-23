@17
D=A
@SP
M=M+1
A=M-1
M=D

@17
D=A
@SP
M=M+1
A=M-1
M=D

@SP
AM=M-1
D=M
A=A-1
D=M-D
@EQ1
D;JEQ
D=0
@doneEQ1
0;JMP
(EQ1)
D=-1
(doneEQ1)
@SP
A=M-1
M=D

@892
D=A
@SP
M=M+1
A=M-1
M=D

@891
D=A
@SP
M=M+1
A=M-1
M=D

@SP
AM=M-1
D=M
A=A-1
D=M-D
@LT2
D;JLT
D=0
@doneLT2
0;JMP
(LT2)
D=-1
(doneLT2)
@SP
A=M-1
M=D

@32767
D=A
@SP
M=M+1
A=M-1
M=D

@32766
D=A
@SP
M=M+1
A=M-1
M=D

@SP
AM=M-1
D=M
A=A-1
D=M-D
@GT3
D;JGT
D=0
@doneGT3
0;JMP
(GT3)
D=-1
(doneGT3)
@SP
A=M-1
M=D

@56
D=A
@SP
M=M+1
A=M-1
M=D

@31
D=A
@SP
M=M+1
A=M-1
M=D

@53
D=A
@SP
M=M+1
A=M-1
M=D

@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

@112
D=A
@SP
M=M+1
A=M-1
M=D

@SP
M=M-1
A=M
D=M
A=A-1
M=M-D

@SP
A=M-1
M=-M

@SP
M=M-1
A=M
D=M
A=A-1
M=M&D

@82
D=A
@SP
M=M+1
A=M-1
M=D

@SP
M=M-1
A=M
D=M
A=A-1
M=M|D

