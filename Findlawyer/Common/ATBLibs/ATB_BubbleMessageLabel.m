//
//  StrikeThroughLabel.m
//  StrikeThroughLabelExample
//
//  Created by Scott Hodgin on 12/14/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "ATB_BubbleMessageLabel.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
//#define kPaddingBottom 8.0f
#define kPaddingBottom 4.0f
//#define kBubblePaddingRight 35.0f
#define kBubblePaddingRight 35.0f

#define BetweenSubviewsSpace 10 // 控件与控件之间的间隙

@interface ATB_BubbleMessageLabel ()

@property (nonatomic,assign) BubbleMessageStyle bubbleStyle;
@property (nonatomic,strong) UIImage *incomingBackground;
@property (nonatomic,strong) UIImage *outgoingBackground;

@end

@implementation ATB_BubbleMessageLabel

@synthesize bubbleStyle;
@synthesize incomingBackground;
@synthesize outgoingBackground;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor bubbleMessageStyle:(BubbleMessageStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bubbleStyle = style;
        
        if (style == BubbleMessageStyleIncoming)
            self.textAlignment = NSTextAlignmentLeft;
        else
            self.textAlignment = NSTextAlignmentRight;
        
        self.text = text;
        self.font = textFont;
        self.textColor = textColor;
        self.numberOfLines = 0;
        
        /*
        self.incomingBackground = [[UIImage imageNamed:@"messageBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        self.outgoingBackground = [[UIImage imageNamed:@"messageBubbleBlue.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
         */
        
        self.incomingBackground = [[UIImage imageNamed:@"messageBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:20];
        self.outgoingBackground = [[UIImage imageNamed:@"messageBubbleBlue.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return self;
}

- (void)dealloc
{
    self.incomingBackground = nil;
    self.outgoingBackground = nil;
    
    [super dealloc];
}

- (void)drawTextInRect:(CGRect)rect
{
    //画气泡
    UIImage *image = (self.bubbleStyle == BubbleMessageStyleIncoming) ? self.incomingBackground : self.outgoingBackground;

    CGSize bubbleSize = [self bubbleSizeForText:self.text];
    /*
	CGRect bubbleFrame = CGRectMake(((self.bubbleStyle == BubbleMessageStyleOutgoing) ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
     */
    
    CGRect bubbleFrame = CGRectMake(((self.bubbleStyle == BubbleMessageStyleOutgoing) ? self.frame.size.width - bubbleSize.width : 0.0f), 0.0f, bubbleSize.width, self.bounds.size.height);
    
    [image drawInRect:bubbleFrame];
    
	//画文字
	CGSize textSize = [self textSizeForText:self.text];
    
	CGFloat textX = (CGFloat)image.leftCapWidth - 3.0f + ((self.bubbleStyle == BubbleMessageStyleOutgoing) ? bubbleFrame.origin.x : 0.0f);
    
    /*
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + kMarginTop,
                                  textSize.width,
                                  textSize.height);
     */
    
    CGRect textFrame = CGRectMake(textX,
                                  BetweenSubviewsSpace,
                                  textSize.width,
                                  textSize.height);
    
    [super drawTextInRect:textFrame];
    
    /*
     [self.text drawInRect:textFrame
     withFont:self.font
     lineBreakMode:NSLineBreakByWordWrapping
     alignment:(self.bubbleStyle == BubbleMessageStyleOutgoing) ? NSTextAlignmentRight : NSTextAlignmentLeft];
     */
}

- (CGSize)bubbleSizeForText:(NSString *)text
{
	CGSize textSize = [self textSizeForText:text];
    /*
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
     */
    
    return CGSizeMake(textSize.width + kBubblePaddingRight, self.bounds.size.height);
}

- (CGSize)textSizeForText:(NSString *)text
{
    return [[self class] textSizeForText:text font:self.font constrainedToWidth:self.bounds.size.width];
}

+ (CGSize)textSizeForText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(width - kBubblePaddingRight, 8000) lineBreakMode:NSLineBreakByWordWrapping];
}

// 计算label气泡的宽度
- (float)bubbleWidthWithText:(NSString *)text netImageIdsArray:(NSArray *)imgIdsArray horizontalImageCount:(int)horizontalImageCount
{
    // 文字所占的宽度
    CGSize bubbleSize = [self bubbleSizeForText:self.text];
    
    if (!imgIdsArray || 0 == imgIdsArray.count)
        return bubbleSize.width;
    
    // 图片所占的宽度
    if (imgIdsArray.count >= horizontalImageCount)
        return self.bounds.size.width;
    else
    {
        float onePieceImgWidth = (self.bounds.size.width - kBubblePaddingRight) / horizontalImageCount;

        float allPieceImgWidth = onePieceImgWidth * imgIdsArray.count;
        
        if (allPieceImgWidth >= bubbleSize.width)
            return allPieceImgWidth;
        else
            return bubbleSize.width;
    }
}

+ (float)labelHeightForText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width minHeight:(float)minHeight
{
    return [self labelHeightForText:text font:font constrainedToWidth:width minHeight:minHeight netImageIdsArray:nil horizontalImageCount:0];
}

+ (float)labelHeightForText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width minHeight:(float)minHeight netImageIdsArray:(NSArray *)netImageIdsArray horizontalImageCount:(int)horizontalImageCount
{
    CGSize labelSize = [self textSizeForText:text font:font constrainedToWidth:width];
    
    if ((labelSize.height + BetweenSubviewsSpace * 2) < minHeight)
        labelSize.height = minHeight;
    else
        labelSize.height += (BetweenSubviewsSpace * 2);
    
    return labelSize.height;
    
    
    
    /*
    // 计算图片的高度
    if (!netImageIdsArray || 0 == netImageIdsArray.count)
        return labelSize.height;
    
    float onePieceImgWidth = ((width - kBubblePaddingRight - (horizontalImageCount + 1) * BetweenSubviewsSpace)) / horizontalImageCount;

    if (netImageIdsArray.count <= horizontalImageCount)
        return onePieceImgWidth;
    else
    {
        float curFrameOriginY = currentView.frameOrigin.y + currentView.boundsHeight + SubViewsBetweenSpace / 2;
        
        int iMaxCount; // 总共有多少行
        int kMaxCount ; // 最后一行的btn数量
        if (0 == netImageIdsArray.count % horizontalImageCount)
        {
            iMaxCount = netImageIdsArray.count / horizontalImageCount;
            kMaxCount = horizontalImageCount;
        }
        else
        {
            iMaxCount = netImageIdsArray.count / horizontalImageCount + 1;
            kMaxCount = netImageIdsArray.count % horizontalImageCount;
        }
        
        int tempBtnTag = 1000; // 接着上一个button打tag
        
        // 行的循环
        for (int i = 0; i < iMaxCount; i++)
        {
            // 列的循环
            if ((iMaxCount - 1) != i) // 不是最后一行
            {
                for (int k = 0; k < horizontalImageCount; k++)
                {
                    NSNumber *imgId = [netImageIdsArray objectAtIndex:tempBtnTag - 1000];
                    
                    UIButton *tempBtn = InsertImageButton(self, CGRectMake(k * (BtnWidth + BetweenHorizontalBtnAndBtnSpace) + BetweenHorizontalBtnAndBtnSpace, i * (BtnHeight + LabelHeight + BetweenVerticalBtnAndLabelSpace) + curFrameOriginY, BtnWidth, BtnHeight), tempBtnTag, nil, nil, self, @selector(clickPlatformBtn:));
                    currentView = tempBtn;
                    
                    // 中间显示图片的那个小Btn
                    UIButton *centerBtn = InsertButtonWithType(tempBtn, tempBtn.bounds, 1000, nil, NULL, UIButtonTypeCustom);
                    centerBtn.userInteractionEnabled = NO;
                    [centerBtn setBackgroundImageWithImageId:imgId storeTableType:WebImageStoreTableFileLittle placeholderImage:[UIImage imageNamed:@"Unify_Image_w1.png"] options:WebImageDownload isRoundedRect:NO roundedRectSize:CGSizeMake(0, 0) resize:YES];
                    
                    tempBtnTag++;
                }
            }
            else
            {
                for (int k = 0; k < kMaxCount; k++)
                {
                    NSNumber *imgId = [ImgIdArray objectAtIndex:tempBtnTag - 1000];
                    
                    UIButton *tempBtn = InsertImageButton(superView, CGRectMake(k * (BtnWidth + BetweenHorizontalBtnAndBtnSpace) + BetweenHorizontalBtnAndBtnSpace, i * (BtnHeight + LabelHeight + BetweenVerticalBtnAndLabelSpace) + curFrameOriginY, BtnWidth, BtnHeight), tempBtnTag, nil, nil, self, @selector(clickPlatformBtn:));
                    currentView = tempBtn;
                    
                    // 中间显示图片的那个小Btn
                    UIButton *centerBtn = InsertButtonWithType(tempBtn, tempBtn.bounds, 1000, nil, NULL, UIButtonTypeCustom);
                    centerBtn.userInteractionEnabled = NO;
                    [centerBtn setBackgroundImageWithImageId:imgId storeTableType:WebImageStoreTableFileLittle placeholderImage:[UIImage imageNamed:@"Unify_Image_w1.png"] options:WebImageDownload isRoundedRect:NO roundedRectSize:CGSizeMake(0, 0) resize:YES];
                    
                    tempBtnTag++;
                }
            }
        }
        return currentView;
    }
    */
}

@end