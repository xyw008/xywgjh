//
//  MainCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/4.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "MainCenterVC.h"
#import "TemperaturesShowView.h"
#import "PopupController.h"

#define kBottomBtnStartTag 1000

@interface MainCenterVC ()
{
    UIImageView                 *_headIV;//头像
    TemperaturesShowView        *_temperaturesShowView;
    
    UIView                      *_popBgView;//启动弹出的选择模式视图
}
@end

@implementation MainCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    
    
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(presentLeftMenuViewController:)];
    
    
    
    [self initTemperaturesShowView];
    [self initBottomBtnsView];
    
    //[self initPopView];
    
    CGFloat height = 38;
    _headIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    _headIV.backgroundColor = [UIColor redColor];
    ViewRadius(_headIV, height/2);
    self.navigationItem.titleView = _headIV;
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init method

- (void)initTemperaturesShowView
{
    _temperaturesShowView = [[TemperaturesShowView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,DynamicWidthValue640(587) + 55)];
    [_temperaturesShowView setTemperature:37];
    [self.view addSubview:_temperaturesShowView];
}


- (void)initBottomBtnsView
{
    CGFloat startX = DpToPx(24)/2;
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_temperaturesShowView.frame) + 38, IPHONE_WIDTH - startX * 2, DynamicWidthValue640(150))];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    NSArray *titleArray = @[@"预警",@"记录",@"佩戴方式",@"单位切换"];
    NSArray *imageArray = @[@"home_icon_alarm",@"home_icon_histroy",@"home_icon_wear_hand",@"home_icon_unit_c"];
    
    CGFloat btnWidth = (bottomBgView.width - startX * 5) / 4;
    
    UIButton *lastBtn;
    for (NSInteger i=0; i<titleArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = kBottomBtnStartTag + i;
        //[btn setTitle:titleArray[i] forState:UIControlStateNormal];
        //[btn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(bottomBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        //btn.titleLabel.font = [UIFont systemFontOfSize:10];
        //btn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.font = SP10Font;
        titleLB.tintColor = Common_BlackColor;
        titleLB.text = titleArray[i];
        titleLB.textAlignment = NSTextAlignmentCenter;
        
        [bottomBgView addSubview:titleLB];
        [bottomBgView addSubview:btn];
        
        if (lastBtn)
        {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_top);
                make.height.equalTo(lastBtn.mas_height);
                make.width.equalTo(lastBtn.mas_width);
                make.left.equalTo(lastBtn.mas_right).offset(startX);
            }];
        }
        else
        {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomBgView.mas_top).offset(DpToPx(12)/2);
                make.bottom.equalTo(bottomBgView.mas_bottom).offset(-(DpToPx(8)/2));
                make.left.equalTo(bottomBgView.mas_left).offset(startX);
                make.width.equalTo(btnWidth);
            }];
        }
        
        [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn.mas_bottom).offset(-12);
            make.left.equalTo(btn.mas_left);
            make.right.equalTo(btn.mas_right);
            make.height.equalTo(13);
        }];
        lastBtn = btn;
    }
}

//启动时候弹出选择模式视图
- (void)initPopView
{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    
    _popBgView = [[UIView alloc] initWithFrame:superView.bounds];
    _popBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [superView addSubview:_popBgView];

    
    UIView *contentView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 170)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = CGPointMake(_popBgView.center.x, _popBgView.center.y - 40);
    ViewRadius(contentView, 5);
    [_popBgView addSubview:contentView];
    
    UILabel *titleLB = [[UILabel alloc] initWithText:@"选择使用模式" font:SP15Font];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = Common_BlackColor;
    [contentView addSubview:titleLB];
    
    UIButton *bluetoothBtn = InsertButton(contentView, CGRectZero, 89877, @"蓝牙连接", self, @selector(connectBluetoothBtnTouch:));
    bluetoothBtn.titleLabel.font = SP14Font;
    bluetoothBtn.backgroundColor = Common_GreenColor;
    [bluetoothBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *monitorBtn = InsertButton(contentView, CGRectZero, 89878, @"远程监控", self, @selector(monitorBtnTouch:));
    monitorBtn.titleLabel.font = bluetoothBtn.titleLabel.font;
    monitorBtn.backgroundColor = Common_GreenColor;
    [monitorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(8);
        make.right.equalTo(contentView.mas_right).offset(-8);
        make.height.equalTo(20);
        make.centerY.equalTo(contentView.mas_centerY).offset(-20);
    }];
    
    [bluetoothBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.bottom.equalTo(contentView.mas_bottom).offset(-10);
        make.width.equalTo(105);
        make.height.equalTo(28);
    }];
    
    [monitorBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.bottom.equalTo(bluetoothBtn.mas_bottom);
        make.width.equalTo(bluetoothBtn.mas_width);
        make.height.equalTo(bluetoothBtn.mas_height);
    }];
    
}


#pragma mark - btn touch
- (void)connectBluetoothBtnTouch:(UIButton*)btn
{
    [_popBgView removeFromSuperview];
    _popBgView = nil;
}

- (void)monitorBtnTouch:(UIButton*)btn
{
    [_popBgView removeFromSuperview];
    _popBgView = nil;
}


- (void)bottomBtnTouch:(UIButton*)btn
{
    NSInteger index = btn.tag - kBottomBtnStartTag;
    
    switch (index)
    {
        case 0://预警
            
            break;
        case 1://记录
            
            break;
        case 2://佩戴方式
            
            break;
        case 3://单位切换
            
            break;
        default:
            break;
    }
}



@end
