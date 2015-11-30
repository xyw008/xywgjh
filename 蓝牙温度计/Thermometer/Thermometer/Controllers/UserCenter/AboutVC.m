//
//  AboutVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/11.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UIButton *updateVersionBtn;
@property (weak, nonatomic) IBOutlet UIButton *guideBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

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
}

@end
