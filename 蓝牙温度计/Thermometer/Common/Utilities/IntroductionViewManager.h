//
//  IntroductionViewManager.h
//  offlineTemplate
//
//  Created by admin on 13-12-04.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBlurIntroductionView.h"

@interface IntroductionViewManager : NSObject <MYIntroductionDelegate>

/**
 * 方法描述: 显示欢迎页
 * 输入参数: localImgsSourceArray : 被展示图片名数组, superView : 承载欢迎页的视图
 * 返回值: BOOL
 * 创建人: 龚俊慧
 * 创建时间: 2013-12-04
 */
+ (void)showIntroductionViewWithImgSource:(NSArray *)localImgsSourceArray superView:(UIView *)superView;

@end
