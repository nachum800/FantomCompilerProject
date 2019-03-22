
class test {
	static Void main(Str[] args)
	{
		VmParser parse := VmParser.make();
		parse.parseFile("file:./PointerTest.vm","PointerTest.asm")
		echo("parsing finished")
	}
}
