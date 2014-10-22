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

#define kBetweenSpace 5
#define kImageWidth (_scPhoto.width - kBetweenSpace*3)/4

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
    self.scPhoto.pagingEnabled = NO;
    self.scPhoto.bounces = NO;
    self.scPhoto.showsHorizontalScrollIndicator = NO;
    self.scPhoto.showsVerticalScrollIndicator = NO;
}

- (void) configViewWithmainImage:(NSURL *)mainimageurl introimagelist:(NSArray *)imagelist Count:(NSNumber *)count adress:(NSString *)adress phone:(NSString *)phone netAdress:(NSString *)netadress fax:(NSString *)fax detailInfo: (NSString *)detailinfo
{

    [self.mainImg setImageWithURL:mainimageurl placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];

    self.lbCount.text = [NSString stringWithFormat:@"%d",[count integerValue]];
    self.lbAdress.text = adress;
    self.lbPhone.text = phone;
    self.lbNetAdress.text = netadress;
    self.lbFax.text = fax;
    
    
    if ([imagelist isAbsoluteValid])
    {
        CGSize imagesize = CGSizeMake(kImageWidth, _scPhoto.height);
        self.scPhoto.contentSize = CGSizeMake((imagesize.width + kBetweenSpace)*imagelist.count - kBetweenSpace, imagesize.height);
//        self.scPhoto.contentSize = CGSizeMake((imagesize.width + kBetweenSpace)*10 - kBetweenSpace, imagesize.height);
        _scPhoto.backgroundColor = [UIColor clearColor];
        
        CGFloat startX = 0;
        for (int i=0; i<imagelist.count; i++)
        {
            ImageBox *box = [[ImageBox alloc] initWithFrame:CGRectMake(startX, 0, imagesize.width, imagesize.height) image:nil delegate:nil needDeleteBtn:NO];
            [box.imgView setImageWithURL:[NSURL URLWithString:[imagelist objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];
            [self.scPhoto addSubview:box];
            startX += box.width + kBetweenSpace;
        }
    }
    _leftBtn.hidden = imagelist.count > 3 ? NO:YES;
    _rightBtn.hidden = _leftBtn.hidden;
 
    NSString *newDetail = [NSString stringWithFormat:@"                %@",detailinfo];
    
    CGSize size = [newDetail sizeWithFont:_lbDetail.font constrainedToWidth:_lbDetail.width];
    _lbDetail.height = MAX(size.height, 17);
    _lbDetail.text = newDetail;
    
    self.height = CGRectGetMaxY(_lbDetail.frame) + 10;
    [self layoutSubviews];
    
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




- (IBAction)turntoLeft:(id)sender
{

    CGPoint point = CGPointMake(0, 0);
    if (_scPhoto.contentOffset.x > 0 && _scPhoto.contentOffset.x < kImageWidth + kBetweenSpace)
    {
        
    }
    if (_scPhoto.contentOffset.x >= kImageWidth + kBetweenSpace)
    {
        point = CGPointMake(_scPhoto.contentOffset.x - kImageWidth - kBetweenSpace, _scPhoto.contentOffset.y);
    }
    [_scPhoto setContentOffset:point animated:YES];
}

- (IBAction)turntoRight:(id)sender
{
    CGPoint point = CGPointMake(_scPhoto.contentOffset.x + kImageWidth + kBetweenSpace, _scPhoto.contentOffset.y);
    if (_scPhoto.contentOffset.x > _scPhoto.contentSize.width - kImageWidth)
    {
        if (_scPhoto.contentOffset.x < _scPhoto.contentSize.width)
        {
            point = CGPointMake(_scPhoto.contentOffset.x - kImageWidth, _scPhoto.contentOffset.y);
        }
    }
    [_scPhoto setContentOffset:point animated:YES];
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
