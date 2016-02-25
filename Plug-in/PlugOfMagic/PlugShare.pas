unit PlugShare;

interface
uses
  Windows, Classes, EngineAPI, EngineType;
resourcestring
  sDBHeaderDesc = '自定义魔法数据库 程序制作：叶随风飘 QQ：240621028';
  m_sDBFileName='UserMagic.db';
type
  TDBHeader = packed record //Size 12
    sDesc: string[49]; //0x00    36
    nLastIndex: Integer; //0x5C
    nMagicCount: Integer; //0x68
    dCreateDate: TDateTime; //创建时间
  end;
  pTDBHeader = ^TDBHeader;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean;
    dCreateDate: TDateTime; //创建时间
  end;
  pTRecordHeader = ^TRecordHeader;

  TMagicConfig = packed record
    nSelMagicID: Integer; //使用某个魔法的效果
    nMagicCount: Integer;
    nAttackRange: Integer; //攻击范围
    nAttackWay: Integer; //攻击方式
    nNeed: Integer; //使用魔法需要物品
    boHP: Boolean;
    boMP: Boolean;
    boAC: Boolean;
    boMC: Boolean;
    boAbil: Boolean;
  end;
  pTMagicConfig = ^TMagicConfig;

  TMagicRcd = packed record
    RecordHeader: TRecordHeader;
    Magic: _TMAGIC;
    MagicConfig: TMagicConfig;
  end;
  pTMagicRcd = ^TMagicRcd;

var
  PlugHandle: Integer;
  PlugClass: string = 'Config';
  g_MagicList: Classes.TList;
  nSelMagicID: Integer;
  m_nFileHandle:Integer;
  m_Header:TDBHeader;
implementation

end.

