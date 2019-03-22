
class VmParser {
	
	new make(){
		
		
	}
	
	 Void parseFile(Str fileName,Str outputFile){
		Str commentOut :="//"	;
		if(fileName.endsWith(".vm")){
			inFile := fileName.toUri.toFile;
			if(!outputFile.endsWith(".asm"))
				outputfile := outputFile +".asm";
			File outFile :=outputFile.toUri.toFile;
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
		switch(words[0]){
			case "add": 
				echo("add")
			case "sub": 
				echo("sub")
			case "neg": 
				echo("neg")
			case "eq": 
				echo("eq")
			case "gt":  
				echo("gt")
			case "lt":  
				echo("lt")
			case "and": 
				echo("and")
			case "or":  
				echo("or")
			case "not": 
				echo("not")
			case "push":
				if(words[1]=="constant"){
					
				}
				else{
					index := getMemoryStartingPoint(words[1])
					echo("push")
				}
			case "pop": 
				if(words[1]=="constant"){
					Str temp := "@"+words[2]+"\nD=A\n";
					outFile.out(true).printLine(temp).close
				}
				else{
					index := getMemoryStartingPoint(words[1])
					echo("pop")
				}
			
			default: 
				echo("Command unknown");
		
		}
		
	}
	
	Int getMemoryStartingPoint(Str mem){
		switch(mem){
			case "local": 
				echo("local")
			case "argument":
				echo("argument")
			case "this":
				echo("this")
			case "that": 
				echo("that")
			case "static": 
				echo("static")
			case "pointer":
				echo("pointer")
			default: 
				echo("Command unknown");
		}
			
		return 0;// TODO: implement
		
	}
	Void writeHackPush(File outFile){
		
		
	}
	
}
