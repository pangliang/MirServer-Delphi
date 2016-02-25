unit FIDHum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, DB, DBTables, Grids, Buttons, HumDB, Grobal2;
type
  TFrmIDHum = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    EdChrName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    BtnCreateChr: TSpeedButton;
    BtnEraseChr: TSpeedButton;
    BtnChrNameSearch: TSpeedButton;
    IdGrid: TStringGrid;
    ChrGrid: TStringGrid;
    BtnSelAll: TSpeedButton;
    CbShowDelChr: TCheckBox;
    BtnDeleteChr: TSpeedButton;
    BtnRevival: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Label2: TLabel;
    EdUserId: TEdit;
    BtnDeleteChrAllInfo: TSpeedButton;
    SpeedButton2: TSpeedButton;
    LabelCount: TLabel;
    SpeedButtonEditData: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnChrNameSearchClick(Sender: TObject);
    procedure BtnSelAllClick(Sender: TObject);
    procedure BtnEraseChrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChrGridClick(Sender: TObject);
    procedure ChrGridDblClick(Sender: TObject);
    procedure BtnDeleteChrClick(Sender: TObject);
    procedure BtnRevivalClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnCreateChrClick(Sender: TObject);
    procedure BtnDeleteChrAllInfoClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure RefChrGrid(n08: Integer; HumDBRecord: THumInfo);
    procedure _PROC_004A0805(Sender: TObject);
    procedure _PROC_004A0D29(Sender: TObject);
    procedure _PROC_004A0E3A(Sender: TObject);
    procedure _PROC_004A1025(Sender: TObject);
    procedure _PROC_004A1054(Sender: TObject);
    procedure EdChrNameKeyPress(Sender: TObject; var Key: Char);
    procedure EdUserIdKeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButtonEditDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIDHum: TFrmIDHum;

implementation

uses HUtil32, MudUtil, CreateChr, FDBexpl, viewrcd, EditRcd;


{$R *.DFM}

procedure TFrmIDHum.FormCreate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  IdGrid.Cells[0, 0] := 'µ«¬º’ ∫≈';
  IdGrid.Cells[1, 0] := '√‹¬Î';
  IdGrid.Cells[2, 0] := '”√ªß√˚≥∆';
  IdGrid.Cells[3, 0] := 'ResiRegi';
  IdGrid.Cells[4, 0] := 'Tran';
  IdGrid.Cells[5, 0] := 'Secretwd';
  IdGrid.Cells[6, 0] := 'Adress(cont)';
  IdGrid.Cells[7, 0] := '±∏◊¢';

  ChrGrid.Cells[0, 0] := 'À˜“˝∫≈';
  ChrGrid.Cells[1, 0] := '»ÀŒÔ√˚≥∆';
  ChrGrid.Cells[2, 0] := 'µ«¬º’ ∫≈';
  ChrGrid.Cells[3, 0] := ' «∑ÒΩ˚”√';
  ChrGrid.Cells[4, 0] := 'Ω˚”√ ±º‰';
  ChrGrid.Cells[5, 0] := '≤Ÿ◊˜º∆ ˝';
  ChrGrid.Cells[6, 0] := '—°‘Ò±‡∫≈';
end;

