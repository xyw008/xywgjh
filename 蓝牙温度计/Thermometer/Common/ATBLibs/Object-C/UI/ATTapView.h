//
//  UIBlackTapView.h
//  KidsPainting
//
//  Created by HJC on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ATTapView;
@protocol ATTapViewDelegate <NSObject>
@optional
- (void) ATTapViewDidTouchBegin:(ATTapView*)aView;
- (void) ATTapViewDidTap:(ATTapView*)aView;
- (void) ATTapViewDidTouchEnded:(ATTapView*)aView;
@end



@interface ATTapView : UIView 
{
@private
//    id<ATTapViewDelegate>   _delegate;
    BOOL                    _ignoreTap;
    UIEvent*                _touchEvent;
}
@property (nonatomic, retain)   UIEvent*    touchEvent;
@property (nonatomic, assign)   id          delegate;
@property (nonatomic, assign)   BOOL        ignoreTap;

@end
