//
//  MainCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/4.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "MainCenterVC.h"
#import "TemperaturesShowView.h"

#define kBottomBtnStartTag 1000

@interface MainCenterVC ()
{
    UIImageView                 *_headIV;//头像
    TemperaturesShowView        *_temperaturesShowView;
}
@end

@implementation MainCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(presentLeftMenuViewController:)];
    
    
    
    [self initTemperaturesShowView];
    [self initBottomBtnsView];
    
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    
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
    _temperaturesShowView = [[TemperaturesShowView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, DpToPx(42) + DynamicWidthValue640(587))];
    [_temperaturesShowView setTemperature:0];
    [_temperaturesShowView keepAutoresizingInFull];
    [self.view addSubview:_temperaturesShowView];
}


- (void)initBottomBtnsView
{
    CGFloat startX = DpToPx(24)/2;
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_temperaturesShowView.frame), IPHONE_WIDTH - startX * 2, DpDynamicWidthValue640(118))];
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

#pragma mark - btn touch
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
