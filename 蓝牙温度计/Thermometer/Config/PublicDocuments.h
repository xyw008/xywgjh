
// 分享
#define Share_Content_Img_key                           @"share_Content_Img_key"
#define Share_Content_Text_key                          @"share_Text_Img_key"

// 网络
#define UserDefault_JustWifiKey                         @"userDefault_JustWifiKey"
#define UserDefault_NoPictureModeKey                    @"userDefault_NoPictureModeKey"

// 轮询
#define UserDefault_RemoteNotificationServiceTimeKey    @"userDefault_RemoteNotificationServiceTimeKey"
#define UserDefault_RemoteNotificationNewsIdKey         @"userDefault_RemoteNotificationNewsIdKey"
#define UserDefault_RemoteNotificationNewsTimeKey       @"userDefault_RemoteNotificationNewsTimeKey"
#define UserDefault_RemoteNotificationSurveyTimeKey     @"userDefault_RemoteNotificationSurveyTimeKey"

#define UserDefault_IsNotFirstLoadAnswerQuestionVCKey   @"UserDefault_IsNotFirstLoadAnswerQuestionVCKey" // 是否第一次登陆答题界面

#define TABBAR_HEIGHT           49
#define IIDeckViewLeftSize      60 * (IPHONE_WIDTH / 320)

// 字体大小
#define NavTitleFontSize        20.0

// 字体大小
#define SP18Font                            [UIFont systemFontOfSize:18.0]      // ...
#define SP16Font                            [UIFont systemFontOfSize:16.0]      // ...
#define SP15Font                            [UIFont systemFontOfSize:15.0]      // ...
#define SP14Font                            [UIFont systemFontOfSize:14.0]      // TAB的主标题
#define SP13Font                            [UIFont systemFontOfSize:13.0]      // ...
#define SP12Font                            [UIFont systemFontOfSize:12.0]      // ...
#define SP10Font                            [UIFont systemFontOfSize:10.0]      // TAB的子标题

// 常规文字颜色
#define Common_BlackColor                   HEXCOLOR(0X000000)                  // 黑色    适用范围:TAB的主标题
#define Common_GrayColor                    HEXCOLOR(0XBDBDBD)                  // 灰色    适用范围:TAB的主标题
#define Common_LiteGrayColor                HEXCOLOR(0X969A9B)                  // 浅灰色  适用范围:...
#define Common_InkBlackColor                HEXCOLOR(0X545D61)                  // 墨黑色  适用范围:TAB未选中状态的主标题
#define Common_InkGreenColor                HEXCOLOR(0X7A97A1)                  // 墨绿色  适用范围:TAB的子标题
#define Common_LiteBlueColor                HEXCOLOR(0X169DCE)                  // 浅蓝色  适用范围:TAB选中状态的主标题
#define Common_OrangeColor                  HEXCOLOR(0XFA9D4D)                  // 橙黄色  适用范围:产品详情页 价格、选择按钮选中边框、购物车按钮等的颜色
#define Common_GreenColor                   HEXCOLOR(0X12B98E)                  // 绿色
#define Common_BlueColor                    HEXCOLOR(0X38B6FF)                  // 蓝色




#define PageBackgroundColor                 HEXCOLOR(0XF7F7F7)                  // 灰蓝色  viewController的背景色
#define CellSeparatorColor                  HEXCOLOR(0XD7D7D7)                  // 灰白色  tabViewCell的间隔线

#define Common_LiteWhiteGrayColor           HEXCOLOR(0XB5C4C9)                  // 浅灰白色 适用范围:订单详情页面 小标题、时间、购买件数

#define Common_ThemeColor                   HEXCOLOR(0X2D2C37)                  // 换了LOGO后的主题颜色
#define Common_LiteBrownColor               HEXCOLOR(0X8E8F87)                  // 浅棕色，底部按钮文字未点中颜色

#define ThinLineWidth                       0.5                 // 细的线宽值
#define LineWidth                           1.0                 // 全局线宽值  适用范围:cell的分割线、视图边框线宽
#define CellSeparatorSpace                  10                  // 全局       tab中cell之间的分割距离

/// 登陆状态的错误码
#define NotLoginStatusErrorCode             -10001              // 登陆的状态.10000:已登录,正常状态, -10001:未登陆或者登陆session已过期

/// 刷新远程推送数字的间隔时间
#define RemoteNotificationIntervalTime      60 * 10             // 10分钟

// HUD显示文字
#define HUDAutoHideTypeShowTime             3.0                 // HUD自动隐藏模式显示的时间:2.5秒

// 基本动画时间
#define AnimationShowTime                   0.25                // 常见动画的持续时间:0.25秒



#define AlertTitle                      @"温馨提示"
#define Cancel                          LocalizedStr(soft_cancel)
#define Confirm                         LocalizedStr(soft_ok)

#define NoConnectionNetwork             LocalizedStr(open_network)
#define Loading                         @"加载中..."
#define LoadFailed                      @"加载失败"
#define SaveFailed                      @"保存失败"

#define OperationFailure                @"操作失败,请重试"
#define OperationSuccess                @"操作成功"

#define DeprecatedYourInputInfo         @"是否放弃您所输入的信息?"

#define NotLogin                        @"您还没有登录或者登录已过期,请登录"
#define NotRealNameCertification        @"您未实名认证,请先实名认证"
#define Email                           @"邮件"
#define Message                         @"短信"
#define SinaWeibo                       @"新浪微博"
#define TencentWeibo                    @"腾讯微博"

// 键盘的高度
#define  KeyboardHeight 252

// 字体
#define ArialBoldMT(ofSize)         [UIFont fontWithName:@"Arial-BoldMT" size:ofSize]               // ArialBoldMT字体
#define AmericanTypewriter_Bold     [UIFont fontWithName:@"AmericanTypewriter-Bold" size:25.0]

// 默认占位logo图片(大图)
#define kBigPreviewImage              [UIImage imageNamed:@"shangpinxiangqing_morentupian"]

//小得预览占位图片（logo）
#define kSmallPreviewImage                  [UIImage imageNamed:@"dingdanxiangqing_shangpibtupian_morentupian"]
