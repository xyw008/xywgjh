//
//  UITableView+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by ll on 13-6-30.
//  Copyright (c) 2013年 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UITableView (SSToolkitAdditions)

- (NSIndexPath *)indexPathForRowContainingView:(UIView *)view;

@end
