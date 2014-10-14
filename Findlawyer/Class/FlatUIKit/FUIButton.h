//
//  FUIButton.h
//  FlatUI
//
//  Created by Jack Flintermann on 5/7/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
typedef enum
{
    FUI_DrawLinePostionType_Top,
    FUI_DrawLinePostionType_Bottom,
    FUI_DrawLinePostionType_Left,
    FUI_DrawLinePostionType_Right,
    
}FUI_DrawLinePostionType;
*/

@interface FUIButton : UIButton

@property(nonatomic, strong, readwrite) UIColor *buttonColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *highlightedColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat shadowHeight UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/*
- (void)addLineWithPosition:(FUI_DrawLinePostionType)position  lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth;
 */

@end
