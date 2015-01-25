//
//  CustomBMKAnnotationView.m
//  zmt
//
//  Created by apple on 14-2-25.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import "CustomBMKAnnotationView.h"

@implementation CustomBMKAnnotationView
{
    UILabel *titleLabel;
}

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        titleLabel = InsertLabel(self, CGRectMake(4, 4, self.boundsWidth - 8, self.boundsHeight - 8), NSTextAlignmentCenter, nil, [UIFont boldSystemFontOfSize:9], [UIColor whiteColor], NO);
        titleLabel.numberOfLines = 2;
//        titleLabel.backgroundColor = [UIColor greenColor];
//        titleLabel.text = @"香洲百货";
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (NSString *)title
{
    return titleLabel.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
