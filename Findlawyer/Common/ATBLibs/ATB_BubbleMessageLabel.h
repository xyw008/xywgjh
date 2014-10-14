//
//  StrikeThroughLabel.h
//  StrikeThroughLabelExample
//
//  Created by Scott Hodgin on 12/14/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	BubbleMessageStyleOutgoing = 0,
	BubbleMessageStyleIncoming = 1
} BubbleMessageStyle;

@interface ATB_BubbleMessageLabel : UILabel

- (id)initWithFrame:(CGRect)frame text:(NSString *)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor bubbleMessageStyle:(BubbleMessageStyle)style;

+ (float)labelHeightForText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width minHeight:(float)minHeight;

+ (float)labelHeightForText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width minHeight:(float)minHeight netImageIdsArray:(NSArray *)netImageIdsArray horizontalImageCount:(int)horizontalImageCount;

@end
