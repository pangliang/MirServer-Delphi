unit Grobal2;

interface
uses
  Windows;
const
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;
  GS_QUIT = 2000;
  SG_FORMHANDLE=1000;//服务器HANLD
  SG_STARTNOW=1001;  //正在启动服务器...
  SG_STARTOK=1002;   //启动完成...
type
  TDefaultMessage = record
    Recog: Integer;
    Ident: word;
    Param: word;
    Tag: word;
    Series: word;
  end;
  
implementation

end.
