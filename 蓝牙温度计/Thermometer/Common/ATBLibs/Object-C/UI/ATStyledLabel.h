//
//  ATStyledLabel.h
//  LearnPinyin
//
//  Created by HJC on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 有时会碰到一些文字显示需求， 
 比如 打球， 打字要红色，球要黑色，这个要普通的label拼接起来会很麻烦
 故定义了一种快速的写法
 首先，假设原来最开始颜色时黑色，通过textColor属性设置, 可以写成
 {push;color:red}打{pop}球
 其中{ }之间的就时格式控制, 多个格式之间可以用;分开，现在支持的格式空格如下
 
 push           --> 将当前属性保存，之后用pop恢复
 pop            --> 将之前保存的当前属性回复
 color:         --> 改变字体颜色
*/


@interface ATStyledLabel : UIView
{
@private
    UIFont*         _font;
    NSString*       _styledText;
    NSArray*        _framents;
    UIColor*        _textColor;
    CGSize          _suiableSize;
    UITextAlignment _textAlignment;
}
@property (nonatomic, retain)   UIFont*         font;
@property (nonatomic, retain)   NSString*       styledText;
@property (nonatomic, retain)   UIColor*        textColor;
@property (nonatomic, assign)   UITextAlignment textAlignment;

- (id) initWithStyledText:(NSString*)styledText 
                     font:(UIFont*)font;
- (id) init;
- (id) initWithFrame:(CGRect)frame;

@end
