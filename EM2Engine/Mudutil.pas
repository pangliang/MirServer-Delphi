unit MudUtil;

interface
uses
  Windows, Classes, SysUtils;
type
  TQuickList = class(TStringList)
  private
    GQuickListCriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock();
    procedure UnLock;
    function GetIndex(sName: string): Integer;
    procedure AddRecord(sCharName: string; dwTickTime: LongWord);
  end;
implementation

constructor TQuickList.Create;
begin
  inherited Create;
  InitializeCriticalSection(GQuickListCriticalSection);
end;

destructor TQuickList.Destroy;
begin
  DeleteCriticalSection(GQuickListCriticalSection);
  inherited;
end;

procedure TQuickList.Lock; //0x00457EA8
begin
  EnterCriticalSection(GQuickListCriticalSection);
end;

procedure TQuickList.UnLock;
begin
  LeaveCriticalSection(GQuickListCriticalSection);
end;
{function TQuickList.GetIndex(sName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Self.Count - 1 do begin
    if CompareText(sName, Self.Strings[I]) = 0 then begin
      Result := I;
    end;
  end;
end; }
procedure TQuickList.AddRecord(sCharName: string; dwTickTime: LongWord);
begin
  AddObject(sCharName, TObject(dwTickTime));
end;
function TQuickList.GetIndex(sName: string): Integer;
var
  nIndex: Integer;
begin
  Result := -1;
  for nIndex := 0 to Self.Count - 1 do begin
    if CompareText(sName, Self.Strings[nIndex]) = 0 then begin
      Result := nIndex;
    end;
  end;
end;
{function TQuickList.GetIndex(sName: string): Integer;
var
  nLow, nHigh, nMed, nCompareVal: Integer;
begin
  Result := -1;
  if Self.Count <> 0 then begin
    if Self.Sorted then begin
      if Self.Count = 1 then begin
        if CompareText(sName, Self.Strings[0]) = 0 then Result := 0; // - > 0x0045B71D
      end else begin //0x0045B51E
        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (True) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareText(sName, Self.Strings[nHigh]) = 0 then Result := nHigh;
            if CompareText(sName, Self.Strings[nLow]) = 0 then Result := nLow;
            break;
          end else begin
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end; //0x0045B5DA
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := nMed;
            break;
          end; //0x0045B609
        end;
      end;
    end else begin //0x0045B609
      if Self.Count = 1 then begin
        if CompareText(sName, Self.Strings[0]) = 0 then Result := 0;
      end else begin
        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (True) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareText(sName, Self.Strings[nHigh]) = 0 then Result := nHigh;
            if CompareText(sName, Self.Strings[nLow]) = 0 then Result := nLow;
            break;
          end else begin //0x0045B6B3
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := nMed;
            break;
          end;
        end;
      end;
    end;
  end;
end; }

{procedure TQuickList.AddRecord(sCharName: string; dwTickTime: LongWord);
var
  ChrList: TList;
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  if Count = 0 then begin
    ChrList := TList.Create;
    ChrList.Add(TObject(dwTickTime));
    AddObject(sCharName, ChrList);
  end else begin //0x0045B839
    if Count = 1 then begin
      nMed := CompareText(sCharName, Self.Strings[0]);
      if nMed > 0 then begin
        ChrList := TList.Create;
        ChrList.Add(TObject(dwTickTime));
        AddObject(sCharName, ChrList);
      end else begin //0x0045B89C
        if nMed < 0 then begin
          ChrList := TList.Create;
          ChrList.Add(TObject(dwTickTime));
          InsertObject(0, sCharName, ChrList);
        end else begin
          ChrList := TList(Self.Objects[0]);
          ChrList.Add(TObject(dwTickTime));
        end;
      end;
    end else begin //0x0045B8EF
      nLow := 0;
      nHigh := Self.Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (True) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(sCharName, Self.Strings[nHigh]);
          if n20 > 0 then begin
            ChrList := TList.Create;
            ChrList.Add(TObject(dwTickTime));
            InsertObject(nHigh + 1, sCharName, ChrList);
            break;
          end else begin
            if CompareText(sCharName, Self.Strings[nHigh]) = 0 then begin
              ChrList := TList(Self.Objects[nHigh]);
              ChrList.Add(TObject(dwTickTime));
              break;
            end else begin //0x0045B9BB
              n20 := CompareText(sCharName, Self.Strings[nLow]);
              if n20 > 0 then begin
                ChrList := TList.Create;
                ChrList.Add(TObject(dwTickTime));
                InsertObject(nLow + 1, sCharName, ChrList);
                break;
              end else begin
                if n20 < 0 then begin
                  ChrList := TList.Create;
                  ChrList.Add(TObject(dwTickTime));
                  InsertObject(nLow, sCharName, ChrList);
                  break;
                end else begin
                  ChrList := TList(Self.Objects[n20]);
                  ChrList.Add(TObject(dwTickTime));
                  break;
                end;
              end;
            end;
          end;

        end else begin //0x0045BA6A
          n1C := CompareText(sCharName, Self.Strings[nMed]);
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          ChrList := TList(Self.Objects[nMed]);
          ChrList.Add(TObject(dwTickTime));
          break;
        end;
      end;
    end;
  end;
end;  }

initialization

finalization

end.

