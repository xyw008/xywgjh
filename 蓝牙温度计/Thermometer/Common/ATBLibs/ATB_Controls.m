//
//  Controls.m
//  used only above IOS 5.0 SDK
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_Controls.h"
//#import "NetworkFunc.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyScaleScrollView.h"

UIScrollView *InsertScrollViewCanWebImagesByUrls(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, UIImage *placeholderImg, NSArray *netImageUrlArray, BOOL resize)
{
    if (!placeholderImg || !netImageUrlArray || 0 == netImageUrlArray.count)
        return nil;
    
    /*
    UIView *backView = InsertView(superView, rect);//加一个背景图,让page在scroll的上面
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     */
    
    //加滚动的scrollView
    UIScrollView *scrollView = InsertScrollView(superView, rect, tag, delegate);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = YES;
    
    for (int i = 0; i < netImageUrlArray.count; i++)
    {
        MyScaleScrollView *scaleScroll = [[MyScaleScrollView alloc] initWithFrame:scrollView.bounds];
        scaleScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scaleScroll.tag = 1000 + i;
        [scrollView addSubview:scaleScroll];
        
        UIButton *tempBtn = InsertImageButton(scaleScroll, scaleScroll.bounds, SubviewTag, nil, nil, nil, NULL);
        tempBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tempBtn.userInteractionEnabled = NO;
        
        NSString *imgUrlStr = [netImageUrlArray objectAtIndex:i];
        
//        [tempBtn setBackgroundImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:placeholderImg options:SDWebImageCacheMemoryOnly resize:resize];
    }
    
    //设置主scroll里view的frame
    NSArray *subViews = [scrollView subviews];
    UIView *tempView = nil;
    CGFloat viewsOriginX = 0.0;
    
    for (tempView in subViews)
    {
        if ([tempView isKindOfClass:[MyScaleScrollView class]] && tempView.tag >= 1000)
        {
            CGRect tempFram = tempView.frame;
            tempFram.origin.x = viewsOriginX;
            tempFram.origin.y = 0;
            tempView.frame = tempFram;
            
            viewsOriginX += scrollView.bounds.size.width;
        }
    }
    [scrollView setContentSize:CGSizeMake(netImageUrlArray.count * scrollView.bounds.size.width, scrollView.bounds.size.height)];
    
    /*
    //加pageControl
    UIPageControl *pageC = [[[UIPageControl alloc] init] autorelease];
    pageC.tag = PageControlOfScrollViewTag;
    pageC.center = CGPointMake(scrollView.bounds.size.width / 2, scrollView.bounds.size.height - 20);
    pageC.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    pageC.numberOfPages = netImageUrlArray.count;
    pageC.currentPage = 0;
    [pageC addTarget:nil action:NULL forControlEvents:UIControlEventValueChanged];
    [backView insertSubview:pageC aboveSubview:scrollView];
     */
    
    return scrollView;
}

UIScrollView *InsertScrollViewByLocalImages(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, NSArray *localImgsSourceArray, BOOL resize, BOOL canZoom)
{
    if (0 == localImgsSourceArray.count || !localImgsSourceArray)
        return nil;
    
    //加滚动的scrollView
    UIScrollView *scrollView = InsertScrollView(superView, rect, tag, delegate);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = YES;
    
    for (int i = 0; i < localImgsSourceArray.count; i++)
    {
        UIView *imgBtnBackView = nil;
        
        if (canZoom)
            imgBtnBackView = [[MyScaleScrollView alloc] initWithFrame:scrollView.bounds];
        else
            imgBtnBackView = InsertView(nil, scrollView.bounds);
        
        imgBtnBackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imgBtnBackView.tag = 1000 + i;
        [scrollView addSubview:imgBtnBackView];
        
        UIButton *tempBtn = InsertImageButton(imgBtnBackView, imgBtnBackView.bounds, SubviewTag, nil, nil, nil, NULL);
        tempBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tempBtn.userInteractionEnabled = NO;
        
        //imgNameOrPathStr有可能是沙盒里的图片路径也有可能是bundle里的图片名
        NSString *imgNameOrPathStr = [localImgsSourceArray objectAtIndex:i];
        UIImage *image = nil;
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:imgNameOrPathStr])
            image = [UIImage imageWithContentsOfFile:imgNameOrPathStr];
        else
            image = [UIImage imageNamed:imgNameOrPathStr];
        
        if (resize)
            [tempBtn setNewImgBtn:image oldImgBtn:tempBtn];
        else
            [tempBtn setImage:image forState:UIControlStateNormal];
    }
    
    //设置主scroll里view的frame
    NSArray *subViews = [scrollView subviews];
    UIView *tempView = nil;
    CGFloat viewsOriginX = 0.0;
    
    for (tempView in subViews)
    {
        if (([tempView isKindOfClass:[MyScaleScrollView class]] || [tempView isKindOfClass:[UIView class]]) && tempView.tag >= 1000)
        {
            CGRect tempFram = tempView.frame;
            tempFram.origin.x = viewsOriginX;
            tempFram.origin.y = 0;
            tempView.frame = tempFram;
            
            viewsOriginX += scrollView.bounds.size.width;
        }
    }
    [scrollView setContentSize:CGSizeMake(localImgsSourceArray.count * scrollView.bounds.size.width, scrollView.bounds.size.height)];
    
    return scrollView;
}

