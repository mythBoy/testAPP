//
// 定义 宏定义Color  及 相关字体
// 请与 定义后 添加注释  某一模块 某一功能 某标题 或 某详情
// 定义可是为  #define 模块_某界面_具体内容  如重复使用 请添加多个使用注释
// 例   #define weiliao_shouye_biaoti  [UIColor ...]   //用于 微聊 首页 标题   and  群聊首页标题 .....
#define weiliao_shouye_biaoti [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1]//例




#define AllBtnColor [UIColor  colorWithHexString:@"#ec0e0f"] //所有红色Button的颜色
#define AllBtnCornerRadius 4.0      //上面Button的cornerRadius
#define TitleColor RGB(254, 0, 0)   //按钮字颜色

#define GrayColor RGB(190,190,190)  //灰色
#define AllBtnUpColor RGB(198, 57, 57)  //红色未点击深色BTN

#define LeftRedColor RGB(196, 58, 61)  //左侧栏红色

#define LeftBarButtonFrame CGRectMake(0, 7, 10, 19) // 返回按钮frame



#define HuiTiaoHeight 40   // 灰色菜单条高度
#define Menu_Font 14.0     // 菜单字号
#define AllMenuFont 12.0   // 二级菜单的字号

//新更换的右上角图标 统一frame 方便以后适配 李坡17.3.30
#define RightButtonW    22  //右上角按钮宽 lp
#define RightButtonH    33  //右上角按钮宽 lp
#define RightButtonLeft    37  //右上角按钮距离右侧距离 lp
#define RightButtonTop    (44-RightButtonH)/2.0  //右上角按钮宽 lp

//定义所有公司企业版的公司ID
//100--中国国际期货
//101--中期集团
#define AppSchemes @{@"100": @"cifco.100",@"101":@"cifco.101"}//所有公司id对应的AppScheme





//-------------------------------------------------------****************统一规范格式的宏定义*************----------------------------------------/
#pragma mark 添加宏定义请写清楚作用 位置不要乱放


//特定字体  上导航颜色字体
#define   NavTitleFont    [UIFont  systemFontOfSize:18]
#define   NavTitleColor    [UIColor  colorWithHexString:@"#ffffff"]
//上导航控件  颜色字体
#define   NavBtnFont    [UIFont  boldSystemFontOfSize:15]
#define   NavBtnColor    [UIColor  colorWithHexString:@"#ffffff"]
//连接文字颜色
#define   httpTextColor    [UIColor  colorWithHexString:@"#3c6f9c"]

//朋友圈列表用户昵称名字列表
#define   FriendNickNameTextColor    [UIColor  colorWithHexString:@"#3c6f9c"]
//影视圈的使用的统一红色
#define   YINGSHIQUNREDCOLOR         [UIColor  colorWithHexString:@"#f45460"]
//研究院使用导航栏
#define   YANJIUYUANNAVBLUECOLOR      [UIColor  colorWithHexString:@"#5473ff"]
//研究院优化使用导航栏
#define   YANJIUYUANNAVPURPLECOLOR      [UIColor  colorWithHexString:@"#5778fc"]

//研究院优化使用文字颜色
#define   YANJIUYUANTEXTORANGECOLOR      [UIColor  colorWithHexString:@"#e84228"]
#define   ZHONGCHOUTEXTORANGECOLOR        [UIColor colorWithHexString:@"5778fc"]

//OA系统统一导航色
#define   OANAVBARCOLOR               [UIColor  colorWithHexString:@"#ea051a"]

