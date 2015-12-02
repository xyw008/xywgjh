//
//  AboutVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/11.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AboutVC.h"
#import "PRPAlertView.h"
#import "XLWelcomeAppView.h"
#import "AppPropertiesInitialize.h"

@interface AboutVC ()
{
    XLWelcomeAppView            *_welcomeAppView;//第一次启动app
}
@property (weak, nonatomic) IBOutlet UIButton *updateVersionBtn;
@property (weak, nonatomic) IBOutlet UIButton *guideBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutVC

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"关于"];
}

- (void)configureViewsProperties
{
    _updateVersionBtn.backgroundColor = [UIColor clearColor];
    _guideBtn.backgroundColor = [UIColor clearColor];
    _followBtn.backgroundColor = [UIColor clearColor];
    
    [_updateVersionBtn addLineWithPosition:ViewDrawLinePostionType_Top
                                 lineColor:CellSeparatorColor
                                 lineWidth:ThinLineWidth];
    [_updateVersionBtn addLineWithPosition:ViewDrawLinePostionType_Bottom
                                 lineColor:CellSeparatorColor
                                 lineWidth:ThinLineWidth];
    [_guideBtn addLineWithPosition:ViewDrawLinePostionType_Bottom
                         lineColor:CellSeparatorColor
                         lineWidth:ThinLineWidth];
    [_followBtn addLineWithPosition:ViewDrawLinePostionType_Bottom
                          lineColor:CellSeparatorColor
                          lineWidth:ThinLineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    _versionLabel.text = [NSString stringWithFormat:@"V%@", APP_VERSION];
}

- (IBAction)clickOperationBtn:(UIButton *)sender {
    if (sender == _updateVersionBtn)
    {
        
    }
    else if (sender == _guideBtn)
    {
        [self hiddenNav:YES];
        NSArray *imageArray = @[@"lead_01.png",@"lead_02.png",@"lead_03.png"];
        WEAKSELF
        _welcomeAppView = [XLWelcomeAppView showSuperView:self.view welcomeImage:imageArray callBack:^(NSInteger touchBtnIndex){
            if (0 == touchBtnIndex)//注册
            {
                
                
            }
            else if(1 == touchBtnIndex)//确定
            {
                [weakSelf removeWelcomeAppView];
            }
            else if(2 == touchBtnIndex)//游客模式
            {
                
            }
        }];
        
        _welcomeAppView.isAboutType = YES;
    }
    else if (sender == _followBtn)
    {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        [paste setString:@"于氏医疗"];
        
        [PRPAlertView showWithTitle:nil
                            message:@"已复制于氏医疗微信号【于氏医疗】至剪切板"
                        buttonTitle:Confirm];
    }
}


- (void)hiddenNav:(BOOL)hidden
{
    self.navigationController.navigationBarHidden = hidden;
    [AppPropertiesInitialize setBackgroundColorToStatusBar:hidden ? HEXCOLOR(0X3C3A47) : Common_ThemeColor];
}

- (void)removeWelcomeAppView
{
    [_welcomeAppView removeSelf];
    _welcomeAppView = nil;
    [self hiddenNav:NO];
}


@end
