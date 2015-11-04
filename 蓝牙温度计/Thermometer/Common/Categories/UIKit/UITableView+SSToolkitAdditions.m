//
//  UITableView+SSToolkitAdditions.m
//  SSToolkit
//
//  Created by ll on 13-6-30.
//  Copyright (c) 2013年 Sam Soffes. All rights reserved.
//

#import "UITableView+SSToolkitAdditions.h"

@implementation UITableView (SSToolkitAdditions)

- (NSIndexPath *)indexPathForRowContainingView:(UIView *)view {
    CGPoint correctedPoint = [view convertPoint:view.bounds.origin
                                         toView:self];
    return [self indexPathForRowAtPoint:correctedPoint];
}

@end