#pragma mark 非加粗
#define   TextSize10    [UIFont  systemFontOfSize:10]
#define   TextSize11    [UIFont  systemFontOfSize:11]
#define   TextSize12    [UIFont  systemFontOfSize:12]
#define   TextSize13    [UIFont  systemFontOfSize:13]
#define   TextSize14    [UIFont  systemFontOfSize:14]
#define   TextSize15    [UIFont  systemFontOfSize:15]
#define   TextSize16    [UIFont  systemFontOfSize:16]
#define   TextSize17    [UIFont  systemFontOfSize:17]
#define   TextSize18    [UIFont  systemFontOfSize:18]
#define   TextSize19    [UIFont  systemFontOfSize:19]
#define   TextSize20    [UIFont  systemFontOfSize:20]
#define   TextSize21    [UIFont  systemFontOfSize:21]
#define   TextSize22    [UIFont  systemFontOfSize:22]
#define   TextSize23    [UIFont  systemFontOfSize:23]
#define   TextSize24    [UIFont  systemFontOfSize:24]
#define   TextSize25    [UIFont  systemFontOfSize:25]
#define   TextSize26    [UIFont  systemFontOfSize:26]
#define   TextSize27    [UIFont  systemFontOfSize:27]
#define   TextSize28    [UIFont  systemFontOfSize:28]
#define   TextSize30    [UIFont  systemFontOfSize:30]
#pragma mark 加粗字体
#define   TextSize10_B    [UIFont  boldSystemFontOfSize:10]
#define   TextSize11_B    [UIFont  boldSystemFontOfSize:11]
#define   TextSize12_B    [UIFont  boldSystemFontOfSize:12]
#define   TextSize13_B    [UIFont  boldSystemFontOfSize:13]
#define   TextSize14_B    [UIFont  boldSystemFontOfSize:14]
#define   TextSize15_B    [UIFont  boldSystemFontOfSize:15]
#define   TextSize16_B    [UIFont  boldSystemFontOfSize:16]
#define   TextSize17_B    [UIFont  boldSystemFontOfSize:17]
#define   TextSize18_B    [UIFont  boldSystemFontOfSize:18]
#define   TextSize19_B    [UIFont  boldSystemFontOfSize:19]
#define   TextSize20_B    [UIFont  boldSystemFontOfSize:20]
#define   TextSize21_B    [UIFont  boldSystemFontOfSize:21]
#define   TextSize22_B    [UIFont  boldSystemFontOfSize:22]
#define   TextSize23_B    [UIFont  boldSystemFontOfSize:23]
#define   TextSize24_B    [UIFont  boldSystemFontOfSize:24]
#define   TextSize25_B    [UIFont  boldSystemFontOfSize:25]
#define   TextSize26_B    [UIFont  boldSystemFontOfSize:26]
#define   TextSize27_B    [UIFont  boldSystemFontOfSize:27]
#define   TextSize28_B    [UIFont  boldSystemFontOfSize:28]

//字体适配 已iPhone6为基准 add by lll

#pragma mark 非加粗
#define   TextSize10_6    [UIFont  rewriteSystemFontOfSize6:10]
#define   TextSize11_6    [UIFont  rewriteSystemFontOfSize6:11]  //常用的G3 W3 S3 H3 R3号字
#define   TextSize12_6    [UIFont  rewriteSystemFontOfSize6:12]
#define   TextSize13_6    [UIFont  rewriteSystemFontOfSize6:13]  //常用的G2 W2 S2 H2 R2号字
#define   TextSize14_6    [UIFont  rewriteSystemFontOfSize6:14]  //常用的G4 W4 S4 H4 R4号字
#define   TextSize15_6    [UIFont  rewriteSystemFontOfSize6:15]  //常用的G1 W1 S1 H1 R1号字
#define   TextSize15_5_6    [UIFont  rewriteSystemFontOfSize6:15.5]  
#define   TextSize16_6    [UIFont  rewriteSystemFontOfSize6:16]
#define   TextSize17_6    [UIFont  rewriteSystemFontOfSize6:17]
#define   TextSize18_6    [UIFont  rewriteSystemFontOfSize6:18]
#define   TextSize19_6    [UIFont  rewriteSystemFontOfSize6:19]
#define   TextSize20_6    [UIFont  rewriteSystemFontOfSize6:20]
#define   TextSize21_6    [UIFont  rewriteSystemFontOfSize6:21]
#define   TextSize22_6    [UIFont  rewriteSystemFontOfSize6:22]
#define   TextSize23_6    [UIFont  rewriteSystemFontOfSize6:23]
#define   TextSize24_6    [UIFont  rewriteSystemFontOfSize6:24]
#define   TextSize25_6    [UIFont  rewriteSystemFontOfSize6:25]
#define   TextSize26_6    [UIFont  rewriteSystemFontOfSize6:26]
#define   TextSize27_6    [UIFont  rewriteSystemFontOfSize6:27]
#define   TextSize28_6    [UIFont  rewriteSystemFontOfSize6:28]
#define   TextSize30_6    [UIFont  rewriteSystemFontOfSize6:30]
#define   TextSize60_6    [UIFont  rewriteSystemFontOfSize6:60]
//颜色宏定义
#define   GuiFanColor(ColrStr)    [YYUtil  getGuiFanColor:ColrStr]



