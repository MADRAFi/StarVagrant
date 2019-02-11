{$librarypath '../'}
uses crt, mad_xbios;

const
 stext = $8000;
 scrol = $9000;
 mtext = $9040;

 dl	:array [0..29] of byte =(
 $70,$70,$70,$70,$70,
 $f0,$56,lo(scrol),hi(scrol),
 $40,$42,lo(mtext), hi(mtext),
 $2,$2,$2,$2,$2,$2,$2,$2,$2,$2,
 $40,$56,lo(scrol),hi(scrol),
 $41,lo(word(@dl)), hi(word(@dl))
 );

var
 ptext	: ^byte;
 xb     : ^byte;

 x,z	: byte;
 count	: byte;
 wsync 	: byte absolute $D40A;
 dmactl : byte absolute $d400;
 nmien	: byte absolute $d40e;
 hscrol : byte absolute $D404;
 colpf0 : byte absolute $D016;
 colpf1 : byte absolute $D017;
 colpf2 : byte absolute $D018;
 colpf3 : byte absolute $D019;
 attract: byte absolute 77;
 old_dli, old_vbl: pointer;

{$r scroll.rc}

procedure dli; interrupt;
begin
 asm { phr };

 dmactl:=63;
 colpf0:=$da;
 colpf1:=$55;
 colpf2:=$e;
 colpf3:=$88;
 wsync:=1;
 attract:=0;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 colpf2:=$35;
 colpf1:=$e;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 dmactl:=62;

 for z:=0 to 95 do wsync:=1;

 dmactl:=63;
 colpf0:=$da;
 colpf1:=$55;
 colpf2:=$e;
 wsync:=1;
 colpf3:=$88;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 wsync:=1;
 colpf2:=$35;
 colpf1:=$e;
 wsync:=1;

 asm { plr };
end;			// MadPascal add RTI


begin
 clrscr;

 GetIntVec(iDLI, old_dli);

 ptext:= pointer(stext);

 dpoke(560,word(@dl));
 dpoke(88,mtext);



 SetIntVec(iDLI,@dli);
 nmien:=$c0;

 xb:= Pointer(XBIOS);
 gotoxy(4,1);
 write('xbios =',xb^);
 gotoxy(15,11);
 write('press any key');

 repeat

 pause;
// pause;

 if count=0 then begin

  count:=8;

  poke(scrol+23, ptext^);

  move(pointer(scrol+1), pointer(scrol), 23);

  inc(ptext);
  if ptext^=$ff then ptext:=pointer(stext);
 end;

 dec(count);
 hscrol:=count;

 until keypressed;

 SetIntVec(iDLI, old_dli);

 xbios_loadfile('starv   xex');


end.