procedure TFrmIDHum.Edit2KeyPress(Sender: TObject; var Key: Char);
begin

  (*
  0049FEAC   55                     push    ebp
  0049FEAD   8BEC                   mov     ebp, esp
  0049FEAF   83C4F0                 add     esp, -$10
  0049FEB2   53                     push    ebx
  0049FEB3   33DB                   xor     ebx, ebx
  0049FEB5   895DF0                 mov     [ebp-$10], ebx
  0049FEB8   894DF8                 mov     [ebp-$08], ecx
  0049FEBB   8955F4                 mov     [ebp-$0C], edx
  0049FEBE   8945FC                 mov     [ebp-$04], eax
  0049FEC1   33C0                   xor     eax, eax
  0049FEC3   55                     push    ebp

  * Possible String Reference to: 'È⁄6ˆˇÎ[ãÂ]√'
  |
  0049FEC4   6835FF4900             push    $0049FF35

  ***** TRY
  |
  0049FEC9   64FF30                 push    dword ptr fs:[eax]
  0049FECC   648920                 mov     fs:[eax], esp
  0049FECF   8B45F8                 mov     eax, [ebp-$08]
  0049FED2   80380D                 cmp     byte ptr [eax], $0D
  0049FED5   7548                   jnz     0049FF1F
  0049FED7   8D55F0                 lea     edx, [ebp-$10]

  * Reference to FrmIDHum
  |
  0049FEDA   8B45FC                 mov     eax, [ebp-$04]

  * Reference to control TFrmIDHum.Edit2 : TEdit
  |
  0049FEDD   8B80DC020000           mov     eax, [eax+$02DC]

  * Reference to: controls.TControl.GetText(TControl):TCaption;
  |
  0049FEE3   E8781EF9FF             call    00431D60
  0049FEE8   8B45F0                 mov     eax, [ebp-$10]

  * Possible String Reference to: 'humconvert'
  |
  0049FEEB   BA4CFF4900             mov     edx, $0049FF4C

  * Reference to: system.@LStrCmp;
  |
  0049FEF0   E89B40F6FF             call    00403F90
  0049FEF5   7518                   jnz     0049FF0F
  0049FEF7   33D2                   xor     edx, edx

  * Reference to FrmIDHum
  |
  0049FEF9   8B45FC                 mov     eax, [ebp-$04]

  * Reference to control TFrmIDHum.Edit2 : TEdit
  |
  0049FEFC   8B80DC020000           mov     eax, [eax+$02DC]

  * Reference to: controls.TControl.SetText(TControl;TCaption);
  |
  0049FF02   E8891EF9FF             call    00431D90

  * Reference to FrmIDHum
  |
  0049FF07   8B45FC                 mov     eax, [ebp-$04]

  * Reference to: FIDHum.Proc_0049FAAC
  |
  0049FF0A   E89DFBFFFF             call    0049FAAC
  0049FF0F   33D2                   xor     edx, edx

  * Reference to FrmIDHum
  |
  0049FF11   8B45FC                 mov     eax, [ebp-$04]

  * Reference to control TFrmIDHum.Edit2 : TEdit
  |
  0049FF14   8B80DC020000           mov     eax, [eax+$02DC]

  * Reference to: controls.TControl.SetText(TControl;TCaption);
  |
  0049FF1A   E8711EF9FF             call    00431D90
  0049FF1F   33C0                   xor     eax, eax
  0049FF21   5A                     pop     edx
  0049FF22   59                     pop     ecx
  0049FF23   59                     pop     ecx
  0049FF24   648910                 mov     fs:[eax], edx

  ****** FINALLY
  |

  * Possible String Reference to: '[ãÂ]√'
  |
  0049FF27   683CFF4900             push    $0049FF3C
  0049FF2C   8D45F0                 lea     eax, [ebp-$10]

  * Reference to: system.@LStrClr(String;String);
  |
  0049FF2F   E8CC3CF6FF             call    00403C00
  0049FF34   C3                     ret


  * Reference to: system.@HandleFinally;
  |
  0049FF35   E9DA36F6FF             jmp     00403614
  0049FF3A   EBF0                   jmp     0049FF2C

  ****** END
  |
  0049FF3C   5B                     pop     ebx
  0049FF3D   8BE5                   mov     esp, ebp
  0049FF3F   5D                     pop     ebp
  0049FF40   C3                     ret

  *)
end;

procedure TFrmIDHum.EdUserIdKeyPress(Sender: TObject; var Key: Char);
//0x0049FF58
var
  sAccount: string;
  ChrList: TStringList;
  i, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  if Key = #13 then begin
    Key := #0;
    sAccount := EdUserId.Text;
    ChrGrid.RowCount := 1;
    if sAccount <> '' then begin
      ChrList := TStringList.Create;
      try
        if HumChrDB.OpenEx then begin
          HumChrDB.FindByAccount(sAccount, ChrList);
          for i := 0 to ChrList.Count - 1 do begin
            nIndex := pTQuickID(ChrList.Objects[i]).nIndex;
            if nIndex >= 0 then begin
              HumChrDB.GetBy(nIndex, HumDBRecord);
              if CbShowDelChr.Checked then RefChrGrid(nIndex, HumDBRecord)
              else if not HumDBRecord.boDeleted then
                RefChrGrid(nIndex, HumDBRecord);
            end;
          end;
        end;
      finally
        HumChrDB.Close;
      end;
      ChrList.Free;
    end;
  end;
end;

procedure TFrmIDHum.EdChrNameKeyPress(Sender: TObject; var Key: Char);
//0x004A025C
begin
  if Key = #13 then begin
    Key := #0;
    BtnChrNameSearchClick(Sender);
  end;
end;