#pragma mark 加粗字体
#define   TextSize10_B_6    [UIFont  rewriteBolderSystemFontOfSize6:10]
#define   TextSize11_B_6    [UIFont  rewriteBolderSystemFontOfSize6:11]
#define   TextSize12_B_6    [UIFont  rewriteBolderSystemFontOfSize6:12]
#define   TextSize13_B_6    [UIFont  rewriteBolderSystemFontOfSize6:13]
#define   TextSize14_B_6    [UIFont  rewriteBolderSystemFontOfSize6:14]
#define   TextSize15_B_6    [UIFont  rewriteBolderSystemFontOfSize6:15]
#define   TextSize16_B_6    [UIFont  rewriteBolderSystemFontOfSize6:16]
#define   TextSize17_B_6    [UIFont  rewriteBolderSystemFontOfSize6:17]
#define   TextSize18_B_6    [UIFont  rewriteBolderSystemFontOfSize6:18]
#define   TextSize19_B_6    [UIFont  rewriteBolderSystemFontOfSize6:19]
#define   TextSize20_B_6    [UIFont  rewriteBolderSystemFontOfSize6:20]
#define   TextSize21_B_6    [UIFont  rewriteBolderSystemFontOfSize6:21]
#define   TextSize22_B_6    [UIFont  rewriteBolderSystemFontOfSize6:22]
#define   TextSize23_B_6    [UIFont  rewriteBolderSystemFontOfSize6:23]
#define   TextSize24_B_6    [UIFont  rewriteBolderSystemFontOfSize6:24]
#define   TextSize25_B_6    [UIFont  rewriteBolderSystemFontOfSize6:25]
#define   TextSize26_B_6    [UIFont  rewriteBolderSystemFontOfSize6:26]
#define   TextSize27_B_6    [UIFont  rewriteBolderSystemFontOfSize6:27]
#define   TextSize28_B_6    [UIFont  rewriteBolderSystemFontOfSize6:28]



#pragma mark 文字颜色
/** 纯白_按钮、标题文字 */
#define  TitleImportantColor            [UIColor  colorWithHexString:@"#ffffff"]
/** 深黑_标题、正文重要性文字 */
#define  TextBlackColor                 [UIColor  colorWithHexString:@"#000000"]
/** 浅灰_黑色背景时用 */
#define  TextBlackColorOld                 [UIColor  colorWithHexString:@"#3c3c3c"]
/** 深灰_辅助、默认状态文字 */
#define  TextGrayColor                  [UIColor  colorWithHexString:@"#828282"]
/** 浅灰_失效、提示性文字 */
#define  TextLightGrayColor             [UIColor  colorWithHexString:@"#444444"]
/** 红色_选中、按钮、提示性文字 */
#define  TextRedColor                  [UIColor  colorWithHexString:@"#ec0e0f"]
/** 红色_选中、按钮、提示性文字 */
#define  TextBlueColor                  [UIColor  colorWithHexString:@"#3c6f9c"]
/** 浅黑_按钮、标题文字 */
#define  TextLightBlack                 [UIColor  colorWithHexString:@"#646464"]
/** 深灰_分时线框内线条 */
#define  LineGrayColor                  [UIColor  colorWithHexString:@"#9a9a9a"]
/** L1 颜色 */
#define  LineOneColor                   [UIColor  colorWithHexString:@"#b4b4b4"]
/** L2 颜色 */
#define  lineColorL2             [UIColor  colorWithHexString:@"#cccccc"]
/** L3 颜色 */
#define  BorderColor              [UIColor  colorWithHexString:@"#e6e6e6"]


