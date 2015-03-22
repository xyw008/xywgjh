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
#import "LBSLawfirm.h"
#import "ShowImgFullScreenManager.h"

#define kBetweenSpace 10
#define kImageWidth (IPHONE_WIDTH - 2*10 - kBetweenSpace*3)/4
#define kLabelDefaultHeight 15

@interface DetailLawfirmHeaderView ()

@property (nonatomic,strong)IBOutlet UIView     *previewBgView;


@end

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
    
    _lbCount.textColor = Common_ThemeColor;
    _lbAdress.textColor = Common_ThemeColor;
    _lawfirmNameLB.textColor = Common_ThemeColor;
    
    _previewBgView.backgroundColor = Common_LiteWhiteGrayColor;
    _lbDetail.lineSpacing = 8;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageTap:)];
    [_mainImg addGestureRecognizer:tap];
    _mainImg.userInteractionEnabled = YES;
}

- (void) configViewWithLawfirmName:(NSString *)lawfirmName mainImage:(NSURL *)mainimageurl introimagelist:(NSArray *)imagelist Count:(NSNumber *)count adress:(NSString *)adress phone:(NSString *)phone netAdress:(NSString *)netadress fax:(NSString *)fax detailInfo:(NSString *)detailinfo
{
    CGSize nameSize = [lawfirmName sizeWithFont:_lawfirmNameLB.font constrainedToWidth:IPHONE_WIDTH - 10*2];
    CGFloat previewBgViewHeight = 10 + MAX(nameSize.height, 15) + 242;
    [_previewBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(previewBgViewHeight);
    }];
    _lawfirmNameLB.text = lawfirmName;
    

    [_mainImg gjh_setImageWithURL:mainimageurl placeholderImage:[UIImage imageNamed:@"defualtLawfirm"] imageShowStyle:ImageShowStyle_AutoResizing success:nil failure:nil];
//    [self.mainImg setImageWithURL:mainimageurl placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];

    CGFloat addressLBMaxWidth = IPHONE_WIDTH - 75 - 10;
    CGSize addressSize = [adress sizeWithFont:_lbAdress.font constrainedToWidth:addressLBMaxWidth];
    
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
            ImageBox *box = [[ImageBox alloc] initWithFrame:CGRectMake(startX, 0, imagesize.width, imagesize.height) image:nil delegate:self needDeleteBtn:NO];
            [box.imgView setImageWithURL:[NSURL URLWithString:[imagelist objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];
            [self.scPhoto addSubview:box];
            startX += box.width + kBetweenSpace;
        }
    }
    else
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_scPhoto
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:0]];
    }
    _leftBtn.hidden = imagelist.count > 3 ? NO:YES;
    _rightBtn.hidden = _leftBtn.hidden;
 
    NSString *newDetail = [NSString stringWithFormat:@"                %@",detailinfo];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:newDetail];;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, newDetail.length)];
    
//    CGSize size = [self caculate:newDetail];
    
    
    
//    CGSize size = [newDetail sizeWithFont:_lbDetail.font constrainedToWidth:addressLBMaxWidth];
//    [_lbDetail mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(MAX(size.height, 17));
//    }];
    
    [_lbDetail setText:newDetail];
    
//    CGSize size = [_lbDetail.attributedText boundingRectWithSize:CGSizeMake(IPHONE_WIDTH - 10*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:_lbDetail.attributedText withConstraints:CGSizeMake(IPHONE_WIDTH - 10*2, 10000000) limitedToNumberOfLines:0];
    
    self.height = previewBgViewHeight - _previewBgView.height + MAX(addressSize.height, kLabelDefaultHeight) - kLabelDefaultHeight + CGRectGetMinY(_lbDetail.frame) + MAX(size.height, kLabelDefaultHeight) + 10;
}

- (CGSize)caculate:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: _lbDetail.font};
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(IPHONE_WIDTH, 2000)
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


- (void)enlargeImageTap:(UIGestureRecognizer*)tap
{
    [EXPhotoViewer showImageFrom:_mainImg];
    //[ShowImgFullScreenManager showImgFullScreenWithImgUrls:@[_lawfirmItem]];
}

- (void)ImageBoxDidTouch:(ImageBox*)box
{
    //[ShowImgFullScreenManager showImgFullScreenWithImgUrls:_lawfirmItem.arBigImageUrlStrs];
}


@end