UIScrollView *InsertScrollViewCanScrollSubViews(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, int scrollCount, UIImage *placeholderImg, NSArray *netImageIdArray, BOOL resize)
{
    if (0 == scrollCount || !placeholderImg)
        return nil;
    
    //加滚动的scrollView
    UIScrollView *scrollView = InsertScrollView(superView, rect, tag, delegate);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = YES;
    
    for (int i = 0; i < scrollCount; i++)
    {
        MyScaleScrollView *scaleScroll = [[MyScaleScrollView alloc] initWithFrame:scrollView.bounds];
        scaleScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scaleScroll.tag = 1000 + i;
        [scrollView addSubview:scaleScroll];

        UIButton *tempBtn = InsertImageButton(scaleScroll, scaleScroll.bounds, SubviewTag, nil, nil, nil, NULL);
        tempBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tempBtn.userInteractionEnabled = NO;

        if (!netImageIdArray || 0 == netImageIdArray.count || scrollCount != netImageIdArray.count)
        {
            if (resize)
                [tempBtn setNewImgBtn:placeholderImg oldImgBtn:tempBtn];
            else
                [tempBtn setImage:placeholderImg forState:UIControlStateNormal];
        }
        else
        {
            NSNumber *imgId = [netImageIdArray objectAtIndex:i];
            
            [tempBtn setBackgroundImageWithImageId:imgId storeTableType:WebImageStoreTableFileLittle placeholderImage:placeholderImg options:WebImageDownload isRoundedRect:NO roundedRectSize:CGSizeMake(0, 0) resize:resize];
        }
    }
    
    //设置主scroll里view的frame
    NSArray *subViews = [scrollView subviews];
    UIView *tempView = nil;
    CGFloat viewsOriginX = 0.0;
    
    for (tempView in subViews)
    {
        if ([tempView isKindOfClass:[MyScaleScrollView class]] && tempView.tag >= 1000)
        {
            CGRect tempFram = tempView.frame;
            tempFram.origin.x = viewsOriginX;
            tempFram.origin.y = 0;
            tempView.frame = tempFram;
            
            viewsOriginX += scrollView.bounds.size.width;
        }
    }
    [scrollView setContentSize:CGSizeMake(scrollCount * scrollView.bounds.size.width, scrollView.bounds.size.height)];
    
    return scrollView;
}


UIScrollView *InsertScrollView(UIView *superView, CGRect rect, int tag,id<UIScrollViewDelegate> delegate)
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.tag = tag;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = delegate;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    if (superView)
        [superView addSubview:scrollView];
    
    return scrollView;
}

CGRect SetRectOrigin(CGRect frame, CGPoint origin){
    return CGRectMake(origin.x, origin.y, frame.size.width, frame.size.height);
}

CGRect SetRectSize(CGRect frame, CGSize size){
    return CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
}

