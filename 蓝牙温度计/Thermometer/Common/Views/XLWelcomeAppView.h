//
//  WelcomeAppView.h
//  Vmei
//
//  Created by leo on 15/10/10.
//  Copyright © 2015年 com.vmei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^welcomeFinishCallBack)(NSInteger touchBtnIndex);

@interface XLWelcomeAppView : NSObject

@property (nonatomic,assign)BOOL                      isAboutType;//关于类型


/**
 *  欢迎图片
 *
 *  @param imageArray 本地图片数组
 */
+ (void)showWelcomeImage:(NSArray*)imageArray callBack:(welcomeFinishCallBack)callBack;


/**
 *  欢迎图片
 *
 *  @param imageArray 本地图片数组
 */
+ (XLWelcomeAppView*)showSuperView:(UIView*)superView
                     welcomeImage:(NSArray*)imageArray
                         callBack:(welcomeFinishCallBack)callBack;


- (void)removeSelf;



@end