#define  TitleTextColor                 RGB(60,60,60)//灰黑色标题    by  gf
#define  LightTextColor                 RGB(130,130,130)//浅灰色文字 by  gf
#define  RedTextColor                   RGB(236,14,15)//红色文字    by  gf
#define  PartingLineColor               RGB(212,214,223)//分割线颜色 by  gf
#define  RedBtnColor                       RGB(233, 74, 53)//红色按钮常态 by  gf
#define  LightGrayBtnColor                 RGB(210,210,210)//灰色按钮失效 by  gf
#define  LightRedTextColor             [UIColor  colorWithHexString:@"#ec0000"]//浅红
#define  LightGrayBackViewColor        [UIColor  colorWithHexString:@"#eeeeee"]//浅灰
#define  LightGrayTextColor            [UIColor  colorWithHexString:@"#444444"]//浅灰
#define  OrangeTextColor            [UIColor  colorWithHexString:@"#fe8500"]//橙色
#define  GrayTextColor              [UIColor  colorWithHexString:@"#444444"]//灰色字
#define  GreenTextColor            [UIColor  colorWithHexString:@"#1dc925"]//绿色字
#define  P2PRedTextColor            [UIColor  colorWithHexString:@"#ea051a"]//红色字
#define  AssetRedTextColor          [UIColor  colorWithHexString:@"#f23030"]//红色字
#define  LightGrayBackGroundViewColor      RGB(238, 239, 243)//
#define  P2PNavigationBarBackViewColor     [UIColor  colorWithHexString:@"#ea051a"]
#define  LightBlueTextColor      [UIColor  colorWithHexString:@"#2e83d3"]//浅蓝
#define  LightkBackGroundColor      [UIColor  colorWithHexString:@"#F5F5F5"]//深黑
#define  TitleGreenTextColor      [UIColor  colorWithHexString:@"#00bf5f"]//标题绿







#pragma mark 股票模块儿所有颜色
#define stockDarkBlack       [UIColor  colorWithHexString:@"#000000"]  //纯黑
#define stockGray            [UIColor  colorWithHexString:@"#444444"]  //辅助文字
#define stocklightGray       [UIColor  colorWithHexString:@"#9a9a9a"]  //表格线颜色
#define stockKuanFenGeLine   [UIColor  colorWithHexString:@"#eeeff3"]  //加宽分割线
#define stockBiaoFenGeLine   [UIColor  colorWithHexString:@"#d4d6df"]   //列表分割线
#define stockGreenColor      [UIColor  colorWithHexString:@"#008800"]  //行情跌 绿  0 136 0
#define stockRedColor        [UIColor  colorWithHexString:@"#ea051a"]  //行情涨 红  234 5 26
#define stockSoldColor       [UIColor  colorWithHexString:@"#2e81e2"]  //卖出， 交易赔
#define stockMA5Color        [UIColor  colorWithHexString:@"#444444"]  //MA5颜色     @"66,66,66"
#define stockMA10Color       [UIColor  colorWithHexString:@"#9219fb"]  //MA10颜色    @"146,25,251"
#define stockMA20Color       [UIColor  colorWithHexString:@"#fe8500"]  //MA20颜色    @"254,133,0"
#define stockMA30Color       [UIColor  colorWithHexString:@"#0c169a"]  //MA30颜色    @"12,22,154"
#define stockButtonColor     [UIColor  colorWithHexString:@"#d2d2d2"]  //小button背景颜色


#pragma mark  Icon 图标 背景颜色
/** 纯白_颜色背景上所用图标 */
#define  BackIconWhiteColor                 [UIColor  colorWithHexString:@"#ffffff"]
/** 浅灰_颜色背景上所用图标 */
#define  BackIconGrayColor                  [UIColor  colorWithHexString:@"#828282"]
/** 浅灰_颜色背景上所用图标 */
#define  BackIconLightGrayColor             [UIColor  colorWithHexString:@"#d2d2d2"]
/** 橙色_颜色背景上所用图标 */
#define  BackIconOrangeColor                [UIColor  colorWithHexString:@"#fe8500"]



