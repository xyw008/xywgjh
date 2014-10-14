//
//  AppUIElement.h
//  MaxDoodle
//
//  Created by gnef_jp on 13-1-3.
//  Copyright (c) 2013年 appletree. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark- ActivityIndicatorView
@interface ActivityIndicatorView : UIView
{
    CALayer*    _rotationLayer;
}

@property (retain,   nonatomic) UIColor*        color;
@property (readonly, nonatomic) BOOL            isAnimating;

- (void) startAnimating;
- (void) stopAnimating;

@end


#pragma mark- LineSpacingTextView
@interface LineSpacingTextView : UITextView

@end