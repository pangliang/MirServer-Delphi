{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Media Detection Part                    }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Media;

interface

uses
  MSI_Common, SysUtils, Windows, Classes, MMSystem;

type
  TMedia = class(TPersistent)
  private
    FDevice,
    FAUX,
    FMIDIIn,
    FMixer,
    FWAVEOut,
    FWAVEIn,
    FMIDIOut: TStrings;
    FSCI: integer;
    FGPI: integer;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property GamePortIndex: integer read FGPI {$IFNDEF D6PLUS} write FGPI {$ENDIF} stored false;
    property SoundCardIndex: integer read FSCI {$IFNDEF D6PLUS} write FSCI {$ENDIF} stored False;
    property Devices :TStrings read FDevice {$IFNDEF D6PLUS} write FDevice {$ENDIF} stored false;
    property WAVEIn :TStrings read FWAVEIn {$IFNDEF D6PLUS} write FWAVEIn {$ENDIF} stored false;
    property WAVEOut :TStrings read FWAVEOut {$IFNDEF D6PLUS} write FWAVEOut {$ENDIF} stored false;
    property MIDIIn :TStrings read FMIDIIn {$IFNDEF D6PLUS} write FMIDIIn {$ENDIF} stored false;
    property MIDIOut :TStrings read FMIDIOut {$IFNDEF D6PLUS} write FMIDIOut {$ENDIF} stored false;
    property AUX :TStrings read FAUX {$IFNDEF D6PLUS} write FAUX {$ENDIF} stored false;
    property Mixer :TStrings read FMixer {$IFNDEF D6PLUS} write FMixer {$ENDIF} stored false;
  end;

implementation

uses Registry, MiTeC_Routines, MSI_Devices;

{ TMedia }

constructor TMedia.Create;
var
  i,j: Integer;
  s: string;
begin
  inherited;
  FDevice:=TStringList.Create;
  FWaveIn:=TStringList.Create;
  FWaveOut:=TStringList.Create;
  FMIDIIn:=TStringList.Create;
  FMIDIOut:=TStringList.Create;
  FMixer:=TStringList.Create;
  FAUX:=TStringList.Create;

  ExceptionModes:=[emExceptionStack];

  FSCI:=-1;
  FGPI:=-1;

  s:='';
  j:=-1;
  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do
      if Devices[i].DeviceClass=dcMEDIA then begin
        if Devices[i].FriendlyName='' then
          s:=Devices[i].Description
        else
          s:=Devices[i].FriendlyName;
        FDevice.Add(s);
        Inc(j);
        if pos('GAME',UpperCase(s))>0 then
          FGPI:=j
        else
          if (Devices[i].Location<>'') and (FSCI=-1) then
            FSCI:=j;
      end;
    Free;
  end;

end;

destructor TMedia.Destroy;
begin
  FDevice.Free;
  FWaveIn.Free;
  FWaveOut.Free;
  FMIDIIn.Free;
  FMIDIOut.Free;
  FMixer.Free;
  FAUX.Free;
  inherited;
end;

procedure TMedia.GetInfo;
var
  WOC :PWAVEOutCaps;
  WIC :PWAVEInCaps;
  MOC :PMIDIOutCaps;
  MIC :PMIDIInCaps;
  AXC :PAUXCaps;
  MXC :PMixerCaps;
  i,n: integer;
  s: string;
const
  rv = 'DriverDesc';
  rvMediaClass = 'MEDIA';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  new(WOC);
  n:=waveOutGetNumDevs;
  for i:=0 to n-1 do
    if WAVEOutGetDevCaps(i,WOC,SizeOf(TWAVEOutCaps))=MMSYSERR_NOERROR then begin
      s:=WOC^.szPname+' v'+inttostr(hi(WOC^.vDriverVersion))+'.'+inttostr(hi(WOC^.vDriverVersion));
      if FWaveOut.IndexOf(s)=-1 then
        FWAVEOut.Add(s);
    end;
  dispose(WOC);

  new(WIC);
  n:=waveInGetNumDevs;
  for i:=0 to n-1 do
    if WAVEinGetDevCaps(i,WIC,SizeOf(TWAVEInCaps))=MMSYSERR_NOERROR then begin
      s:=WIC^.szPname+' v'+inttostr(hi(WIC^.vDriverVersion))+'.'+inttostr(hi(WIC^.vDriverVersion));
      if FWaveIn.IndexOf(s)=-1 then
        FWAVEIn.Add(s);
    end;
  dispose(WIC);

  new(MOC);
  n:=midiOutGetNumDevs;
  for i:=0 to n-1 do
    if MIDIoutGetDevCaps(i,MOC,SizeOf(TMIDIOutCaps))=MMSYSERR_NOERROR then begin
      s:=MOC^.szPname+' v'+inttostr(hi(MOC^.vDriverVersion))+'.'+inttostr(hi(MOC^.vDriverVersion));
      if FMIDIOut.IndexOf(s)=-1 then
        FMIDIout.Add(s);
    end;
  dispose(MOC);

  new(MIC);
  n:=midiInGetNumDevs;
  for i:=0 to n-1 do
    if MIDIinGetDevCaps(i,MIC,SizeOf(TMIDIInCaps))=MMSYSERR_NOERROR then begin
      s:=MIC^.szPname+' v'+inttostr(hi(MIC^.vDriverVersion))+'.'+inttostr(hi(MIC^.vDriverVersion));
      if FMIDIIn.IndexOf(s)=-1 then
        FMIDIin.Add(s);
    end;
  dispose(MIC);

  new(AXC);
  n:=auxGetNumDevs;
  for i:=0 to n-1 do
    if AUXGetDevCaps(i,AXC,SizeOf(TAUXCaps))=MMSYSERR_NOERROR then begin
      s:=AXC^.szPname+' v'+inttostr(hi(AXC^.vDriverVersion))+'.'+inttostr(hi(AXC^.vDriverVersion));
      if FAUX.IndexOf(s)=-1 then
        FAUX.Add(s);
    end;
  dispose(AXC);

  new(MXC);
  n:=mixerGetNumDevs;
  for i:=0 to n-1 do
    if MixerGetDevCaps(i,MXC,SizeOf(TMixerCaps))=MMSYSERR_NOERROR then begin
      s:=MXC^.szPname+' v'+inttostr(hi(MXC^.vDriverVersion))+'.'+inttostr(hi(MXC^.vDriverVersion));
      if FMixer.IndexOf(s)=-1 then
        FMixer.Add(s);
    end;
  dispose(MXC);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TMedia.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Media classname="TMedia">');

    Add('<section name="Devices">');
    StringsToRep(Devices,'Count','Device',sl);
    Add('</section>');
    Add('<section name="WAVE">');
    StringsToRep(WaveIn,'WaveInCount','WaveIn',sl);
    StringsToRep(WaveOut,'WaveOutCount','WaveOut',sl);
    Add('</section>');
    Add('<section name="MIDI">');
    StringsToRep(MIDIIn,'MIDIInCount','MIDIIn',sl);
    StringsToRep(MIDIIn,'MIDIOutCount','MIDIOut',sl);
    Add('</section>');
    Add('<section name="AUX">');
    StringsToRep(AUX,'AUXCount','AUX',sl);
    Add('</section>');
    Add('<section name="Mixer">');
    StringsToRep(Mixer,'MixerCount','Mixer',sl);
    Add('</section>');

        Add('</Media>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TMedia.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.
