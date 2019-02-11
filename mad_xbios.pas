unit mad_xbios;
(*
*
*
*
*
*)
interface

const
{$i 'mad_xbios.inc'}

procedure xbios_opencurrentdir;assembler;
procedure xbios_openfile(fname: TString);assembler;
procedure xbios_closefile;assembler;
procedure xbios_loadfile(filename: TString);assembler;
procedure xbios_write(src: Pointer);assembler;
procedure xbios_read(dst: Pointer);assembler;

implementation

procedure xbios_opencurrentdir;assembler;
  asm {
    jsr xBIOS_OPEN_CURRENT_DIR
  };
end;

procedure xbios_openfile(fname: TString);assembler;
  asm {
    ldy < fname
    ldx > fname
    jsr xBIOS_OPEN_FILE

    ;fname .byte c'MYFILE COM' ; 11 znakow ATASCII
  };
end;

procedure xbios_closefile;assembler;
  asm {
    jsr xBIOS_FLUSH_BUFFER
  };
end;

procedure xbios_loadfile(filename: TString);assembler;
  asm {


  ldy <fname
  ldx >fname
  jsr xBIOS_LOAD_FILE
  fname .byte c'STARV   XEX' ; 11 chars ATASCII

  };
end;

procedure xbios_write(src: Pointer);assembler;
  asm {
    ldy < src
    ldx > src
    jsr xBIOS_WRITE_DATA
  };
end;

procedure xbios_read(dst: Pointer);assembler;
  asm {
    ldy < dst
    ldx > dst
    JSR xBIOS_LOAD_DATA
  };
end;

end.
