//
//  ShareManager.m
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import "ShareManager.h"
#import "CoreData+MagicalRecord.h"
#import "InterfaceHUDManager.h"
#import "WXApi.h"

@implementation SharePlatformUserInfo

@end

////////////////////////////////////////////////////////////////////////////////

@interface ShareManager () <ISSShareViewDelegate, ISSViewDelegate>

@end

@implementation ShareManager

DEF_SINGLETON(ShareManager);

#pragma mark - custom methods

- (void)shareNewsWithContent:(NSString *)content title:(NSString *)title url:(NSString *)urlStr imageUrlStr:(NSString *)imageUrlStr sender:(id)sender
{
    /*
    // 定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,
                                                        ShareTypeWeixiTimeline,
                                                        ShareTypeWeixiFav, nil];
    */
    
    // 创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrlStr]
                                                title:title
                                                  url:urlStr
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    // 创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    /*
     id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
     allowCallback:YES
     authViewStyle:SSAuthViewStyleFullScreenPopup
     viewDelegate:self
     authManagerViewDelegate:self];
     // 在授权页面中添加关注官方微博
     [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
     nil]];
     */
    
    /*
     id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
     shareViewDelegate:self];
     */
    
    NSArray *shareList = nil;
    
    // 新浪分享的item
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:^{
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeSinaWeibo
                   authOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
            if (state == SSPublishContentStateSuccess)
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"分享成功"];
            }
            else if (state == SSPublishContentStateFail)
            {
                // NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                
                // 苹果审核规定:进行APP没有安装情况下的提示时不能提及APP的名字
                NSString *title = -22003 == [error errorCode] ? @"您还没有安装客户端,无法使用分享功能!" : [error errorDescription];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:title
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }];
    
    // 判断微信有没有安装,如果没有安装则不要在分享Action中显示Icon,不然点击了没反应会被Apple拒绝(其他需要跳转APP进行操作的都需要进行判断)
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                     nil];
    }
    else
    {
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     nil];
    }
    
    // 显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享此商品"
                                                          oneKeyShareList:nil
                                                           qqButtonHidden:YES
                                                    wxSessionButtonHidden:YES
                                                   wxTimelineButtonHidden:YES
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:self
                                                      friendsViewDelegate:self
                                                    picViewerViewDelegate:self]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"分享成功"];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    // NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    
                                    // 苹果审核规定:进行APP没有安装情况下的提示时不能提及APP的名字
                                    NSString *title = -22003 == [error errorCode] ? @"您还没有安装客户端,无法使用分享功能!" : [error errorDescription];
                                    
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:title
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles: nil];
                                    [alertView show];
                                }
                            }];
}

- (void)getUserInfoWithType:(ShareType)type completeHandle:(void (^)(id<ISSPlatformUser>, id<ICMErrorInfo>))handle
{
    [ShareSDK getUserInfoWithType:type
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
       if (result)
       {
           /*
           SharePlatformUserInfo *info = nil;
           
           switch (type)
           {
               case ShareTypeWeixiSession:
               {
                   info = [self fillWeixinUser:userInfo];
               }
                   break;
               case ShareTypeSinaWeibo:
               {
                   info = [self fillSinaWeiboUser:userInfo];
               }
                   break;
                   
               default:
                   break;
           }
           */
           
           if (handle) handle(userInfo, error);
       }
       else
       {
           // 苹果审核规定:进行APP没有安装情况下的提示时不能提及APP的名字
           NSString *title = -22003 == [error errorCode] ? @"您还没有安装客户端,无法使用第三方登录功能!" : [error errorDescription];
           
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:title
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles: nil];
           [alertView show];
           
           // 回调
           if (handle) handle(nil, error);
       }
    }];
}

#pragma mark - 获取平台用户数据后包装成自己的对象

// 微信
- (SharePlatformUserInfo *)fillWeixinUser:(id<ISSPlatformUser>)userInfo
{
    if (!userInfo) return nil;
    
    SharePlatformUserInfo *info = [[SharePlatformUserInfo alloc] init];
    
    for (NSString *keyName in [userInfo sourceData].allKeys)
    {
        id value = [[userInfo sourceData] safeObjectForKey:keyName];
        
        if (![value isKindOfClass:[NSString class]])
        {
            if ([value respondsToSelector:@selector(stringValue)])
            {
                value = [value stringValue];
            }
            else
            {
                value = @"";
            }
        }
        
        DLog(@"key = %@, value = %@", keyName, value);
        
        if ([keyName isEqualToString:@"openid"])
        {
            info.openid = value;
        }
        else if([keyName isEqualToString:@"headimgurl"])
        {
            info.headerImageUrlStr = value;
        }
        else if([keyName isEqualToString:@"nickname"])
        {
            info.nickname = value;
        }
    }
    
    return info;
}

// 新浪微博
- (SharePlatformUserInfo *)fillSinaWeiboUser:(id<ISSPlatformUser>)userInfo
{
    if (!userInfo) return nil;
    
    SharePlatformUserInfo *info = [[SharePlatformUserInfo alloc] init];
    
    for (NSString *keyName in [userInfo sourceData].allKeys)
    {
        id value = [[userInfo sourceData] safeObjectForKey:keyName];
        
        if (![value isKindOfClass:[NSString class]])
        {
            if ([value respondsToSelector:@selector(stringValue)])
            {
                value = [value stringValue];
            }
            else
            {
                value = @"";
            }
        }
        
        DLog(@"key = %@, value = %@", keyName, value);
        
        if ([keyName isEqualToString:@"idstr"])
        {
            info.openid = value;
        }
        else if([keyName isEqualToString:@"profile_image_url"])
        {
            info.headerImageUrlStr = value;
        }
        else if([keyName isEqualToString:@"screen_name"])
        {
            info.nickname = value;
        }
    }
    
    return info;
}

#pragma mark - ISSShareViewDelegate methods

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    // 修改分享编辑框的标题栏颜色
    if (IOS7)
    {
        viewController.navigationController.navigationBar.barTintColor = Common_ThemeColor;
    }
    else
    {
        viewController.navigationController.navigationBar.tintColor = Common_ThemeColor;
    }
}

@end
