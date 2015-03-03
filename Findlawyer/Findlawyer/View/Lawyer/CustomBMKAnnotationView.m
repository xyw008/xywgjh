//
//  CustomBMKAnnotationView.m
//  zmt
//
//  Created by apple on 14-2-25.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import "CustomBMKAnnotationView.h"

@interface CustomBMKAnnotationView ()
{
    UILabel *titleLabel;
}

@end

@implementation CustomBMKAnnotationView

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
        self.image = [UIImage imageNamed:@"map_Annotation"];
        
        titleLabel = InsertLabel(self, CGRectMake(4, 2, self.boundsWidth - 8, self.boundsHeight - 8), NSTextAlignmentCenter, nil, SP10Font, [UIColor whiteColor], NO);
        titleLabel.numberOfLines = 1;
        // titleLabel.backgroundColor = [UIColor greenColor];
        // titleLabel.text = @"香洲百货";
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

@end
