//
//  Controls.h
//  huangpu
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_StrikeThroughLabel.h"
#import "ATB_BubbleMessageLabel.h"
#import "FUITextField.h"

#define PageControlOfScrollViewTag 20000

// UIScrollView
UIScrollView *InsertScrollViewCanWebImagesByUrls(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, UIImage *placeholderImg, NSArray *netImageUrlArray, BOOL resize); // 加载网络图片组(URL方式)
UIScrollView *InsertScrollViewByLocalImages(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, NSArray *localImgsSourceArray, BOOL resize, BOOL canZoom); // 加载本地图片组
UIScrollView *InsertScrollViewCanScrollSubViews(UIView *superView, CGRect rect, int tag, id<UIScrollViewDelegate> delegate, int scrollCount, UIImage *placeholderImg, NSArray *netImageIdArray, BOOL resize); // 加载网络图片组(图片ID方式)
UIScrollView *InsertScrollView(UIView *superView, CGRect rect, int tag,id<UIScrollViewDelegate> delegate);

void AddSubController(UIView *view, UIViewController *ctrl, BOOL animation);
void RemoveSubController(UIViewController *ctrl, BOOL animation);
void RemoveAllSubviews(UIView *view);

// UILabel(下级接口包含上级接口内容)
UILabel *InsertBubbleMessageLabel(id superView, CGRect cRect, BubbleMessageStyle style, NSString *contentStr, UIFont *textFont, UIColor *texCcolor, BOOL resize); // 气泡式

UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize); // 带自适应高度和宽度
UILabel *InsertLabelWithCustomResize(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight);
UILabel *InsertLabelWithContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, CGSize contentOffset); // 带内容偏移量(此接口一定要自适应高度)
UILabel *InsertLabelWithShadowAndContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset, CGSize contentOffset); // 带文字阴影
UILabel *InsertLabelWithShadowAndLineAndContentOffset(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resizeWidth, BOOL resizeHeight, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset, BOOL isLine, LinePositionType positionType, float lineWidth, UIColor *lineColor, CGSize contentOffset); // 带划线

// UIWebView
UIWebView *InsertWebView(id superView,CGRect cRect, id<UIWebViewDelegate>delegate, int tag);

// UIbutton
UIButton *InsertButton(id view, CGRect rc, int tag, NSString *title, id target, SEL action);
UIButton *InsertImageButtonWithTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action);
UIButton *InsertImageButtonWithSelectedImage(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, id target, SEL action);
UIButton *InsertImageButtonWithSelectedImageAndTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action);
UIButton *InsertButtonWithType(id view, CGRect rc, int tag, id target, SEL action, UIButtonType type);
UIButton *InsertImageButton(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, id target, SEL action);

// UITableView
UITableView *InsertTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style);

// UITextField
UITextField *InsertTextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment);
FUITextField *InsertFUITextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, UIColor *textFieldColor, UIEdgeInsets edgeInsets);
FUITextField *InsertFUITextFieldWithBorder(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, float borderWidth, UIColor *borderColor, UIColor *textFieldColor, float cornerRadius, UIEdgeInsets edgeInsets);

// UISwitch
UISwitch *InsertSwitch(id view, CGRect rc);

// UISegmentedControl
UISegmentedControl *InsertSegment(id view, CGRect rc);

// UIImageView
UIImageView *InsertImageView(id view, CGRect rect, UIImage *image, NSURL *imageUrl);

// UIView
UIView *InsertView(id view, CGRect rect);

// UIPickerView
UIPickerView *InsertPickerView(id view, CGRect rect);

CGRect SetRectOrigin(CGRect frame, CGPoint origin);
CGRect SetRectSize(CGRect frame, CGSize size);

CGRect SetRectX(CGRect frame, CGFloat x);
CGRect SetRectY(CGRect frame, CGFloat y);
CGRect SetRectWidth(CGRect frame, CGFloat width);
CGRect SetRectHeight(CGRect frame, CGFloat height);

void SetAnimationFrame(UIView *view, CGRect frame);

NSTimer *SetTimer(NSTimeInterval timeElapsed, id target, SEL selector);
NSTimer *SetTimerWithUserData(NSTimeInterval timeElapsed, id data, id target, SEL selector);
void KillTimer(NSTimer *timer);

int GetRGB(CGColorRef color, CGFloat **pColor);
int GetRGB2(UIColor* color, CGFloat **pColor);

void WebSimpleLoadWithLocalFile(UIWebView *web, NSString *filename);
void WebSimpleLoadRequest(UIWebView *web, NSString *strURL);
void WebSimpleLoadRequestWithCookie(UIWebView *web, NSString *strURL, NSString *cookies);

CGPDFDocumentRef createDocumentWithContentsOfFile(NSString *fileName);
