unit Share;

interface

resourcestring
  sPlugName = '飘飘网络脚本扩展插件';
  sStartLoadPlugSucced = '加载飘飘网络脚本扩展插件成功...';
  sStartLoadPlugFail = '加载飘飘网络脚本扩展插件失败...';
  sUnLoadPlug = '卸载飘飘网络扩展扩展插件成功...';
  sMsg  = '脚本注册联系：飘飘网络 QQ：240621028';
  sKey = '123456789';
  sIPFileName = '.\IpList.db';
  //设置本插件接管那些函数(数值设置0，1)
const
  HookDeCodeText = 1; //文本配置信息解码函数
  HookSearchIPLocal = 0; //IP所在地查询函数
var
  nCheckCode: Integer;
  sDecryKey: string;
  m_sRegisterName: string;
  nRegister: Integer;

implementation

end.

