//
//  DetailLawfirmHeaderView.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-29.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLawfirmHeaderView.h"
#import "UIImageView+WebCache.h"
#import "EXPhotoViewer.h"
#import "ImageBox.h"

@implementation DetailLawfirmHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
- (void)awakeFromNib
{
   //self.frame = CGRectMake(0, 0, 320, 600);
}


- (void) configViewWithmainImage:(NSURL *)mainimageurl introimagelist:(NSArray *)imagelist Count:(NSNumber *)count adress:(NSString *)adress phone:(NSString *)phone netAdress:(NSString *)netadress fax:(NSString *)fax detailInfo: (NSString *)detailinfo
{
    [self.mainImg setImageWithURL:mainimageurl placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];

    self.scPhoto.pagingEnabled = NO;
    self.scPhoto.bounces = NO;
    self.scPhoto.showsHorizontalScrollIndicator = NO;
    self.scPhoto.showsVerticalScrollIndicator = NO;
    
    CGSize imagesize;
    
   if (imagelist.count < 3 && imagelist.count >0 )
    {
       imagesize = CGSizeMake(258.0/imagelist.count, self.scPhoto.frame.size.height);
    }
    else if (imagelist.count >=3)
    {
        imagesize = CGSizeMake(258.0/3, self.scPhoto.frame.size.height);
    }
    self.scPhoto.contentSize = CGSizeMake(imagesize.width*imagelist.count, imagesize.height);
    
    // Add images into scroll view
    for (int i=0; i<imagelist.count; i++)
    {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*imagesize.width+5, 0, imagesize.width-10,
        
        ImageBox *box = [[ImageBox alloc] initWithFrame:CGRectMake(i*imagesize.width+5, 0, imagesize.width-10, imagesize.height) image:nil delegate:nil needDeleteBtn:NO];
        [box.imgView setImageWithURL:[NSURL URLWithString:[imagelist objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];
        [self.scPhoto addSubview:box];
    }
 
 
    // Add images into scroll view
    
    
    self.lbCount.text = [NSString stringWithFormat:@"%d",[count integerValue]];
    self.lbAdress.text = adress;
    self.lbPhone.text = phone;
    self.lbNetAdress.text = netadress;
    self.lbFax.text = fax;
  //  [self.lbDetail removeFromSuperview];
   // self.lbDetail.numberOfLines = 0;
    self.lbDetail.text = @"";
    CGSize size = [self caculate:detailinfo];
    self.frame = CGRectMake(0, 0, 320,  (size.height > 25 ? 274:271)+size.height+10);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(83.0f,  (size.height > 25 ? 274:271), size.width,  (size.height > 25 ? size.height:25))];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.adjustsFontSizeToFitWidth = YES;
    label.text  = detailinfo;
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];

}

- (CGSize)caculate:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(217, 2000)
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}




- (IBAction)turntoLeft:(id)sender {
    
}

- (IBAction)turntoRight:(id)sender {
    
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
