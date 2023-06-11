import raylib;
import std;
enum textsize=24;

string[] text;
string[] tags;
ubyte[][] color;
ubyte[][] background;
Color[] colors = [
    Color(0x00, 0x2B, 0x36, 0xFF),
    Color(0x07, 0x36, 0x42, 0xFF),
    Color(0x58, 0x6E, 0x75, 0xFF),
    Color(0x65, 0x7B, 0x83, 0xFF),
    Color(0x83, 0x94, 0x96, 0xFF),
    Color(0x93, 0xA1, 0xA1, 0xFF),
    Color(0xEE, 0xE8, 0xD5, 0xFF),
    Color(0xFD, 0xF6, 0xE3, 0xFF),
    Color(0xDC, 0x32, 0x2F, 0xFF),
    Color(0xCB, 0x4B, 0x16, 0xFF),
    Color(0xB5, 0x89, 0x00, 0xFF),
    Color(0x85, 0x99, 0x00, 0xFF),
    Color(0x2A, 0xA1, 0x98, 0xFF),
    Color(0x26, 0x8B, 0xD2, 0xFF),
    Color(0x6C, 0x71, 0xC4, 0xFF),
    Color(0xD3, 0x36, 0x82, 0xFF)
  ];
int radial(Vector2 i,Vector2 o){
	import std;
	return ((atan2(o.y-i.y,o.x-i.x)+3.14)/(6.28/16)).to!int%16;
}
void main(string[] input){
	if(input.length<2){
		"requires two arguments a txt file and a tag file".writeln;
		"for best results make the txt file ascii".writeln;
		"tag file, should be endline seperated a have markup tags, see solarizedhtml for an example".writeln;
		return;
	}
	SetTraceLogLevel(int.max);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
	//GetMonitorWidth(GetCurrentMonitor).writeln;
	InitWindow(0,0, "shitty text editor");
	SetWindowSize(GetMonitorWidth(GetCurrentMonitor)*3/4, 
			GetMonitorHeight(GetCurrentMonitor)*3/4);
	SetWindowPosition(GetMonitorWidth(GetCurrentMonitor)/8,
			GetMonitorHeight(GetCurrentMonitor)/8);
	Font mono=LoadFont("notomono.ttf");
	auto radialtool=LoadTexture("radial.png");
	int width=MeasureTextEx(mono,"a",textsize,10).x.to!int;
	//--- reasonable tool gui initualization
	text=File(input[1]).byLineCopy.array;
	tags=File(input[2]).byLineCopy.array;
	assert(tags.length==64 ||tags.length==65,"tags file malformed, should be 64 lines long");
	ubyte color1=8;
	ubyte color2=1;
	SetTargetFPS(60);
	while (!WindowShouldClose()){
		int c_width=GetRenderWidth/width;
		int c_height=GetRenderHeight/textsize;
		//c_width.writeln;
		//c_height.writeln;
		while(color.length<c_height){
			color~=[7];
			background~=[0];
		}
		foreach(i;0..c_height){
			while(color[i].length<c_width){
				color[i]~=7;
				background[i]~=0;
		}}
		//--- maintain/init that my data is large enough
		BeginDrawing();
			ClearBackground(Colors.BLACK);
			foreach(y;0..c_height){
			foreach(x;0..c_width){
				char c=' ';
				if(text.length>y&& text[y].length>x){
					c=text[y][x];
				}
				DrawRectangle(x*width,y*textsize,width,textsize,colors[background[y][x]]);
				DrawTextCodepoint(mono,c,Vector2(x*width,y*textsize),textsize,colors[color[y][x]]);
			}}
			import monkyyykeys;
			with(button){
				if(shift){
					if(mouse1){
						foreach(ref e;color[GetMouseY/textsize]){
							e=color1;
						}
					}
					if(mouse2){
						foreach(ref e;background[GetMouseY/textsize]){
							e=color2;
						}
					}
					if(mouse4){
						color1=color[GetMouseY/textsize][GetMouseX/width];
						color2=background[GetMouseY/textsize][GetMouseX/width];
					}
				} else {
					if(mouse1){
						color[GetMouseY/textsize][GetMouseX/width]=color1;
					}
					if(mouse2){
						background[GetMouseY/textsize][GetMouseX/width]=color2;
					}
					static Vector2 toolcenter;
					if(mouse3.pressed){
						toolcenter=GetMousePosition;
					}
					if(mouse3.released){
						color1=cast(ubyte)radial(GetMousePosition,toolcenter);
					}
					if(mouse4.pressed){
						static int i;
						"swaped".writeln(i++);
						ubyte t=color1;
						color1=color2;
						color2=t;
					}
					if(mouse3){
						DrawTextureV(radialtool,toolcenter-Vector2(75,75),Colors.WHITE);
						DrawCircle(GetMouseX,GetMouseY,16,colors[radial(GetMousePosition,toolcenter)]);
					} else {
						DrawCircle(GetMouseX,GetMouseY,7,colors[color2]);
						DrawCircle(GetMouseX,GetMouseY,5,colors[color1]);
					}
				}
			}
		EndDrawing();
	}
	CloseWindow();
	ubyte lastcolor=color[0][0];
	ubyte lastback=background[0][0];
	void tag(ubyte c,bool foreground,bool closing){
		tags[c*2+(!foreground)*32+closing].write;
	}
	tag(lastback,0,0);
	tag(lastcolor,1,0);
	foreach(s;text){
	foreach(c;s){
		if(color.length>0&&color[0].length>0){
			if(background[0][0]!=lastback){
				tag(lastcolor,1,1);
				tag(lastback,0,1);
				lastcolor=color[0][0];
				lastback=background[0][0];
				tag(lastback,0,0);
				tag(lastcolor,1,0);
			} else if(color[0][0]!=lastcolor){
				tag(lastcolor,1,1);
				lastcolor=color[0][0];
				tag(lastcolor,1,0);
			}
			color[0]=color[0][1..$];
			background[0]=background[0][1..$];
		}
		c.write;
	}
		color=color[1..$];
		background=background[1..$];
		writeln;
	}
}

			//DrawTextCodepoint(mono,'a',Vector2(0,0),textsize,Colors.WHITE);
			//DrawTextCodepoint(mono,'b',Vector2(width,0),textsize,Colors.WHITE);
			//DrawTextCodepoint(mono,'c',Vector2(width*2,0),textsize,Colors.WHITE);
			//DrawTextCodepoint(mono,'d',Vector2(0,textsize),textsize,Colors.WHITE);