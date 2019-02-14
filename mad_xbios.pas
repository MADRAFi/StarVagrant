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
procedure xbios_openfile(var filename: TString);assembler;
procedure xbios_closefile;assembler;
procedure xbios_loadfile(var filename: TString);assembler;
procedure xbios_loaddata(address: Word);assembler;
procedure xbios_write(src: Pointer);assembler;
procedure xbios_read(dst: Pointer);assembler;

implementation

procedure xbios_opencurrentdir;assembler;
  asm {
    jsr xBIOS_OPEN_CURRENT_DIR
  };
end;

procedure xbios_openfile(var filename: TString);assembler;
  asm {

  ;lda filename
  ;clc
  ;adc #1
  ;tay
  ;lda filename+1
  ;adc #0
  ;tax
  ;jsr xBIOS_OPEN_FILE

  txa
  pha
  ldy filename
  ldx filename+1
  iny
  sne
  inx
  jsr xBIOS_OPEN_FILE
  pla
  tax
  };
end;

procedure xbios_closefile;assembler;
  asm {
    jsr xBIOS_FLUSH_BUFFER
  };
end;

procedure xbios_loadfile(var filename: TString);assembler;
  asm {
  txa
  pha
  ldy filename
  ldx filename+1
  iny
  sne
  inx
  jsr xBIOS_LOAD_FILE
  pla
  tax
  };
end;

procedure xbios_loaddata(address: Word);assembler;
  asm {

  txa
  pha
  ;ldy address
  ;ldx address+1
  ldy GFX2_ADDRESS
  ldx GFX2_ADDRESS+1
  jsr xBIOS_LOAD_DATA
  pla
  tax
  };
end;

procedure xbios_write(src: Pointer);assembler;
  asm {
    txa
    pha
    ldy src
    ldx src+1
    jsr xBIOS_WRITE_DATA
    pla
    tax
  };
end;

procedure xbios_read(dst: Pointer);assembler;
  asm {
    txa
    pha
    ldy dst
    ldx dst+1
    JSR xBIOS_LOAD_DATA
    pla
    tax
  };
end;

end.