procedure TFrmIDHum.BtnChrNameSearchClick(Sender: TObject);
var
  s64: string;
  n08, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  s64 := EdChrName.Text;
  ChrGrid.RowCount := 1;
  try
    if HumChrDB.OpenEx then begin
      n08 := HumChrDB.Index(s64);
      if n08 >= 0 then begin
        nIndex := HumChrDB.Get(n08, HumDBRecord);
        if nIndex >= 0 then begin
          if CbShowDelChr.Checked then RefChrGrid(nIndex, HumDBRecord)
          else if not HumDBRecord.boDeleted then
            RefChrGrid(nIndex, HumDBRecord);
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmIDHum.BtnSelAllClick(Sender: TObject);
var
  sChrName: string;
  ChrList: TStringList;
  i, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  ChrGrid.RowCount := 1;
  ChrList := TStringList.Create;
  try
    if HumChrDB.OpenEx then begin
      if HumChrDB.FindByName(sChrName, ChrList) > 0 then begin
        for i := 0 to ChrList.Count - 1 do begin
          nIndex := Integer(ChrList.Objects[i]);
          if HumChrDB.GetBy(nIndex, HumDBRecord) then begin
            if CbShowDelChr.Checked then RefChrGrid(nIndex, HumDBRecord)
            else if not HumDBRecord.boDeleted then
              RefChrGrid(nIndex, HumDBRecord);
          end;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  ChrList.Free;
end;

