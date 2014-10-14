
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
#define IIDeckViewLeftSize      40

// 字体大小
#define NavTitleFontSize        20.0

// 字体大小
#define SP18Font                            [UIFont systemFontOfSize:18.0]      // ...
#define SP16Font                            [UIFont systemFontOfSize:16.0]      // ...
#define SP15Font                            [UIFont systemFontOfSize:15.0]      // ...
#define SP14Font                            [UIFont systemFontOfSize:14.0]      // TAB的主标题
#define SP12Font                            [UIFont systemFontOfSize:12.0]      // ...
#define SP10Font                            [UIFont systemFontOfSize:10.0]      // TAB的子标题

// 常规文字颜色
#define Common_LiteGrayColor                HEXCOLOR(0X969A9B)                  // 浅灰色  适用范围:...
#define Common_InkBlackColor                HEXCOLOR(0X545D61)                  // 墨黑色  适用范围:TAB未选中状态的主标题
#define Common_InkGreenColor                HEXCOLOR(0X7A97A1)                  // 墨绿色  适用范围:TAB的子标题
#define Common_LiteBlueColor                HEXCOLOR(0X169DCE)                  // 浅蓝色  适用范围:TAB选中状态的主标题
#define Common_OrangeColor                  HEXCOLOR(0XFF8C00)                  // 橙黄色  适用范围:产品详情页 价格、选择按钮选中边框、购物车按钮等的颜色

#define PageBackgroundColor                 HEXCOLOR(0XE8EEF0)                  // 灰蓝色  viewController的背景色
#define CellSeparatorColor                  HEXCOLOR(0XC7D2D6)                  // 灰白色  tabViewCell的间隔线

#define Common_LiteWhiteGrayColor           HEXCOLOR(0XB5C4C9)                  // 浅灰白色 适用范围:订单详情页面 小标题、时间、购买件数

#define Common_ThemeBrownColor              HEXCOLOR(0X76823B)                  // 换了LOGO后的主题颜色
#define Common_LiteBrownColor               HEXCOLOR(0X8E8F87)                  // 浅棕色，底部按钮文字未点中颜色

#define LineWidth                           0.5                 // 全局线宽值  适用范围:cell的分割线、视图边框线宽
#define CellSeparatorSpace                  10                  // 全局       tab中cell之间的分割距离

/// 登陆状态的错误码
#define NotLoginStatusErrorCode             -10001              // 登陆的状态.10000:已登录,正常状态, -10001:未登陆或者登陆session已过期

/// 刷新远程推送数字的间隔时间
#define RemoteNotificationIntervalTime      60 * 10             // 10分钟

// HUD显示文字
#define HUDAutoHideTypeShowTime             2.5                 // HUD自动隐藏模式显示的时间:2.5秒

// 基本动画时间
#define AnimationShowTime                   0.25                // 常见动画的持续时间:0.25秒



#define AlertTitle                      @"温馨提示"
#define Cancel                          @"取消"
#define Confirm                         @"确定"

#define NoConnectionNetwork             @"没有网络连接,请设置后重试"
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
