//Written by Shlomi Birs - 204179261
//Nachum Shtauber -311604854


class test {
	static Void main(Str[] args)
	{
		VmParser parse := VmParser.make();
		parse.bootStrap("StaticsTest.asm")
		parse.parseFile("file:./Sys.vm","StaticsTest.asm")
		//parse.parseFile("file:./main.vm","FibonacciElement.asm")
		parse.parseFile("file:./Class1.vm","StaticsTest.asm")
		parse.parseFile("file:./Class2.vm","StaticsTest.asm")
		
		echo("parsing finished")
	}
}
