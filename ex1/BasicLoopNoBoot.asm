@0
D=A
@SP
M=M+1
A=M-1
M=D

@LCL
D=M
@0
D=D+A
@SP
M=M-1
A=M+1
M=D
A=A-1
D=M
A=A+1
A=M
M=D

(LOOP_START)

@ARG
D=M
@0
A=D+A
D=M
@SP
M=M+1
A=M-1
M=D

@LCL
D=M
@0
A=D+A
D=M
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

@LCL
D=M
@0
D=D+A
@SP
M=M-1
A=M+1
M=D
A=A-1
D=M
A=A+1
A=M
M=D

@ARG
D=M
@0
A=D+A
D=M
@SP
M=M+1
A=M-1
M=D

@1
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

@ARG
D=M
@0
D=D+A
@SP
M=M-1
A=M+1
M=D
A=A-1
D=M
A=A+1
A=M
M=D

@ARG
D=M
@0
A=D+A
D=M
@SP
M=M+1
A=M-1
M=D

@SP
M=M-1
@SP
A=M
D=M
@LOOP_START
D;JNE

@LCL
D=M
@0
A=D+A
D=M
@SP
M=M+1
A=M-1
M=D

