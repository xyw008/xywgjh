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
    self.tabBar.backgroundImage = [UIImage imageNamed:@"Navigation_Under.png"];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Navigation_Under_Opt.png"];
    
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
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: HEXCOLOR(0X306CC5)} forState:UIControlStateSelected];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: HEXCOLOR(0X4F555F)} forState:UIControlStateNormal];
        
        NSString *title = nil;
        UIImage *normalImage = nil;
        UIImage *selectedImage = nil;
        
        switch (i)
        {
            case 0:
            {
                title = @"首页";
                
                normalImage = [UIImage imageNamed:@"tab_Home_Normal"];
                selectedImage = [UIImage imageNamed:@"tab_Home_Highlight"];
            }
                break;
            case 1:
            {
                title = @"搜索";
                
                normalImage = [UIImage imageNamed:@"tab_Search_Normal"];
                selectedImage = [UIImage imageNamed:@"tab_Search_Highlight"];
            }
                break;
            case 2:
            {
                title = @"我的法宝";
                
                normalImage = [UIImage imageNamed:@"tab_Fabao_Normal"];
                selectedImage = [UIImage imageNamed:@"tab_Fabao_Highlight"];
            }
                break;
            case 3:
            {
                title = @"更多";
                
                normalImage = [UIImage imageNamed:@"tab_Setting_Normal"];
                selectedImage = [UIImage imageNamed:@"tab_Setting_Highlight"];
            }
                break;
                
            default:
                break;
        }
        
        aItem.title = title;
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
