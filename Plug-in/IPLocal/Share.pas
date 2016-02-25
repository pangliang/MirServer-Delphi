unit Share;

interface
const
  sPlugName        = 'IP所在地区查询插件(2014/09/08)';
  sStartLoadPlug   = '加载IP所在地区查询插件成功...';
  sUnLoadPlug      = '卸载IP所在地区查询插件成功...';

  sIPFileName      ='.\IpList.db';
//设置本插件接管那些函数(数值设置0，1)
  HookDeCodeText    = 0; //文本配置信息解码函数
  HookSearchIPLocal = 1; //IP所在地查询函数


implementation

end.
