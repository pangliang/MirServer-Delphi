unit PlugShare;

interface
uses
  Windows, Classes, EngineAPI, EngineType;
type
  TShopInfo = packed record
    btItemType: Byte; //物品类别
    StdItem: _TSTDITEM;  //物品属性
    Money: Integer;  //物品价值
    Opimgid: Integer; //动画开始图片ID
    Eximgid: Integer; //动画结束图片ID
    Itemcont: Integer;//限制数量
    sMemo1: array[0..13] of Char; //说明1
    sMemo2: array[0..49] of Char;//说明2
  end;
  pTShopInfo = ^TShopInfo;
var
  PlugHandle: Integer;
  PlugClass: string = 'Config';
  g_ShopItemList: Classes.TList;
implementation

end.

