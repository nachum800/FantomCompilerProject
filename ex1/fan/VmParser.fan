
class VmParser {
	
	Map memorySegments:=[Str:Str]["local":"LCL", "argument":"ARG","this":"THIS","that":"THAT","pointer":"3","temp":"5"];
	Int m_compare;
	
	new make(){
		
		m_compare=1;
	}
	
	
	 Void parseFile(Str fileName,Str outputFile){
		
		if(fileName.endsWith(".vm")){
			inFile := fileName.toUri.toFile;
			if(!outputFile.endsWith(".asm"))
				outputfile := outputFile +".asm";
			File outFile :=outputFile.toUri.toFile;
			memorySegments.add("static", fileName);
			inFile.eachLine |line| { 
						if(line.startsWith("//")  ||  line.isEmpty()) {
							
						}  //Deals with comments	
						else {
							Str command:=""
							if(line.contains("//")){
								index :=line.index("//")
								line = line.split('/',true)[0];
								}
							line.trim();
							convertLineFromVmtoHack(line,outFile);
						
							}
					} 
					
			
		}	
		else{
			echo("Parser can only parse vM files...")
		}
		
	}
	
	Void convertLineFromVmtoHack(Str command,File outFile){
		Str[] words:=command.split();
		Str hackCommand := ""
		switch(words[0]){
			case "add":   					//ADD			
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="D=D+M\n"
				hackCommand +="M=D\n"		
				hackCommand +="D=A+1\n"	
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			
			case "sub": 				//SUB
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="D=M-D\n"
				hackCommand +="M=D\n"		
				hackCommand +="D=A+1\n"	
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			
			case "neg": 				//NEG
				hackCommand +="@SP\n"
				hackCommand +="M=M-1\n"
				hackCommand +="A=M\n"
				hackCommand +="M=-M\n"
				hackCommand +="D=A+1\n"
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			
			case "eq":   				//EQ
				hackCommand += "@SP\n"
				hackCommand += "M=M-1\n"
				hackCommand += "A=M\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@EQ"+ m_compare.toStr()+"\n"
				hackCommand += "D;JEQ\n"
				hackCommand += "@0\n"
				hackCommand += "D=-A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "@doneEQ"+m_compare.toStr()+"\n" 
				hackCommand += "0;JMP\n"
				hackCommand += "(EQ"+m_compare.toStr()+")\n"
				hackCommand += "@1\n"
				hackCommand += "D=A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "(doneEQ"+m_compare.toStr()+")\n"
				m_compare++
			
			case "gt":  					//GT
				hackCommand += "@SP\n"
				hackCommand += "M=M-1\n"
				hackCommand += "A=M\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@EQ"+m_compare.toStr()+"\n"
				hackCommand += "D;JGT\n"
				hackCommand += "@0\n"
				hackCommand += "D=-A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "@doneEQ"+m_compare.toStr()+"\n" 
				hackCommand += "0;JMP\n"
				hackCommand += "(EQ"+m_compare.toStr()+")\n"
				hackCommand += "@1\n"
				hackCommand += "D=A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "(doneEQ"+m_compare.toStr()+")\n"
				m_compare++
			
			case "lt":  					//LT
				hackCommand += "@SP\n"
				hackCommand += "M=M-1\n"
				hackCommand += "A=M\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@EQ"+m_compare.toStr()+"\n"
				hackCommand += "D;JLT\n"
				hackCommand += "@0\n"
				hackCommand += "D=-A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "@doneEQ"+m_compare.toStr()+"\n" 
				hackCommand += "0;JMP\n"
				hackCommand += "(EQ"+m_compare.toStr()+")\n"
				hackCommand += "@1\n"
				hackCommand += "D=A\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "M=D\n"
				hackCommand += "@SP\n"
				hackCommand += "M=M+1\n"
				hackCommand += "(doneEQ"+m_compare.toStr()+")\n"
				m_compare++
			
			case "and": 					//AND
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="D=D&M\n"
				hackCommand +="M=D\n"		
				hackCommand +="D=A+1\n"	
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			case "or":   						//OR
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="D=D|M\n"
				hackCommand +="M=D\n"		
				hackCommand +="D=A+1\n"	
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			case "not": 						//Not
				hackCommand +="@SP\n"
				hackCommand +="M=M-1\n"
				hackCommand +="A=M\n"
				hackCommand +="M=!M\n"
				hackCommand +="D=A+1\n"
				hackCommand +="@SP\n"
				hackCommand +="M=D\n"
			case "push":						//PUSH
				if(words[1]=="constant"){
					//syntax: push constant i
					
					// D = i
					hackCommand += "@" + words[2] + "\n"
					hackCommand += "D=A\n"					
				}
			
			else if(words[1]=="static"){//syntax: push static i
				mem :=memorySegments[words[1]]
				hackCommand	+="@"+mem+"."+ words[2] +"\n"
				hackCommand += "D=M/n"
			}
			
			else if(words[1]=="pointer" || words[1]=="temp" ){//syntax: push pointer/temp i
				mem :=memorySegments[words[1]]
				hackCommand +="@"+mem+"\n"
				hackCommand +="D=A\n"
				hackCommand +="@"+words[2]+"\n"
				hackCommand +="D=D+A\n"
			}
			else{
					//syntax: push segment i
					
					mem :=memorySegments[words[1]]
					// D = M[*segment + i]
					hackCommand += "@"+ mem +"\n"
					hackCommand += "D=A\n"
					hackCommand += "@"+ words[2] +"\n"
					hackCommand += "D=D+M\n"
			}
			
					//*SP = D   Deals with stack
					hackCommand += "@SP\n" //A=0 
					hackCommand += "A=M\n" // A is equal to the address in memory indicated by the stack pointer
					hackCommand += "M=D\n" // The value indicated by the stack pointer is equal to D
					//SP++
					hackCommand += "D=A+1\n"
					hackCommand += "@SP\n"
					hackCommand += "M=D\n"
								
			case "pop": 								//POP
				if(words[1]=="static"){//syntax: push static i
				mem :=memorySegments[words[1]]
				hackCommand+="@"+mem+"."+ words[2] +"\n"
				hackCommand += "D=M/n"
			}
			
			else if(words[1]=="pointer" || words[1]=="temp" ){//syntax: push pointer/temp i
				mem :=memorySegments[words[1]]
				hackCommand +="@"+mem+"\n"
				hackCommand +="D=A\n"
				hackCommand +="@"+words[2]+"\n"
				hackCommand +="D=D+A\n"
			}
			else{
					//syntax: push segment i
					
					mem :=memorySegments[words[1]]
					// D = M[*segment + i]
					hackCommand += "@"+ mem +"\n"
					hackCommand += "D=A\n"
					hackCommand += "@"+ words[2] +"\n"
					hackCommand += "D=D+M\n"
			}
					// Deals with stack
			//R13=D
					hackCommand +="@R13\n" //temporary reg to hold data
					hackCommand +="M=D\n"
			//SP--
					hackCommand +="@SP\n"
					hackCommand +="A=M-1\n"
					hackCommand +="D=M\n"
					hackCommand +="@R13\n"
					hackCommand +="A=M\n"
					hackCommand +="M=D\n"		
			default: 
				echo("Command unknown");
		
		}
		//write to .asm file
		outFile.out(true).printLine(hackCommand).close()
		
	}
}
