{*******************************************************}
{                                                       }
{             MiTeC Memory Manager                      }
{           version 1.0 for Delphi 5,6,7                }
{                                                       }
{           Copyright © 2003 Michal Mutl                }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MiTeC_MM;

interface

uses SysUtils;

type
  PMiTeCMemoryManager = ^TMiTeCMemoryManager;
  TMiTeCMemoryManager = record
    GetMem_Count :integer;
    FreeMem_Count :integer;
  end;

var
  MemoryManager: TMiTeCMemoryManager;
  OldMM: TMemoryManager;

implementation

function NewGetMem(Size: Integer): Pointer;
begin
  Inc(MemoryManager.GetMem_Count);
  Result:=OldMM.GetMem(Size);
end;

function NewFreeMem(P: Pointer): Integer;
begin
   Inc(MemoryManager.FreeMem_Count);
   Result:=OldMM.FreeMem(P);
end;

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Result:=OldMM.ReallocMem(p,size);
  if (p<>nil) then begin
    Inc(MemoryManager.FreeMem_Count);
    if size>0 then
      Inc(MemoryManager.GetMem_Count);
  end else
    if size>0 then
      Inc(MemoryManager.GetMem_Count);
end;

const
  NewMM: TMemoryManager = (
            GetMem: NewGetMem;
            FreeMem: NewFreeMem;
            ReallocMem: NewReallocMem);

procedure SetNewMM;
begin
 MemoryManager.GetMem_Count:=0;
 MemoryManager.FreeMem_Count:=0;
 GetMemoryManager(OldMM);
 SetMemoryManager(NewMM);
end;

initialization
  SetNewMM;
end.

