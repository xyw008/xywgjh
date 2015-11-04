//
//  ShareManager.h
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSShareViewDelegate.h>
#import <ShareSDK/ISSViewDelegate.h>

@interface SharePlatformUserInfo : NSObject

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *headerImageUrlStr;
@property (nonatomic, copy) NSString *nickname;

@end

////////////////////////////////////////////////////////////////////////////////

@interface ShareManager : NSObject

AS_SINGLETON(ShareManager);

/**
 @ 方法描述    分享
 @ 输入参数    url: 分享的URL, imageUrlStr: 缩略图URL, sender: 触发方法的sender
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-28
 */
- (void)shareNewsWithContent:(NSString *)content
                       title:(NSString *)title
                         url:(NSString *)urlStr
                 imageUrlStr:(NSString *)imageUrlStr
                      sender:(id)sender;

/**
 @ 方法描述    获取第三方平台用户信息
 @ 输入参数    type: 平台类型
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-28
 */
- (void)getUserInfoWithType:(ShareType)type
             completeHandle:(void (^) (id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error))handle;

@end