procedure TFrmIDHum.BtnEraseChrClick(Sender: TObject); //004A04DC
var
  sChrName: string;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then Exit;
  if MessageDlg(' «∑Ò»∑»œ…æ≥˝»ÀŒÔ ' + sChrName + ' £ø', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        HumChrDB.Delete(sChrName);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.FormShow(Sender: TObject);
begin
  EdChrName.SetFocus;
end;

procedure TFrmIDHum.ChrGridClick(Sender: TObject);
var
  nRow: Integer;
begin
  nRow := ChrGrid.Row;
  if nRow < 1 then Exit;
  if ChrGrid.RowCount - 1 < nRow then Exit;
  EdChrName.Text := ChrGrid.Cells[1, nRow];
end;

procedure TFrmIDHum.ChrGridDblClick(Sender: TObject); //0x004A08C0
var
  n8, nC: Integer;
  s10: string;
  ChrRecord: THumDataInfo;
begin
  s10 := '';
  n8 := ChrGrid.Row;
  if (n8 >= 1) and (ChrGrid.RowCount - 1 >= n8) then
    s10 := ChrGrid.Cells[1, n8];
  try
    if HumDataDB.OpenEx then begin
      nC := HumDataDB.Index(s10);
      if nC >= 0 then begin
        if HumDataDB.Get(nC, ChrRecord) >= 0 then begin
          FrmFDBViewer.n2F8 := nC;
          FrmFDBViewer.s2FC := s10;
          FrmFDBViewer.ChrRecord := ChrRecord;
          FrmFDBViewer.ShowHumData;
          FrmFDBViewer.Left := FrmIDHum.Left - 144;
          FrmFDBViewer.Top := FrmIDHum.Top + 100;
          FrmFDBViewer.Show;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmIDHum.BtnDeleteChrClick(Sender: TObject);
var
  sChrName: string;
  nIndex: Integer;
  HumRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then Exit;
  if MessageDlg(' «∑Ò»∑»œΩ˚”√»ÀŒÔ ' + sChrName + ' £ø', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex := HumChrDB.Index(sChrName);
        HumChrDB.Get(nIndex, HumRecord);
        HumRecord.boDeleted := True;
        HumRecord.dModDate := Now();
        Inc(HumRecord.btCount);
        HumChrDB.Update(nIndex, HumRecord);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.BtnRevivalClick(Sender: TObject);
//0x004A0D28
var
  sChrName: string;
  nIndex: Integer;
  HumRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then Exit;
  if MessageDlg(' «∑Ò»∑»œ∆Ù”√»ÀŒÔ ' + sChrName + ' £ø', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex := HumChrDB.Index(sChrName);
        HumChrDB.Get(nIndex, HumRecord);
        HumRecord.boDeleted := False;
        Inc(HumRecord.btCount);
        HumChrDB.Update(nIndex, HumRecord);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton1Click(Sender: TObject);
begin
  FrmFDBExplore.Show;
end;

procedure TFrmIDHum.Button1Click(Sender: TObject);
begin
  (*
  004A0E6C   55                     push    ebp
  004A0E6D   8BEC                   mov     ebp, esp
  004A0E6F   83C4F8                 add     esp, -$08
  004A0E72   8955F8                 mov     [ebp-$08], edx
  004A0E75   8945FC                 mov     [ebp-$04], eax

  * Reference to TFrmAccServer instance
  |
  004A0E78   A168C24A00             mov     eax, dword ptr [$004AC268]
  004A0E7D   8B00                   mov     eax, [eax]

  * Reference to : TFrmAccServer._PROC_0049E28C()
  |
  004A0E7F   E808D4FFFF             call    0049E28C
  004A0E84   59                     pop     ecx
  004A0E85   59                     pop     ecx
  004A0E86   5D                     pop     ebp
  004A0E87   C3                     ret

  *)
end;

procedure TFrmIDHum.BtnCreateChrClick(Sender: TObject);
var
  nCheckCode: Integer;
  HumRecord: THumInfo;
begin
  if not FrmCreateChr.IncputChrInfo then Exit;
  nCheckCode := 0;
  try
    if HumChrDB.Open then begin
      if HumChrDB.ChrCountOfAccount(FrmCreateChr.sUserId) < 2 then begin
        HumRecord.Header.nSelectID := FrmCreateChr.nSelectID;
        HumRecord.sChrName := FrmCreateChr.sChrName;
        HumRecord.sAccount := FrmCreateChr.sUserId;
        HumRecord.boDeleted := False;
        HumRecord.btCount := 0;
        HumRecord.Header.sName := FrmCreateChr.sChrName;
        if HumRecord.Header.sName <> '' then begin
          if not HumChrDB.Add(HumRecord) then nCheckCode := 2;
        end;
      end else nCheckCode := 3;
    end;
  finally
    HumChrDB.Close;
  end;
  if nCheckCode = 0 then ShowMessage('»ÀŒÔ¥¥Ω®≥…π¶...')
  else ShowMessage('»ÀŒÔ¥¥Ω® ß∞‹£°£°£°')
end;

procedure TFrmIDHum.BtnDeleteChrAllInfoClick(Sender: TObject); //0x004A0610
var
  sChrName: string;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then Exit;
  if MessageDlg(' «∑Ò»∑»œ…æ≥˝»ÀŒÔ ' + sChrName + ' º∞»ÀŒÔ ˝æ›£ø', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        HumChrDB.Delete(sChrName);
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.Open then HumDataDB.Delete(sChrName);
    finally
      HumDataDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton2Click(Sender: TObject); //0x004A0B64
var
  nIndex: Integer;
  HumRecord: THumInfo;
  nRow: Integer;
begin
  nRow := ChrGrid.Row;
  if nRow < 1 then Exit;
  if ChrGrid.RowCount - 1 < nRow then Exit;
  nIndex := Str_ToInt(ChrGrid.Cells[0, nRow], 0);
  if MessageDlg(' «∑Ò»∑»œΩ˚”√º«¬º ' + IntToStr(nIndex) + ' £ø', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        if HumChrDB.GetBy(nIndex, HumRecord) then begin
          HumRecord.boDeleted := True;
          HumRecord.dModDate := Now();
          Inc(HumRecord.btCount);
          HumChrDB.UpdateBy(nIndex, HumRecord);
        end;
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.RefChrGrid(n08: Integer; HumDBRecord: THumInfo); //0x004A00C4
var
  nRowCount: Integer;
begin
  ChrGrid.RowCount := ChrGrid.RowCount + 1;
  ChrGrid.FixedRows := 1;
  nRowCount := ChrGrid.RowCount - 1;
  ChrGrid.Cells[0, nRowCount] := IntToStr(n08);
  ChrGrid.Cells[1, nRowCount] := HumDBRecord.sChrName;
  ChrGrid.Cells[2, nRowCount] := HumDBRecord.sAccount;
  ChrGrid.Cells[3, nRowCount] := BoolToStr(HumDBRecord.boDeleted);
  if HumDBRecord.boDeleted then
    ChrGrid.Cells[4, nRowCount] := DateTimeToStr(HumDBRecord.dModDate)
  else ChrGrid.Cells[4, nRowCount] := '';

  ChrGrid.Cells[5, nRowCount] := IntToStr(HumDBRecord.btCount);
  ChrGrid.Cells[6, nRowCount] := IntToStr(HumDBRecord.Header.nSelectID);
  LabelCount.Caption := IntToStr(ChrGrid.RowCount - 1);
end;

procedure TFrmIDHum._PROC_004A0805(Sender: TObject);
begin
  (*
  004A0805   8BEC                   mov     ebp, esp
  004A0807   83C4F8                 add     esp, -$08
  004A080A   8955F8                 mov     [ebp-$08], edx
  004A080D   8945FC                 mov     [ebp-$04], eax

  * Reference to FrmIDHum
  |
  004A0810   8B45FC                 mov     eax, [ebp-$04]

  * Reference to control TFrmIDHum.EdChrName : TEdit
  |
  004A0813   8B80E4020000           mov     eax, [eax+$02E4]
  004A0819   8B10                   mov     edx, [eax]

  * Reference to method TEdit.SetFocus()
  |
  004A081B   FF92B0000000           call    dword ptr [edx+$00B0]
  004A0821   59                     pop     ecx
  004A0822   59                     pop     ecx
  004A0823   5D                     pop     ebp
  004A0824   C3                     ret

  *)
end;

procedure TFrmIDHum._PROC_004A0D29(Sender: TObject);
begin
  (*
  004A0D29   8BEC                   mov     ebp, esp
  004A0D2B   83C4A4                 add     esp, -$5C
  004A0D2E   33C9                   xor     ecx, ecx
  004A0D30   894DA4                 mov     [ebp-$5C], ecx
  004A0D33   894DF4                 mov     [ebp-$0C], ecx
  004A0D36   8955F0                 mov     [ebp-$10], edx
  004A0D39   8945FC                 mov     [ebp-$04], eax
  004A0D3C   33C0                   xor     eax, eax
  004A0D3E   55                     push    ebp
  004A0D3F   68250E4A00             push    $004A0E25

  ***** TRY
  |
  004A0D44   64FF30                 push    dword ptr fs:[eax]
  004A0D47   648920                 mov     fs:[eax], esp
  004A0D4A   8D55F4                 lea     edx, [ebp-$0C]

  * Reference to FrmIDHum
  |
  004A0D4D   8B45FC                 mov     eax, [ebp-$04]

  * Reference to control TFrmIDHum.EdChrName : TEdit
  |
  004A0D50   8B80E4020000           mov     eax, [eax+$02E4]

  * Reference to: controls.TControl.GetText(TControl):TCaption;
  |
  004A0D56   E80510F9FF             call    00431D60
  004A0D5B   6A00                   push    $00
  004A0D5D   8D45A4                 lea     eax, [ebp-$5C]

  * Possible String Reference to: ' Undelete Characte?'
  |
  004A0D60   B9380E4A00             mov     ecx, $004A0E38
  004A0D65   8B55F4                 mov     edx, [ebp-$0C]

  * Reference to: system.@LStrCat3;
  |
  004A0D68   E85F31F6FF             call    00403ECC
  004A0D6D   8B45A4                 mov     eax, [ebp-$5C]
  004A0D70   668B0D4C0E4A00         mov     cx, word ptr [$004A0E4C]
  004A0D77   B203                   mov     dl, $03

  * Reference to: Dialogs.Proc_00455230
  |
  004A0D79   E8B244FBFF             call    00455230
  004A0D7E   48                     dec     eax
  004A0D7F   0F8582000000           jnz     004A0E07
  004A0D85   33C0                   xor     eax, eax
  004A0D87   55                     push    ebp
  004A0D88   68000E4A00             push    $004A0E00

  ***** TRY
  |
  004A0D8D   64FF30                 push    dword ptr fs:[eax]
  004A0D90   648920                 mov     fs:[eax], esp

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0D93   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0D98   8B00                   mov     eax, [eax]

  * Reference to: Unit_0048B6D0.Proc_0048B928
  |
  004A0D9A   E889ABFEFF             call    0048B928
  004A0D9F   84C0                   test    al, al
  004A0DA1   7443                   jz      004A0DE6

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0DA3   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0DA8   8B00                   mov     eax, [eax]
  004A0DAA   8B55F4                 mov     edx, [ebp-$0C]

  * Reference to: Unit_0048B6D0.Proc_0048C384
  |
  004A0DAD   E8D2B5FEFF             call    0048C384
  004A0DB2   8945F8                 mov     [ebp-$08], eax
  004A0DB5   837DF800               cmp     dword ptr [ebp-$08], +$00
  004A0DB9   7C2B                   jl      004A0DE6
  004A0DBB   8D4DA8                 lea     ecx, [ebp-$58]

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0DBE   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0DC3   8B00                   mov     eax, [eax]
  004A0DC5   8B55F8                 mov     edx, [ebp-$08]

  * Reference to: Unit_0048B6D0.Proc_0048C0CC
  |
  004A0DC8   E8FFB2FEFF             call    0048C0CC
  004A0DCD   C645DE00               mov     byte ptr [ebp-$22], $00
  004A0DD1   FE45E8                 inc     byte ptr [ebp-$18]

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0DD4   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0DD9   8B00                   mov     eax, [eax]
  004A0DDB   8D4DA8                 lea     ecx, [ebp-$58]
  004A0DDE   8B55F8                 mov     edx, [ebp-$08]

  * Reference to: Unit_0048B6D0.Proc_0048C14C
  |
  004A0DE1   E866B3FEFF             call    0048C14C
  004A0DE6   33C0                   xor     eax, eax
  004A0DE8   5A                     pop     edx
  004A0DE9   59                     pop     ecx
  004A0DEA   59                     pop     ecx
  004A0DEB   648910                 mov     fs:[eax], edx

  ****** FINALLY
  |
  004A0DEE   68070E4A00             push    $004A0E07

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0DF3   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0DF8   8B00                   mov     eax, [eax]

  * Reference to: Unit_0048B6D0.Proc_0048BA24
  |
  004A0DFA   E825ACFEFF             call    0048BA24
  004A0DFF   C3                     ret


  * Reference to: system.@HandleFinally;
  |
  004A0E00   E90F28F6FF             jmp     00403614
  004A0E05   EBEC                   jmp     004A0DF3

  ****** END
  |
  004A0E07   33C0                   xor     eax, eax
  004A0E09   5A                     pop     edx
  004A0E0A   59                     pop     ecx
  004A0E0B   59                     pop     ecx
  004A0E0C   648910                 mov     fs:[eax], edx

  ****** FINALLY
  |
  004A0E0F   682C0E4A00             push    $004A0E2C
  004A0E14   8D45A4                 lea     eax, [ebp-$5C]

  * Reference to: system.@LStrClr(String;String);
  |
  004A0E17   E8E42DF6FF             call    00403C00
  004A0E1C   8D45F4                 lea     eax, [ebp-$0C]

  * Reference to: system.@LStrClr(String;String);
  |
  004A0E1F   E8DC2DF6FF             call    00403C00
  004A0E24   C3                     ret


  * Reference to: system.@HandleFinally;
  |
  004A0E25   E9EA27F6FF             jmp     00403614
  004A0E2A   EBE8                   jmp     004A0E14

  ****** END
  |
  004A0E2C   8BE5                   mov     esp, ebp
  004A0E2E   5D                     pop     ebp
  004A0E2F   C3                     ret

  *)
end;

procedure TFrmIDHum._PROC_004A0E3A(Sender: TObject);
begin
  (*
  004A0E3A   6E                     outsb
  004A0E3B   64656C                 insb
  004A0E3E   657465                 jz      004A0EA6
  004A0E41   204368                 and     [ebx+$68], al
  004A0E44   61                     popa
  004A0E45   7261                   jb      004A0EA8
  004A0E47   6374653F               arpl    [ebp+$3F], si
  004A0E4B   000C00                 add     [eax+eax], cl
  004A0E4E   0000                   add     [eax], al

  004A0E50   55                     push    ebp
  004A0E51   8BEC                   mov     ebp, esp
  004A0E53   83C4F8                 add     esp, -$08
  004A0E56   8955F8                 mov     [ebp-$08], edx
  004A0E59   8945FC                 mov     [ebp-$04], eax

  * Reference to TFrmFDBExplore instance
  |
  004A0E5C   A18CC14A00             mov     eax, dword ptr [$004AC18C]
  004A0E61   8B00                   mov     eax, [eax]

  * Reference to: forms.TCustomForm.Show(TCustomForm);
  |
  004A0E63   E814BFFAFF             call    0044CD7C
  004A0E68   59                     pop     ecx
  004A0E69   59                     pop     ecx
  004A0E6A   5D                     pop     ebp
  004A0E6B   C3                     ret

  004A0E6C   55                     push    ebp
  004A0E6D   8BEC                   mov     ebp, esp
  004A0E6F   83C4F8                 add     esp, -$08
  004A0E72   8955F8                 mov     [ebp-$08], edx
  004A0E75   8945FC                 mov     [ebp-$04], eax

  * Reference to TFrmAccServer instance
  |
  004A0E78   A168C24A00             mov     eax, dword ptr [$004AC268]
  004A0E7D   8B00                   mov     eax, [eax]

  * Reference to : TFrmAccServer._PROC_0049E28C()
  |
  004A0E7F   E808D4FFFF             call    0049E28C
  004A0E84   59                     pop     ecx
  004A0E85   59                     pop     ecx
  004A0E86   5D                     pop     ebp
  004A0E87   C3                     ret

  004A0E88   55                     push    ebp
  004A0E89   8BEC                   mov     ebp, esp
  004A0E8B   81C4ACFEFFFF           add     esp, $FFFFFEAC
  004A0E91   8955F4                 mov     [ebp-$0C], edx
  004A0E94   8945FC                 mov     [ebp-$04], eax

  * Reference to TFrmCreateChr instance
  |
  004A0E97   A10CC04A00             mov     eax, dword ptr [$004AC00C]
  004A0E9C   8B00                   mov     eax, [eax]

  * Reference to: CreateChr.Proc_0049C65C
  |
  004A0E9E   E8B9B7FFFF             call    0049C65C
  004A0EA3   84C0                   test    al, al
  004A0EA5   0F8441010000           jz      004A0FEC
  004A0EAB   33C0                   xor     eax, eax
  004A0EAD   8945F8                 mov     [ebp-$08], eax
  004A0EB0   33C0                   xor     eax, eax
  004A0EB2   55                     push    ebp

  * Possible String Reference to: 'ÈF&ˆˇÎÏÉ}¯'
  |
  004A0EB3   68C90F4A00             push    $004A0FC9

  ***** TRY
  |
  004A0EB8   64FF30                 push    dword ptr fs:[eax]
  004A0EBB   648920                 mov     fs:[eax], esp

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0EBE   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0EC3   8B00                   mov     eax, [eax]

  * Reference to: Unit_0048B6D0.Proc_0048B928
  |
  004A0EC5   E85EAAFEFF             call    0048B928
  004A0ECA   84C0                   test    al, al
  004A0ECC   0F84DD000000           jz      004A0FAF

  * Reference to TFrmCreateChr instance
  |
  004A0ED2   A10CC04A00             mov     eax, dword ptr [$004AC00C]
  004A0ED7   8B00                   mov     eax, [eax]

  * Reference to field TFrmCreateChr.OFFS_02E8
  |
  004A0ED9   8B90E8020000           mov     edx, [eax+$02E8]

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0EDF   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0EE4   8B00                   mov     eax, [eax]

  * Reference to: Unit_0048B6D0.Proc_0048C5B0
  |
  004A0EE6   E8C5B6FEFF             call    0048C5B0
  004A0EEB   83F802                 cmp     eax, +$02
  004A0EEE   0F8DB4000000           jnl     004A0FA8
  004A0EF4   8D85ACFEFFFF           lea     eax, [ebp+$FFFFFEAC]

  * Reference to TFrmCreateChr instance
  |
  004A0EFA   8B150CC04A00           mov     edx, [$004AC00C]
  004A0F00   8B12                   mov     edx, [edx]

  * Reference to field TFrmCreateChr.OFFS_02EC
  |
  004A0F02   8B92EC020000           mov     edx, [edx+$02EC]
  004A0F08   B9FF000000             mov     ecx, $000000FF

  * Reference to: system.@LStrToString;
  |
  004A0F0D   E84A2FF6FF             call    00403E5C
  004A0F12   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]
  004A0F18   8D45C8                 lea     eax, [ebp-$38]
  004A0F1B   B10E                   mov     cl, $0E

  * Reference to: system.@PStrNCpy;
  |
  004A0F1D   E8CE1AF6FF             call    004029F0
  004A0F22   8D85ACFEFFFF           lea     eax, [ebp+$FFFFFEAC]

  * Reference to TFrmCreateChr instance
  |
  004A0F28   8B150CC04A00           mov     edx, [$004AC00C]
  004A0F2E   8B12                   mov     edx, [edx]

  * Reference to field TFrmCreateChr.OFFS_02E8
  |
  004A0F30   8B92E8020000           mov     edx, [edx+$02E8]
  004A0F36   B9FF000000             mov     ecx, $000000FF

  * Reference to: system.@LStrToString;
  |
  004A0F3B   E81C2FF6FF             call    00403E5C
  004A0F40   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]
  004A0F46   8D45D7                 lea     eax, [ebp-$29]
  004A0F49   B10A                   mov     cl, $0A

  * Reference to: system.@PStrNCpy;
  |
  004A0F4B   E8A01AF6FF             call    004029F0
  004A0F50   C645E200               mov     byte ptr [ebp-$1E], $00
  004A0F54   C645EC00               mov     byte ptr [ebp-$14], $00
  004A0F58   8D85ACFEFFFF           lea     eax, [ebp+$FFFFFEAC]

  * Reference to TFrmCreateChr instance
  |
  004A0F5E   8B150CC04A00           mov     edx, [$004AC00C]
  004A0F64   8B12                   mov     edx, [edx]

  * Reference to field TFrmCreateChr.OFFS_02EC
  |
  004A0F66   8B92EC020000           mov     edx, [edx+$02EC]
  004A0F6C   B9FF000000             mov     ecx, $000000FF

  * Reference to: system.@LStrToString;
  |
  004A0F71   E8E62EF6FF             call    00403E5C
  004A0F76   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]
  004A0F7C   8D45B8                 lea     eax, [ebp-$48]
  004A0F7F   B10E                   mov     cl, $0E

  * Reference to: system.@PStrNCpy;
  |
  004A0F81   E86A1AF6FF             call    004029F0
  004A0F86   807DB800               cmp     byte ptr [ebp-$48], $00
  004A0F8A   7423                   jz      004A0FAF

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0F8C   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0F91   8B00                   mov     eax, [eax]
  004A0F93   8D55AC                 lea     edx, [ebp-$54]

  * Reference to: Unit_0048B6D0.Proc_0048C1F4
  |
  004A0F96   E859B2FEFF             call    0048C1F4
  004A0F9B   84C0                   test    al, al
  004A0F9D   7510                   jnz     004A0FAF
  004A0F9F   C745F802000000         mov     dword ptr [ebp-$08], $00000002
  004A0FA6   EB07                   jmp     004A0FAF
  004A0FA8   C745F803000000         mov     dword ptr [ebp-$08], $00000003
  004A0FAF   33C0                   xor     eax, eax
  004A0FB1   5A                     pop     edx
  004A0FB2   59                     pop     ecx
  004A0FB3   59                     pop     ecx
  004A0FB4   648910                 mov     fs:[eax], edx

  ****** FINALLY
  |

  * Possible String Reference to: 'É}¯'
  |
  004A0FB7   68D00F4A00             push    $004A0FD0

  * Reference to pointer to GlobalVar_004ADBD8
  |
  004A0FBC   A1B0C24A00             mov     eax, dword ptr [$004AC2B0]
  004A0FC1   8B00                   mov     eax, [eax]

  * Reference to: Unit_0048B6D0.Proc_0048BA24
  |
  004A0FC3   E85CAAFEFF             call    0048BA24
  004A0FC8   C3                     ret

  *)
end;

procedure TFrmIDHum._PROC_004A1025(Sender: TObject);
begin
  (*
  004A1025   8BEC                   mov     ebp, esp
  004A1027   33C0                   xor     eax, eax
  004A1029   55                     push    ebp

  * Possible String Reference to: 'È∆%ˆˇÎ¯]√ã¿É-§€J'
  |
  004A102A   6849104A00             push    $004A1049

  ***** TRY
  |
  004A102F   64FF30                 push    dword ptr fs:[eax]
  004A1032   648920                 mov     fs:[eax], esp
  004A1035   FF05A4DB4A00           inc     dword ptr [$004ADBA4]
  004A103B   33C0                   xor     eax, eax
  004A103D   5A                     pop     edx
  004A103E   59                     pop     ecx
  004A103F   59                     pop     ecx
  004A1040   648910                 mov     fs:[eax], edx

  ****** FINALLY
  |

  * Possible String Reference to: ']√ã¿É-§€J'
  |
  004A1043   6850104A00             push    $004A1050
  004A1048   C3                     ret


  * Reference to: system.@HandleFinally;
  |
  004A1049   E9C625F6FF             jmp     00403614
  004A104E   EBF8                   jmp     004A1048

  ****** END
  |
  004A1050   5D                     pop     ebp
  004A1051   C3                     ret

  *)
end;

procedure TFrmIDHum._PROC_004A1054(Sender: TObject);
begin
  (*
  004A1054   832DA4DB4A0001         sub     dword ptr [$004ADBA4], +$01
  004A105B   C3                     ret

  *)
end;







procedure TFrmIDHum.SpeedButtonEditDataClick(Sender: TObject);
var
  nRow, nIdx: Integer;
  sName: string;
  ChrRecord: THumDataInfo;
begin
  sName := '';
  nRow := ChrGrid.Row;
  if (nRow >= 1) and (ChrGrid.RowCount - 1 >= nRow) then
    sName := ChrGrid.Cells[1, nRow];
  if sName = '' then Exit;
  try
    if HumDataDB.OpenEx then begin
      nIdx := HumDataDB.Index(sName);
      if nIdx >= 0 then begin
        if HumDataDB.Get(nIdx, ChrRecord) >= 0 then begin
          frmEditRcd.m_nIdx := nIdx;
          frmEditRcd.m_ChrRcd := ChrRecord;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  frmEditRcd.Left := FrmIDHum.Left + 50;
  frmEditRcd.Top := FrmIDHum.Top + 50;
  frmEditRcd.Open;
end;

end.
