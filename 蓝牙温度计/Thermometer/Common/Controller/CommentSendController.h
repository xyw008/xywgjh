//
//  CommentSendController.h
//  Sephome
//
//  Created by swift on 14/12/9.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SendCommentCompleteHandle) (BOOL isSendSuccess);

@interface CommentSendController : NSObject

AS_SINGLETON(CommentSendController);

/**
 @ 方法描述    显示评论输入界面,完成输入后发送评论
 @ 输入参数    url: 发送评论的URL
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-12-10
 */
- (void)showCommentInputViewAndSendUrl:(NSURL *)url completeHandle:(SendCommentCompleteHandle)handle;

@end