#pragma mark 系统颜色
/** 1主色调   红色 */
#define  ProJRedColor                [UIColor  colorWithHexString:@"#c63939"]
/** 2辅助色  深红 */
#define  ProJRedDarkColor            [UIColor  colorWithHexString:@"#8f1f24"]
/** 3辅助色  鲜红 */
#define  ProJRedLightColor            [UIColor  colorWithHexString:@"#ec0e0f"]
/** 4辅助色  橙红色 */
#define  ProJOrangeRedColor            [UIColor  colorWithHexString:@"#e94a35"]
/** 4辅助色  绿色 */
#define  ProJGreenColor            [UIColor  colorWithHexString:@"#1dc925"]
/** 4辅助色  搜素按钮背景色 */
#define  ProJSearchBackColor           [UIColor  colorWithHexString:@"#f4f4f4"]
/** 4辅助色 黑色 */
#define  ProJBlackClolor          [UIColor  colorWithHexString:@"#000000"]


/** 5.辅助  蓝色 */
#define  ProJBlueColor            [UIColor  colorWithHexString:@"#d0e5f7"]
/** 6.辅助  深蓝 */
#define  ProJBlueDarkColor            [UIColor  colorWithHexString:@"3c6f9c"]
/** 7.辅助 橙色 */
#define  ProJOrangeColor            [UIColor  colorWithHexString:@"fe8500"]
/** 8.辅助 无色*/
#define  ProJkClearColor            [UIColor  clearColor]//无色
/** 9.辅助 新加44444颜色*/
#define  ProJNewFourColor            [UIColor  colorWithHexString:@"#444444"]
/** 10.辅助 新加666666颜色*/
#define  ProJNewSixColor            [UIColor  colorWithHexString:@"#666666"]

#pragma mark 背景用色
/** 纯白_内页、对方对话框 */
#define  BackViewWhiteColor            [UIColor  colorWithHexString:@"#ffffff"]
/** 浅灰_搜索、对话界面 */
#define  BackViewGrayLightColor            [UIColor  colorWithHexString:@"eeeff3"]
/** 浅蓝_我方对话界面 */
#define  BackViewBlueColor            [UIColor  colorWithHexString:@"d0e5f7"]
/** 橙色 */
#define BackViewOrangeColor         [UIColor colorWithHexString:@"fc7f00"]

/** 按钮不可交互背景色 */
#define NOUserInteractionColor         [UIColor colorWithHexString:@"d2d2d2"]
/** 列表分割线 */
#define  CellSepColor            [UIColor  colorWithHexString:@"d4d6df"]//列表分割线
/** 顶部，底部栏分割 */
#define  ViewSepColor            [UIColor  colorWithHexString:@"c6c9d4"]//顶部，底部栏分割线
/** 导航栏分割线 */
#define  NavViewSepColor            [UIColor  colorWithHexString:@"b4b4b4"]//导航栏分割线

/** 期货页面 分割线 */
#define  ViewSepColorF            [UIColor  colorWithHexString:@"#969696"]//分割线
/** 期货页面 背景色 */
#define  BackViewGrayLightColorF            [UIColor  colorWithHexString:@"#c7c7c7"]//背景色
/** 期货我的页面 背景色  and  VS31版首页背景色 */
#define  BackViewGrayLightColorFM            [UIColor  colorWithHexString:@"#f0f2f5"]//背景色

/**进度完成颜色 */
#define  yuanHuanColor            [UIColor  colorWithHexString:@"00dddd"]//顶部，底部栏分割线

/**
 *  所有的列表的section背景颜色
 *
 *  @输入参数 font 二进制色值
 *
 *  @返回值 颜色
 */
#define  TableViewHeadBackcolor            [UIColor  colorWithHexString:@"eeeff3"]

/**
 *   所有的列表的section标题颜色
 *
 *  @输入参数 font 二进制色值
 *
 *  @返回值 颜色
 */
#define  TableViewHeadTitleColor            [UIColor  colorWithHexString:@"#828282"]


/** 所有switch的高度 */
#define allSwitchHeight 40
#define allSwitchFont  TextSize15
#define allSwitchBackColor  [UIColor  colorWithHexString:@"f4f4f4"]
//红条高度
#define allSwitchRedLineHeight 1
//分割线高度
#define allSwitchGapLineHeight 15
//分割线颜色
#define allSwitchGapLineColor  ViewSepColor

//各种字号对应的label高度
#define kLabelHeightWithFont(font) [@"按条件查找" sizeWithFont:font].height;
#define kLabelWidthWithFontText(font,text) [text sizeWithFont:font].width;
