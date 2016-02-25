{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{                Splash Screen                          }
{           version 8.0 for Delphi 5,6,7                  }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, Graphics, Controls,
  ExtCtrls, Forms;

type
  TscrMSI_Splash = class(TForm)
    Panel1: TPanel;            
    pInfo: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    lCopy: TLabel;
    lVersion: TLabel;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  scrMSI_Splash: TscrMSI_Splash;

implementation

uses MSI_Common;

{$R *.DFM}

procedure TscrMSI_Splash.FormCreate(Sender: TObject);
begin
  lVersion.Caption:=cVersion;
  lCopy.Caption:=cCopyright;
end;

end.