CGRect SetRectX(CGRect frame, CGFloat x){
    return CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

CGRect SetRectY(CGRect frame, CGFloat y){
    return CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}

CGRect SetRectWidth(CGRect frame, CGFloat width){
    return CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

CGRect SetRectHeight(CGRect frame, CGFloat height){
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

NSTimer *SetTimer(NSTimeInterval timeElapsed, id target, SEL selector){
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:nil repeats:YES];
    if (nil == ret) return nil;
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    return ret;
}

NSTimer *SetTimerWithUserData(NSTimeInterval timeElapsed, id data, id target, SEL selector){
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:data repeats:YES];
    if (nil == ret) return nil;
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    return ret;
}

void KillTimer(NSTimer *timer){
    [timer invalidate];
}

int GetRGB(CGColorRef color, CGFloat **pColor){
    int numComponents = CGColorGetNumberOfComponents(color);
    if (nil != pColor)
        *pColor = (CGFloat*)CGColorGetComponents(color);
    return numComponents;
}

int GetRGB2(UIColor* color, CGFloat **pColor){
    return GetRGB(color.CGColor, pColor);
}

void AddSubController(UIView *view, UIViewController *ctrl, BOOL animation){
    [ctrl viewWillAppear:animation];
    [view addSubview:ctrl.view];
    [ctrl viewDidAppear:animation];
}

void RemoveSubController(UIViewController *ctrl, BOOL animation){
    [ctrl viewWillDisappear:animation];
    [ctrl.view removeFromSuperview];
    [ctrl viewDidDisappear:animation];
}

void RemoveAllSubviews(UIView *view){
    for (int i=view.subviews.count; i>0; i--){
        [[view.subviews objectAtIndex:i-1] removeFromSuperview];
    }
}

UILabel *InsertBubbleMessageLabel(id superView, CGRect cRect, BubbleMessageStyle style, NSString *contentStr, UIFont *textFont, UIColor *texCcolor, BOOL resize)
{
    //初始化label
    UILabel *tempLabel = [[ATB_BubbleMessageLabel alloc] initWithFrame:cRect text:contentStr textFont:textFont textColor:texCcolor bubbleMessageStyle:style];
    [tempLabel setBackgroundColor:[UIColor clearColor]];
    
    if (resize && nil != contentStr)
    {
        //设置自动行数与字符换行
        tempLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        //计算实际frame大小，并将label的frame变成实际大小
        float labelHeight= [ATB_BubbleMessageLabel labelHeightForText:contentStr font:textFont constrainedToWidth:cRect.size.width minHeight:cRect.size.height];
        
        tempLabel.frame = CGRectMake(cRect.origin.x, cRect.origin.y, cRect.size.width, labelHeight);
    }
    
    if (superView)
        [superView addSubview:tempLabel];
    
	return tempLabel;
}

UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize)
{
    return InsertLabelWithCustomResize(superView, cRect, align, contentStr, textFont, textColor, resize, resize);
}

UILabel *InsertLabelWithCustomResize(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight)
{
    return InsertLabelWithContentOffset(superView, cRect, align, contentStr, textFont, textColor, resizeWidth, resizeHeight, CGSizeZero);
}

UILabel *InsertLabelWithContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, CGSize contentOffset)
{
    return InsertLabelWithShadowAndContentOffset(superView, cRect, align, contentStr, textFont, textColor, resizeWidth, resizeHeight, NO, nil, CGSizeZero, contentOffset);
}

UILabel *InsertLabelWithShadowAndContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset, CGSize contentOffset)
{
    return InsertLabelWithShadowAndLineAndContentOffset(superView, cRect, align, contentStr, textFont, textColor, resizeWidth, resizeHeight, shadow, shadowColor, shadowOffset, NO, TopLine, 0.0, nil, contentOffset);
}

