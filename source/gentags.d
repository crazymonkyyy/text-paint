import std;
enum colors="002b36,073642,586e75,657b83,839496,93a1a1,eee8d5,fdf6e3,dc322f,cb4b16,b58900,859900,2aa198,268bd2,6c71c4,d33682";
void main(){
	foreach(s;colors.splitter(",")){
		"<span style=\"color:#".write;
		s.write;
		"\">".writeln;
		"</span>".writeln;
	}
	foreach(s;colors.splitter(",")){
		"<span style=\"background-color:#".write;
		s.write;
		"\">".writeln;
		"</span>".writeln;
	}
}