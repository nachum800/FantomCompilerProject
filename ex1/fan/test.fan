
class test {
	static Void main(Str[] args)
	{
		VmParser parse := VmParser.make();
		parse.parseFile("file:./StackTest.vm","StackTest.asm")
		echo("parsing finished")
	}
}