UILabel *InsertLabelWithShadowAndLineAndContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset, BOOL isLine, LinePositionType positionType, float lineWidth, UIColor *lineColor, CGSize contentOffset)
{
    // 初始化label
    UILabel *tempLabel = [[ATB_StrikeThroughLabel alloc] initWithFrame:cRect strikeThroughEnabled:isLine linePositionType:positionType lineWidth:lineWidth lineColor:lineColor contentOffset:contentOffset];
    tempLabel.textAlignment = align;
    tempLabel.textColor = textColor;
    [tempLabel setBackgroundColor:[UIColor clearColor]];
    tempLabel.font = textFont;
    tempLabel.text = contentStr;
    [tempLabel setNumberOfLines:1];
    
    if ((resizeWidth || resizeHeight) && nil != contentStr)
    {
        [tempLabel setNumberOfLines:0];
        
        // 设置自动行数与字符换行
        tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // 设置一个行的宽度和高度上限
        CGSize size = CGSizeMake(cRect.size.width - contentOffset.width * 2, FLT_MAX);
        // 计算实际frame大小，并将label的frame变成实际大小
        CGSize labelsize = [contentStr sizeWithFont:textFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat width = resizeWidth ? (labelsize.width + contentOffset.width * 2) : cRect.size.width;
        CGFloat height = resizeHeight ? (labelsize.height + contentOffset.height * 2) : cRect.size.height;
        tempLabel.frame = CGRectMake(cRect.origin.x, cRect.origin.y, width, height);
    }
    
    if (shadow)
    {
        if (shadowColor)
            tempLabel.shadowColor = shadowColor;
        tempLabel.shadowOffset = shadowOffset;
    }
    
    if (superView)
        [superView addSubview:tempLabel];
    
    return tempLabel;
}

UIWebView *InsertWebView(id superView,CGRect cRect, id<UIWebViewDelegate>delegate, int tag)
{
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:cRect];
    tempWebView.tag = tag;
    [tempWebView setOpaque:NO]; //让webView的背景色透明
    tempWebView.backgroundColor = [UIColor clearColor];
    tempWebView.delegate = delegate;
    tempWebView.scalesPageToFit = NO;
    /*
    tempWebView.scrollView.scrollEnabled = NO;//不让webview滚动
     */
    
    if (superView)
        [superView addSubview:tempWebView];
    
    return tempWebView;
}

UIButton *InsertButton(id view, CGRect rc, int tag, NSString *title, id target, SEL action){
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
	UILabel *label = [btn titleLabel];
	label.font = [label.font fontWithSize:22];
    label.lineBreakMode = UILineBreakModeTailTruncation;
    
//	rc.size.width = [title sizeWithFont:label.font constrainedToSize:rc.size].width+20;
	
	btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTag:tag];
	
    if (view)
        [view addSubview:btn];
	
	rc.size = btn.bounds.size;
    
	return btn;
}

UIButton *InsertImageButton(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, id target, SEL action){
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (nil != img)
        [btn setBackgroundImage:img forState:UIControlStateNormal];
    //[btn setImage:img forState:UIControlStateNormal];
    
    if (nil != imgH)
        [btn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    
	btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTag:tag];
	
    if (view)
        [view addSubview:btn];
    
    return btn;
}

UIButton *InsertImageButtonWithTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action){
    UIButton *btn = InsertImageButton(view, rc, tag, img, imgH, target, action);
    
    if (nil != font)
        btn.titleLabel.font = font;
    
    if (nil != color)
        //        btn.titleLabel.textColor = color;
        [btn setTitleColor:color forState:UIControlStateNormal];
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    btn.titleEdgeInsets = edgeInsets;

    return btn;
}

UIButton *InsertImageButtonWithSelectedImage(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, id target, SEL action){
    UIButton *btn = InsertImageButton(view, rc, tag, img, imgH, target, action);
    [btn setBackgroundImage:imgSelected forState:UIControlStateSelected];
    btn.selected = selected;
    return btn;
}

UIButton *InsertImageButtonWithSelectedImageAndTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action){
    UIButton *btn = InsertImageButtonWithSelectedImage(view, rc, tag, img, imgH, imgSelected, selected, target, action);
    
    if (nil != font)
        btn.titleLabel.font = font;
    
    if (nil != color)
        //        btn.titleLabel.textColor = color;
        [btn setTitleColor:color forState:UIControlStateNormal];
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    btn.titleEdgeInsets = edgeInsets;

    return btn;
}

UIButton *InsertButtonWithType(id view, CGRect rc, int tag, id target, SEL action, UIButtonType type){
    UIButton *btn = [UIButton buttonWithType:type];
    
	btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTag:tag];
	
    if (view)
        [view addSubview:btn];
    
    return btn;
}

UITableView *InsertTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style)
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:rect style:style];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (dataSoure)
        tabView.dataSource = dataSoure;
    if (delegate)
        tabView.delegate = delegate;
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tabView.backgroundView = nil;
    
    if (superView)
        [superView addSubview:tabView];
    
    return tabView;
}

