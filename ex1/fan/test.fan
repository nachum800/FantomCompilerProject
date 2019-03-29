//Written by Shlomi Birs - 204179261
//Nachum Shtauber -311604854


class test {
	static Void main(Str[] args)
	{
		VmParser parse := VmParser.make();
		parse.bootStrap("FibonacciElement.asm")
		parse.parseFile("file:./Main.vm","FibonacciElement.asm")
		parse.parseFile("file:./Sys.vm","FibonacciElement.asm")
		
		echo("parsing finished")
	}
}
