{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{                Design Editors                         }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_DsgnIntf;

interface

uses
  MSI_GUI,
  MSI_CPUUsage,

  Windows, Classes,
  {$IFDEF D6PLUS}
  DesignIntf, DesignEditors
  {$ELSE}
  DsgnIntf
  {$ENDIF}
  ;

type
  TMSI_AboutPropertyEditor = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TMSI_RefreshPropertyEditor = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TMSI_ComponentEditor = class(TComponentEditor)
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): String; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
  end;

procedure Register;

implementation

{$IFDEF D6PLUS}
resourcestring
  MSIC_Software_CategoryName = 'Software Information';
  MSIC_Hardware_CategoryName = 'Hardware Information';
  MSIC_Extra_CategoryName = 'Extra';
{$ENDIF}


procedure Register;
begin
  RegisterComponents('MiTeC',[TMCPUUsage]);
  RegisterComponents('MiTeC',[TMSystemInfo]);
  RegisterPropertyEditor(TypeInfo(string),TMSystemInfo,'_About',TMSI_AboutPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string),TMSystemInfo,'_Refresh',TMSI_RefreshPropertyEditor);
  RegisterComponentEditor(TMSystemInfo,TMSI_ComponentEditor);

{$IFDEF D6PLUS}
  RegisterPropertiesInCategory(MSIC_Extra_CategoryName,TMSystemInfo,
      ['_About',
       '_Refresh']);
  RegisterPropertiesInCategory(MSIC_Software_CategoryName,TMSystemInfo,
      ['Engines',
       'OS',
       'ProcessList',
       'Software',
       'Startup']);
  RegisterPropertiesInCategory(MSIC_Hardware_CategoryName,TMSystemInfo,
      ['APM',
       'CPU',
       'Devices',
       'Disk',
       'Display',
       'Machine',
       'Media',
       'Memory',
       'Monitor',
       'Network',
       'Printers',
       'Storage',
       'USB'
       ]);
{$ENDIF}
end;

{ TMSI_ComponentEditor }

procedure TMSI_ComponentEditor.Edit;
begin
  TMSystemInfo(Self.Component).ShowModalOverviewWithAbout;
end;

procedure TMSI_ComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: TMSystemInfo(Self.Component).Refresh;
    1: Edit;
  end;
end;

function TMSI_ComponentEditor.GetVerb(Index: Integer): String;
begin
  case Index of
    0: Result:='Refresh';
    1: Result:='System Overview...';
  else
    Result:=inherited GetVerb(Index-1);
  end;
end;

function TMSI_ComponentEditor.GetVerbCount: Integer;
begin
  Result:=inherited GetVerbCount+2;
end;

{ TMSI_AboutPropertyEditor }

procedure TMSI_AboutPropertyEditor.Edit;
begin
  TMSystemInfo(Self.GetComponent(0)).ShowModalOverviewWithAbout;
end;

function TMSI_AboutPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog, paReadOnly];
end;

{ TMSI_RefreshPropertyEditor }

procedure TMSI_RefreshPropertyEditor.Edit;
begin
  TMSystemInfo(Self.GetComponent(0)).Refresh;
end;

function TMSI_RefreshPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog, paReadOnly];
end;

end.