UITextField *InsertTextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment){
	UITextField *myTextField = [[UITextField alloc] initWithFrame:rc];
    myTextField.delegate = delegate;
	myTextField.placeholder = placeholder;
	myTextField.font = font;
    myTextField.textAlignment = textAlignment;
    myTextField.contentVerticalAlignment = contentVerticalAlignment;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    if (view)
        [view addSubview:myTextField];
    
	return myTextField;
}

FUITextField *InsertFUITextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, UIColor *textFieldColor, UIEdgeInsets edgeInsets)
{
    return InsertFUITextFieldWithBorder(view, delegate, rc, placeholder, font, textAlignment, contentVerticalAlignment, 0.0, nil, textFieldColor, 0.0, edgeInsets);
}

FUITextField *InsertFUITextFieldWithBorder(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, float borderWidth, UIColor *borderColor, UIColor *textFieldColor, float cornerRadius, UIEdgeInsets edgeInsets)
{
    FUITextField *myTextField = [[FUITextField alloc] initWithFrame:rc];
    myTextField.delegate = delegate;
	myTextField.placeholder = placeholder;
	myTextField.font = font;
    myTextField.textAlignment = textAlignment;
    myTextField.contentVerticalAlignment = contentVerticalAlignment;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    myTextField.borderWidth = borderWidth;
    myTextField.borderColor = borderColor;
    if (!textFieldColor)
        myTextField.textFieldColor = [UIColor whiteColor];
    else
        myTextField.textFieldColor = textFieldColor;
    myTextField.cornerRadius = cornerRadius;
    myTextField.edgeInsets = edgeInsets;
    
    if (view)
        [view addSubview:myTextField];
    
	return myTextField;
}

UISwitch *InsertSwitch(id view, CGRect rc){
	UISwitch *sw = [[UISwitch alloc] initWithFrame:rc];
    
    if (view)
        [view addSubview:sw];
    
	return sw;
}

UISegmentedControl *InsertSegment(id view, CGRect rc){
	UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:rc];
	seg.segmentedControlStyle = UISegmentedControlStylePlain;
	
    if (view)
        [view addSubview:seg];
    
	return seg;
}

UIImageView *InsertImageView(id view, CGRect rect, UIImage *image, NSURL *imageUrl){
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    if (nil == imageUrl)
    {
        [imageView setImage:image];
    }
    else
    {
//        [imageView setImageWithURL:imageUrl placeholderImage:image options:SDWebImageCacheMemoryOnly];
        [imageView gjh_setImageWithURL:imageUrl placeholderImage:image imageShowStyle:ImageShowStyle_None options:SDWebImageCacheMemoryOnly success:^(UIImage *image) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    imageView.userInteractionEnabled = YES;
    
    if (view)
        [view addSubview:imageView];
    
    return imageView;
}

UIView *InsertView(id view, CGRect rect){
    UIView *_view = [[UIView alloc] initWithFrame:rect];
    _view.backgroundColor = [UIColor whiteColor];
    
    if (view)
        [view addSubview:_view];
    
    return _view;
}

UIPickerView *InsertPickerView(id view, CGRect rect){
    UIPickerView *_view = [[UIPickerView alloc] initWithFrame:rect];
    _view.showsSelectionIndicator = YES;
    
    if (view)
        [view addSubview:_view];
    
    return _view;
}

void SetAnimationFrame(UIView *view, CGRect frame){
    view.center = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    view.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

void WebSimpleLoadWithLocalFile(UIWebView *web, NSString *filename){
    NSStringEncoding enc = NSASCIIStringEncoding;
    [NSString stringWithContentsOfFile:filename usedEncoding:&enc error:nil];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    
    NSString *type = nil;
    switch (enc) {
        case NSASCIIStringEncoding:
            type = @"GBK";
            break;
        case NSUTF8StringEncoding:
            type = @"utf-8";
            break;
        default:
            break;
    }
    
    [web loadData:data MIMEType:GetMIMEType(GetFileExt(filename)) textEncodingName:type baseURL:nil];
}

void WebSimpleLoadRequest(UIWebView *web, NSString *strURL){
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    [web loadRequest:request];
}

void WebSimpleLoadRequestWithCookie(UIWebView *web, NSString *strURL, NSString *cookies){
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [request addValue:cookies forHTTPHeaderField:@"Cookie"];
    [web loadRequest:request];
}

CGPDFDocumentRef createDocumentWithContentsOfFile(NSString *fileName){
    if (nil == fileName) return nil;
    
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [fileName UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    return document;
}
