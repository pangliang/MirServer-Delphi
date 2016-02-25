{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{             Direct Memory Access                      }
{           version 8.3.1 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

{This code was developed by Nico Bendlin (nico@bendlin.de) }

type
  PRomDumpCodeInfo = ^TRomDumpCodeInfo;
  TRomDumpCodeInfo = (rdciStart, rdciEnd, rdciSize);

function _RomDumpCode0F(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0F0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0F0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode0E(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0E0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0E0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode0C(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0C0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0C0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode0B(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0B0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0B0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode0A(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0A0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0A0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode00(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 00h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 00h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode01(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 010h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 010h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode02(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 020h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 020h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode03(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 030h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 030h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode04(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 040h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 040h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode05(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 050h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 050h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode06(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 060h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 060h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode07(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 070h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 070h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode08(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 080h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 080h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode09(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 090h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 090h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

function _RomDumpCode0D(Info: TRomDumpCodeInfo): Pointer;
var
  CodeStart: Pointer;
  CodeEnd: Pointer;
begin
  asm
          JMP     @@End

          { *BEGIN* 16-bit code  }
          { -- never use it in your program! -- }
          { COM which writes ROM-BIOS to StdOut }
  @@Start:
          { Dump F000:0000-F000:FFFE }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0D0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0x0000   ; Data offset
          XOR     eCX, eCX  // CX = 0xFFFF   ; Data length
          DEC     eCX
          XOR     eBX, eBX  // BX = 0x0001   ; STDOUT (file handle)
          INC     eBX
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          { Dump F000:FFFF }
          XOR     eDX, eDX  // DS = 0xF000   ; Data segment
          MOV     DH, 0D0h
          MOV     DS, eDX
          XOR     eDX, eDX  // DX = 0xFFFF   ; Data offset
          DEC     eDX
          XOR     eCX, eCX  // CX = 0x0001   ; Data length
          INC     eCX
          MOV     eBX, eCX  // BX = 0x0001   ; STDOUT (file handle)
          MOV     AH, 40h   // DosCall(0x40) ; INT21, DOS_WRITE_TO_HANDLE
          INT     21h
          JC      @@Exit    // On error exit ; AL = Error code
          MOV     AL, 0     // no error      ; AL = 0
  @@Exit:
          MOV     AH, 4Ch   // DosCall(0x4C) ; INT21, DOS_TERMINATE_EXE
          INT     21h
  @@End:
          { *END* 16-bit code  }

          MOV     CodeStart, OFFSET @@Start
          MOV     CodeEnd, OFFSET @@End
  end;
  case Info of
    rdciStart:
      Result := CodeStart;
    rdciEnd:
      Result := CodeEnd;
    rdciSize:
      Result := Pointer(Cardinal(CodeEnd) - Cardinal(CodeStart));
  else
    Result := nil;
  end;
end;

{ *INTERNAL* - Save 16-bit code to file }

function _RomDumpCodeToFile(Start: Byte; const Filename: string): Boolean;
var
  ComFile: THandle;
  Size: Cardinal;
begin
  Result := False;
  ComFile := CreateFile(PChar(Filename), GENERIC_WRITE, FILE_SHARE_READ, nil,
    CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if ComFile <> INVALID_HANDLE_VALUE then
  try
    case Start of
      $00: Result:=WriteFile(ComFile,_RomDumpCode00(rdciStart)^,Cardinal(_RomDumpCode00(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode00(rdciSize)));
      $10: Result:=WriteFile(ComFile,_RomDumpCode01(rdciStart)^,Cardinal(_RomDumpCode01(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode01(rdciSize)));
      $20: Result:=WriteFile(ComFile,_RomDumpCode02(rdciStart)^,Cardinal(_RomDumpCode02(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode02(rdciSize)));
      $30: Result:=WriteFile(ComFile,_RomDumpCode03(rdciStart)^,Cardinal(_RomDumpCode03(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode03(rdciSize)));
      $40: Result:=WriteFile(ComFile,_RomDumpCode04(rdciStart)^,Cardinal(_RomDumpCode04(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode04(rdciSize)));
      $50: Result:=WriteFile(ComFile,_RomDumpCode05(rdciStart)^,Cardinal(_RomDumpCode05(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode05(rdciSize)));
      $60: Result:=WriteFile(ComFile,_RomDumpCode06(rdciStart)^,Cardinal(_RomDumpCode06(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode06(rdciSize)));
      $70: Result:=WriteFile(ComFile,_RomDumpCode07(rdciStart)^,Cardinal(_RomDumpCode07(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode07(rdciSize)));
      $80: Result:=WriteFile(ComFile,_RomDumpCode08(rdciStart)^,Cardinal(_RomDumpCode08(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode08(rdciSize)));
      $90: Result:=WriteFile(ComFile,_RomDumpCode09(rdciStart)^,Cardinal(_RomDumpCode09(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode09(rdciSize)));
      $A0: Result:=WriteFile(ComFile,_RomDumpCode0A(rdciStart)^,Cardinal(_RomDumpCode0A(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0A(rdciSize)));
      $B0: Result:=WriteFile(ComFile,_RomDumpCode0B(rdciStart)^,Cardinal(_RomDumpCode0B(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0B(rdciSize)));
      $C0: Result:=WriteFile(ComFile,_RomDumpCode0C(rdciStart)^,Cardinal(_RomDumpCode0C(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0C(rdciSize)));
      $D0: Result:=WriteFile(ComFile,_RomDumpCode0D(rdciStart)^,Cardinal(_RomDumpCode0D(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0D(rdciSize)));
      $E0: Result:=WriteFile(ComFile,_RomDumpCode0E(rdciStart)^,Cardinal(_RomDumpCode0E(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0E(rdciSize)));
      $F0: Result:=WriteFile(ComFile,_RomDumpCode0F(rdciStart)^,Cardinal(_RomDumpCode0F(rdciSize)),Size,nil) and (Size=Cardinal(_RomDumpCode0F(rdciSize)));
    end;
    if not Result then
      DeleteFile(PChar(Filename));
  finally
    CloseHandle(ComFile);
  end;
end;

{ *INTERNAL* - Execute 16-bit code redirected to file }

function _RomDumpCodeExecute(const Com, Dmp: string; Timeout: DWORD): Boolean;
var
  ComSpec: string;
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  Result := False;
  SetLength(ComSpec, MAX_PATH);
  SetLength(ComSpec,
    GetEnvironmentVariable('ComSpec', PChar(@ComSpec[1]), MAX_PATH));
  if Length(ComSpec) > 0 then
  begin
    FillChar(si, SizeOf(TStartupInfo), 0);
    si.cb := SizeOf(TStartupInfo);
    si.dwFlags := STARTF_USESHOWWINDOW;
    si.wShowWindow := SW_HIDE;
    if CreateProcess(nil, PChar(ComSpec + ' /C ' + Com + ' > ' + Dmp),
      nil, nil, False, CREATE_NEW_CONSOLE or CREATE_NEW_PROCESS_GROUP, nil,
      nil, si, pi) then
    try
      Result := WaitForSingleObject(pi.hProcess, Timeout) <> WAIT_TIMEOUT;
    finally
      CloseHandle(pi.hProcess);
      CloseHandle(pi.hThread);
    end;
  end;
end;

function DirectoryExists(const Dir: string): Boolean;
var
  Attr: DWORD;
begin
  Attr := GetFileAttributes(PChar(Dir));
  Result := (Attr <> $FFFFFFFF) and
    (Attr and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY);
end;

{ Get BIOS dump the generic way }

function ReadRomBios16(Start: Byte; var Buffer: TMemoryBuffer; Timeout: DWORD): Boolean;
const
  TempSub = '~RomDmp';
  ComName = 'RomDump.com';
  DmpName = 'Rom.dmp';
var
  TempPath: string;
  TempDir: string;
  TempIdx: Integer;
  TempIdxStr: string;
  ComFile: string;
  DmpFile: string;
  DmpHandle: THandle;
  Written: DWORD;
begin
  Result := False;
  SetLength(TempPath, MAX_PATH);
  SetLength(TempPath, GetTempPath(MAX_PATH, PChar(@TempPath[1])));
  if Length(TempPath) > 0 then
  begin
    if (TempPath[Length(TempPath)] <> '\') then
      TempPath := TempPath + '\';
    TempIdx := 0;
    repeat
      Inc(TempIdx);
      Str(TempIdx, TempIdxStr);
      TempDir := TempPath + TempSub + TempIdxStr;
    until not DirectoryExists(TempDir);
    if CreateDirectory(PChar(TempDir), nil) then
    try
      TempDir := TempDir + '\';
      ComFile := TempDir + ComName;
      DmpFile := TempDir + DmpName;
      if _RomDumpCodeToFile(Start,ComFile) then
      try
        if _RomDumpCodeExecute(ComFile, DmpFile, Timeout) then
        begin
          DmpHandle := CreateFile(PChar(DmpFile), GENERIC_READ,
            FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
          if DmpHandle <> INVALID_HANDLE_VALUE then
          try
            FillChar(Buffer, SizeOf(TMemoryBuffer),0);
            Result := ReadFile(DmpHandle, Buffer, SizeOf(TMemoryBuffer),
              Written, nil) and (Written = SizeOf(TMemoryBuffer));
          finally
            CloseHandle(DmpHandle);
          end;
        end;
      finally
        DeleteFile(PChar(DmpFile));
        DeleteFile(PChar(ComFile));
      end;
    finally
      RemoveDirectory(PChar(TempDir));
    end;
  end;
end;

{End of code developed by Nico Bendlin (nico@bendlin.de) }


