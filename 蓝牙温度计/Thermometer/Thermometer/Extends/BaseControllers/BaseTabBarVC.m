//
//  BaseTabBarVC.m
//  Sephome
//
//  Created by swift on 14/11/10.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BaseTabBarVC.h"

@interface BaseTabBarVC ()

@end

@implementation BaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    [self setTabBarItemsInfo];
}

// 设置标签栏的属性
- (void)setTabBarItemsInfo
{
    self.tabBar.backgroundImage = [UIImage imageWithColor:HEXCOLOR(0X3C3A47) size:CGSizeMake(IPHONE_WIDTH, 50)];
    self.tabBar.selectionIndicatorImage = [UIImage imageWithColor:HEXCOLOR(0X3C3A47) size:CGSizeMake(IPHONE_WIDTH, 50)];
    
    if (IOS7)
    {
        // 去除IOS7系统tabbar顶部的那条线
        UIImage *tabBarTopBackgroundImg = [[UIImage alloc] init];
        [[UITabBar appearance] setShadowImage:tabBarTopBackgroundImg];
        /*
        [[UITabBar appearance] setBackgroundImage:tabBarTopBackgroundImg];
         */
    }
    
    NSArray *items = [self.tabBar items];
    
    for (int i = 0; i < items.count; i++)
    {
        UITabBarItem *aItem = [items objectAtIndex:i];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateSelected];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithWhite:0 alpha:0.5]} forState:UIControlStateNormal];
        
        NSString *title = nil;
        UIImage *normalImage = nil;
        UIImage *selectedImage = nil;
        
        switch (i)
        {
            case 0:
            {
                title = @"体温";
                
                normalImage = [UIImage imageNamed:@"toolbar_icon_bodytemperature_n"];
                selectedImage = [UIImage imageNamed:@"toolbar_icon_bodytemperature_f"];
            }
                break;
            case 1:
            {
                title = @"心率";
                
                normalImage = [UIImage imageNamed:@"toolbar_icon_heartrate_n"];
                selectedImage = [UIImage imageNamed:@"toolbar_icon_heartrate_f"];
            }
                break;
            case 2:
            {
                title = @"血压";
                
                normalImage = [UIImage imageNamed:@"toolbar_icon_bloodpressure_n"];
                selectedImage = [UIImage imageNamed:@"toolbar_icon_bloodpressure_f"];
            }
                break;
            case 3:
            {
                title = @"血氧";
                
                normalImage = [UIImage imageNamed:@"toolbar_icon_o2_n"];
                selectedImage = [UIImage imageNamed:@"toolbar_icon_o2_f"];
            }
                break;
            case 4:
            {
                title = @"记步";
                
                normalImage = [UIImage imageNamed:@"toolbar_icon_walk_n"];
                selectedImage = [UIImage imageNamed:@"toolbar_icon_walk_f"];
            }
                break;
            default:
                break;
        }
        
        aItem.title = title;
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
        if ([viewController isKindOfClass:[UINavigationController class]])
        {
            ((UINavigationController *)viewController).topViewController.title = title;
        }
        else
        {
            viewController.title = title;
        }
        
        if (IOS7)
        {
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            [aItem setImage:normalImage];
            [aItem setSelectedImage:selectedImage];
        }
        else
        {
            [aItem setFinishedSelectedImage:normalImage
                withFinishedUnselectedImage:selectedImage];
        }
    }
}

@end
