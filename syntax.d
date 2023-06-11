import std;
struct button_{
	int j;
	bool opCast(T:bool)(){
		"casted".writeln;
		return up;
	}
	bool down(){
		assert(j==0,"called down on something not shift "~j.to!string);
		return true;
	}
	bool up(){
		assert(0,"I thought I was calling down");
	}
}
enum button{
	shift=button_(0),down=button_(1)
}
unittest{
	if(button.shift.down){
		"shift was pressed".writeln;
	}
}
enum abc{a,b,c}
unittest{
	abc foo;
	foo=foo.a.b.c.c.b.a;//?????????
}