//
//  Network.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-11.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetAction.h"

@interface Network : NSObject

@property (strong, nonatomic) NSMutableDictionary *actionQueue;

+ (Network *)sharedNetwork;

+ (BOOL)isEnableNetwork;
+ (BOOL)isEnableWifi;
+ (BOOL)isEnable3G;
- (BOOL)isRightMobile:(NSString *)mobile;

- (void)create;
- (void)destroy;
- (void)enterForeground;
- (void)enterBackground;

// action
- (BOOL)addAction:(NetAction *)action;
- (BOOL)removeActionForKey:(NSString *)key;
- (BOOL)isDoingActionForKey:(NSString *)key;
- (void)cancelAllAction;
- (NetAction *)actionForKey:(NSString *)key;
// 在准备执行一个网络请求时都会调用该方法进行一次检查操作，比如检查网络是否连接，是否正在执行等等。type: 0为sever 1为web
- (NetReturnType)checkWithActionKey:(NSString *)key type:(NSInteger)type;

//- (NetReturnType)SearchLawFirmWithKey:(NSInteger)Index AndSearchType:(SearchType) searchtype completion:(CompletionBlock)completion;
- (NetReturnType)loadlawfirmInfoWithID:(NSInteger)lawfirmID completion:(CompletionBlock)completion;
- (NetReturnType)loadlawyerInfoWithID:(NSInteger)lawyerID completion:(CompletionBlock)completion;
- (NetReturnType)loadArticleTypestWithID:(NSInteger)lawyerID completion:(CompletionBlock)completion;
- (NetReturnType)loadArticleListWithLawyerID:(NSInteger)lawyerID  typeID:(NSInteger)artypeid completion:(CompletionBlock)completion;
- (NetReturnType)loadArticleInforWithID:(NSInteger)articleid completion:(CompletionBlock)completion;

@end
