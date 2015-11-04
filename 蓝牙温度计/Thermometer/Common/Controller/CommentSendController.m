//
//  CommentSendController.m
//  Sephome
//
//  Created by swift on 14/12/9.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "CommentSendController.h"
#import "PopupController.h"
#import "NetRequestManager.h"
#import "HPGrowingTextView.h"

@interface CommentSendController () <NetRequestDelegate>
{
    NSURL                       *_toSendUrl;
    SendCommentCompleteHandle   _completeHandle;
    PopupController             *_commentInputShowPop;
    UITextView                  *_inputTV;
}

@end

@implementation CommentSendController

DEF_SINGLETON(CommentSendController);

- (void)showCommentInputViewAndSendUrl:(NSURL *)url completeHandle:(SendCommentCompleteHandle)handle
{
    if (!_commentInputShowPop)
    {
        const CGFloat btnWidthAndHeight = 35.0;
        const CGFloat viewBetweenSpaceValue = 10.0;
        
        UIView *containerView = InsertView(nil, CGRectMake(0, 0, IPHONE_WIDTH, 200));
        containerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelBtn = InsertImageButton(containerView,
                                                CGRectZero,
                                                1000,
                                                [UIImage imageWithColor:[UIColor yellowColor] size:CGSizeMake(1, 1)],
                                                nil,
                                                self,
                                                @selector(clickCancelBtn:));
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(btnWidthAndHeight, btnWidthAndHeight));
            make.left.equalTo(containerView).with.offset(@(viewBetweenSpaceValue));
            make.top.equalTo(containerView).with.offset(@(viewBetweenSpaceValue));
        }];
        
        UIButton *sendBtn = InsertImageButton(containerView,
                                              CGRectZero,
                                              1002,
                                              [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)],
                                              nil,
                                              self,
                                              @selector(clickSendBtn:));
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(cancelBtn.mas_width);
            make.height.equalTo(cancelBtn.mas_height);
            make.right.equalTo(containerView).with.offset(@(-viewBetweenSpaceValue));
            make.top.equalTo(cancelBtn);
        }];
        
        UILabel *titleLabel = InsertLabel(containerView,
                                          CGRectZero,
                                          NSTextAlignmentCenter,
                                          @"写跟帖",
                                          SP15Font,
                                          [UIColor blackColor],
                                          NO);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancelBtn);
            make.height.equalTo(cancelBtn);
            make.left.equalTo(cancelBtn.mas_right).with.offset(@(viewBetweenSpaceValue));
            make.right.equalTo(sendBtn.mas_left).with.offset(@(-viewBetweenSpaceValue));
        }];
        
        // 输入控件
        /*
        HPGrowingTextView *inputTV = [[HPGrowingTextView alloc] init];
         */
        UITextView *inputTV = [[UITextView alloc] init];
        inputTV.font = SP14Font;
        inputTV.textColor = [UIColor blackColor];
        [inputTV addBorderToViewWitBorderColor:[UIColor grayColor] borderWidth:0.5];
        [containerView addSubview:inputTV];
        _inputTV = inputTV;
        [inputTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).with.offset(@(viewBetweenSpaceValue));
            make.right.equalTo(containerView).with.offset(@(-viewBetweenSpaceValue));
            make.top.equalTo(cancelBtn.mas_bottom).with.offset(@(viewBetweenSpaceValue));
            make.bottom.equalTo(containerView).with.offset(@(-viewBetweenSpaceValue));
        }];
        
        _commentInputShowPop = [[PopupController alloc] initWithContentView:containerView];
    }
    
    _toSendUrl = url;
    _completeHandle = [handle copy];
    
    [_commentInputShowPop showInView:[UIApplication sharedApplication].keyWindow
                        animatedType:PopAnimatedType_Input];
}

- (void)clickSendBtn:(UIButton *)sender
{
    [self sendCommentWithText:_inputTV.text];

    [_commentInputShowPop hide];
}

- (void)clickCancelBtn:(UIButton *)sender
{
    [_commentInputShowPop hide];
}

- (void)sendCommentWithText:(NSString *)text
{
    if ([text isAbsoluteValid])
    {
        [[NetRequestManager sharedInstance] sendRequest:_toSendUrl
                                           parameterDic:@{@"comment": text}
                                             requestTag:1000
                                               delegate:self
                                               userInfo:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"发送的内容不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (_completeHandle) _completeHandle(YES);

    _toSendUrl = nil;
    _completeHandle = nil;
    _inputTV.text = nil;
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    if (_completeHandle) _completeHandle(NO);
}

@end
