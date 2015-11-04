//
//  IntroductionViewManager.m
//  offlineTemplate
//
//  Created by admin on 13-12-04.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "IntroductionViewManager.h"
#import "AppDelegate.h"

static MYBlurIntroductionView *staticIntroductionView;

@interface IntroductionViewManager ()

@end

@implementation IntroductionViewManager

+ (void)showIntroductionViewWithImgSource:(NSArray *)localImgsSourceArray superView:(UIView *)superView
{
    if (superView && localImgsSourceArray && 0 != localImgsSourceArray.count)
    {
        NSMutableArray *totalPanelArray = [NSMutableArray arrayWithCapacity:localImgsSourceArray.count];
        
        for (int i = 0; i < localImgsSourceArray.count; i++)
        {
            MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) image:[UIImage imageNamed:[localImgsSourceArray objectAtIndex:i]]];
            
            [totalPanelArray addObject:panel];
            
            // 最后一张指引页,加上开始btn
            if (i == (localImgsSourceArray.count - 1))
            {
                InsertButtonWithType(panel, CGRectMake(10, SharedAppDelegate.window.boundsHeight / 2 - 70, SharedAppDelegate.window.boundsWidth - 10 * 2, 80), 1000, self, @selector(clickSkipBtn:), UIButtonTypeCustom);
            }
        }
        
        staticIntroductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        staticIntroductionView.delegate = self;
        staticIntroductionView.MasterScrollView.backgroundColor = [UIColor blackColor];
        // introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
        staticIntroductionView.LeftSkipButton.alpha = 0;
        staticIntroductionView.RightSkipButton.alpha = 0;
        staticIntroductionView.alpha = 0.0;
        
        [staticIntroductionView buildIntroductionWithPanels:totalPanelArray];
        
        [SharedAppDelegate.window addSubview:staticIntroductionView];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            staticIntroductionView.alpha = 1.0;
            
            [UIApplication sharedApplication].statusBarHidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

+ (void)clickSkipBtn:(id)sender
{
    [staticIntroductionView didPressSkipButton];
}

#pragma mark - MYIntroductionDelegate methods

+ (void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        introductionView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [introductionView removeFromSuperview];
    }];
}

@end
