//Written by Shlomi Birs - 204179261
//Nachum Shtauber -311604854


class VmParser {
	
	Map memorySegments:=[Str:Str]["local":"LCL", "argument":"ARG","this":"THIS","that":"THAT","pointer":"3","temp":"5"];
	Int m_compare;
	Int m_returnNum;
	
	new make(){
		
		m_compare=1;
		m_returnNum = 1;
	}
	
	Void bootStrap(Str outputFile){
		if(!outputFile.endsWith(".asm"))
				outputfile := outputFile +".asm";
		File outFile :=outputFile.toUri.toFile;
		command :="";
		command += "@256\n"
		command += "D=A\n"
		command += "@SP\n"
		command += "M=D\n"
		command += call("Sys.init","0");
		outFile.out(true).printLine(command).close()
	}
	
	
	 Void parseFile(Str fileName,Str outputFile){
		
		if(fileName.endsWith(".vm")){
			inFile := fileName.toUri.toFile;
			if(!outputFile.endsWith(".asm"))
				outputfile := outputFile +".asm";
			File outFile :=outputFile.toUri.toFile;
			if(!memorySegments.containsKey("static"))
				memorySegments.add("static", outFile.basename());
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
				hackCommand +="M=M+D\n"
			
			case "sub": 				//SUB
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="M=M-D\n"
			
			case "neg": 				//NEG
				hackCommand +="@SP\n"
				hackCommand +="A=M-1\n"	
				hackCommand +="M=-M\n"	
			
			case "eq":   				//EQ
				hackCommand += "@SP\n"
				hackCommand += "AM=M-1\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@EQ"+ m_compare.toStr()+"\n"
				hackCommand += "D;JEQ\n"
				hackCommand += "D=0\n"
				hackCommand += "@doneEQ"+m_compare.toStr()+"\n"
				hackCommand += "0;JMP\n"
				hackCommand += "(EQ"+m_compare.toStr()+")\n"
				hackCommand += "D=-1\n"
				hackCommand += "(doneEQ"+m_compare.toStr()+")\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M-1\n"
				hackCommand += "M=D\n"
				m_compare++
			
			case "gt":  					//GT
				hackCommand += "@SP\n"
				hackCommand += "AM=M-1\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@GT"+ m_compare.toStr()+"\n"
				hackCommand += "D;JGT\n"
				hackCommand += "D=0\n"
				hackCommand += "@doneGT"+m_compare.toStr()+"\n"
				hackCommand += "0;JMP\n"
				hackCommand += "(GT"+m_compare.toStr()+")\n"
				hackCommand += "D=-1\n"
				hackCommand += "(doneGT"+m_compare.toStr()+")\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M-1\n"
				hackCommand += "M=D\n"
				m_compare++
			
			case "lt":  					//LT
				hackCommand += "@SP\n"
				hackCommand += "AM=M-1\n"
				hackCommand += "D=M\n"
				hackCommand += "A=A-1\n"
				hackCommand += "D=M-D\n"
				hackCommand += "@LT"+ m_compare.toStr()+"\n"
				hackCommand += "D;JLT\n"
				hackCommand += "D=0\n"
				hackCommand += "@doneLT"+m_compare.toStr()+"\n"
				hackCommand += "0;JMP\n"
				hackCommand += "(LT"+m_compare.toStr()+")\n"
				hackCommand += "D=-1\n"
				hackCommand += "(doneLT"+m_compare.toStr()+")\n"
				hackCommand += "@SP\n"
				hackCommand += "A=M-1\n"
				hackCommand += "M=D\n"
				m_compare++
			
			case "and": 					//AND
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="M=M&D\n"
				
			case "or":   						//OR
				hackCommand +="@SP\n"	
				hackCommand +="M=M-1\n"	
				hackCommand +="A=M\n"	
				hackCommand +="D=M\n"	
				hackCommand +="A=A-1\n"	
				hackCommand +="M=M|D\n"
			case "not": 						//Not
				hackCommand +="@SP\n"
				hackCommand +="A=M-1\n"
				hackCommand +="M=!M\n"
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
				hackCommand += "D=M\n"
			}
			
			else if(words[1]=="pointer" || words[1]=="temp" ){//syntax: push pointer/temp i
				mem :=memorySegments[words[1]]
				hackCommand +="@"+mem+"\n"
				hackCommand +="D=A\n"
				hackCommand +="@"+words[2]+"\n"
				hackCommand +="A=D+A\n"
				hackCommand +="D=M\n"
			}
			else{
					//syntax: push segment i
					
					mem :=memorySegments[words[1]]
					// D = M[*segment + i]
					hackCommand += "@"+ mem +"\n"
					hackCommand += "D=M\n"
					hackCommand += "@"+ words[2] +"\n"
					hackCommand += "A=D+A\n"
					hackCommand += "D=M\n"
			}
			
					//*SP = D   Deals with stack 
					hackCommand += "@SP\n" //A=0 
					hackCommand += "M=M+1\n" 
					hackCommand += "A=M-1\n" 
					hackCommand += "M=D\n"
								
			case "pop": 								//POP
				if(words[1]=="static"){//syntax: pop static i
				mem :=memorySegments[words[1]]
				hackCommand +="@"+mem+"."+ words[2] +"\n"
				hackCommand += "D=A\n"
			}
			
			else if(words[1]=="pointer" || words[1]=="temp" ){//syntax: pop pointer/temp i
				mem :=memorySegments[words[1]]
				hackCommand +="@"+mem+"\n"
				hackCommand +="D=A\n"
				hackCommand +="@"+words[2]+"\n"
				hackCommand +="D=D+A\n"
			}
			else{
					//syntax: pop segment i
					
					mem :=memorySegments[words[1]]
					// D = M[*segment + i]
					hackCommand += "@"+ mem +"\n"
					hackCommand += "D=M\n"
					hackCommand += "@"+ words[2] +"\n"
					hackCommand += "D=D+A\n"
			}
					// Deals with stack	
			
					hackCommand +="@SP\n"
					hackCommand +="M=M-1\n"//SP--
					hackCommand +="A=M+1\n"
					hackCommand +="M=D\n"//put dest addr in sp+1
					hackCommand +="A=A-1\n"
					hackCommand +="D=M\n"	//get value at sp in to D
					hackCommand +="A=A+1\n"
					hackCommand +="A=M\n" //get addr dest into A
					hackCommand +="M=D\n" //put D into Dest
			
			
			case "function":
					funcName:= words[1];
			 		varNum := words[2];
			 		hackCommand = translateFunction(funcName,varNum)
			
			case "call":
					funcName:= words[1];
			 		args := words[2];
			 		hackCommand = call(funcName,args);
			
			case "goto":
					labelName := words[1];
					hackCommand += "@"+labelName+"\n";
					hackCommand += "0;JMP\n"
			
			case "label":
					labelName := words[1];
					hackCommand += "("+ labelName +")\n";
			
			case "if-goto":
				labelName := words[1];
				hackCommand += "@SP\n"
				hackCommand += "M=M-1\n" //sp-- 
				hackCommand += "@SP\n"
				hackCommand += "A=M\n"
				hackCommand += "D=M\n" //store element in D
				hackCommand += "@"+labelName+"\n"
				hackCommand += "D;JNE\n" //jump if not eq 0
			
			case "return":
					hackCommand=returnTranslate()
			
			default: 
				echo("Command unknown");
		
		}
		//write to .asm file
		outFile.out(true).printLine(hackCommand).close()
		
	}
	
	Str call(Str funcName, Str args){
		result := ""
		returnLabel := "returnLabel"+ m_returnNum.toStr()
		m_returnNum++
		result += "@" + returnLabel+"\n"
		result += "D=A\n" //D= return address 
		result += "@SP\n"
		result += "A=M\n" 
		result += "M=D\n" //save ret address  in stack
		result += "@SP\n"
		result += "M=M+1\n" //sp++
		
		result += saveCallerState()  //save the caller functions enviorment state
		
		result +="@SP\n" //set ARG to point to the first argument
		result +="D=M\n"
		result +="@5\n"
		result +="D=D-A\n"
		result +="@"+ args +"\n"
		result +="D=D-A\n"
		result +="@ARG\n"
		result +="M=D\n"
		
		
		result +="@SP\n" //point LCL to top of the stack
		result +="D=M\n"
		result +="@LCL\n"
		result +="M=D\n"
		
		result += "@"+funcName+"\n";
		result += "0;JMP\n"
		result += "(" + returnLabel + ")\n"
		
		
		return result;
	}
	
	Str saveCallerState(){
		segments := Str["LCL","ARG","THIS","THAT"]
		result := ""
		segments.each |Str seg| { 
			result+="@"+ seg +"\n"
			result+="D=M\n" //D= seg address
			result+="@SP\n"
			result+="A=M\n"
			result+="M=D\n" // push address into stack
			result+="@SP\n"
			result+="M=M+1\n"	//sp++
		}
		return result;
	}
	
	Str translateFunction(Str funcName,Str varNum){
		result := ""
		result+="("+ funcName +")\n"
		result+="@SP\n" 
		result+="D=M\n"
		result+="@LCL\n"
		result+="M=D\n" 
		for (i := 0; i < varNum.toInt(); i++ ){
			result += "@0\n"
			result += "D=A\n"
			result += "@SP\n" //A=0 
			result += "M=M+1\n" 
			result += "A=M-1\n" 
			result += "M=D\n"
	}
		return result
		
	}
	
	Str returnTranslate(){
		hackCommand :=""
		hackCommand += "@LCL\n"
		hackCommand += "D=M\n"
		hackCommand += "@R13\n"
		hackCommand += "M=D\n"

		hackCommand += "@5\n"
		hackCommand += "D=D-A\n"
		hackCommand += "A=D\n"
		hackCommand += "D=M\n"
		hackCommand += "@R14\n"
		hackCommand += "M=D\n"

		hackCommand += "@SP\n"
		hackCommand += "M=M-1\n"
		hackCommand += "A=M\n"
		hackCommand += "D=M\n"
		hackCommand += "@ARG\n"
		hackCommand += "A=M\n"
		hackCommand += "M=D\n"

		hackCommand += "@ARG\n"
		hackCommand += "D=M\n"
		hackCommand += "D=D+1\n"
		hackCommand += "@SP\n"
		hackCommand += "M=D\n"

		hackCommand += "@R13\n"
		hackCommand += "D=M\n"
		hackCommand += "@1\n"
		hackCommand += "A=D-A\n"
		hackCommand += "D=M\n"
		hackCommand += "@THAT\n"
		hackCommand += "M=D\n"

		hackCommand += "@R13\n"
		hackCommand += "D=M\n"
		hackCommand += "@2\n"
		hackCommand += "A=D-A\n"
		hackCommand += "D=M\n"
		hackCommand += "@THIS\n"
		hackCommand += "M=D\n"

		hackCommand += "@R13\n"
		hackCommand += "D=M\n"
		hackCommand += "@3\n"
		hackCommand += "A=D-A\n"
		hackCommand += "D=M\n"
		hackCommand += "@ARG\n"
		hackCommand += "M=D\n"

		hackCommand += "@R13\n"
		hackCommand += "D=M\n"
		hackCommand += "@4\n"
		hackCommand += "A=D-A\n"
		hackCommand += "D=M\n"
		hackCommand += "@LCL\n"
		hackCommand += "M=D\n"

		hackCommand += "@R14\n"
		hackCommand += "A=M\n"
		hackCommand += "0;JMP\n"
		return hackCommand
	}
}
