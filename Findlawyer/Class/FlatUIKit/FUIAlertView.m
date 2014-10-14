//
//  FUIAlertView.m
//  FlatUI
//
//  Created by Jack Flintermann on 5/7/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "FUIAlertView.h"
#import "FUIButton.h"

#define InputContentViewHeight 60
#define  KeyboardHeight 252

@interface FUIAlertView()

@property(nonatomic, weak) UIView *alertContentContainer;

@property (nonatomic, assign) BOOL isInputContentView;

@end

@implementation FUIAlertView

+ (void)initialize {
    if (self == [FUIAlertView class]) {
        FUIAlertView *appearance = [self appearance];
        [appearance setButtonSpacing:10.0f];
        [appearance setAnimationDuration:0.2f];
    }
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
 isInputContentView:(BOOL)isInputContentView
           delegate:(id<FUIAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.isInputContentView = isInputContentView;

        // This mask is set to force lay out of subviews when superview's bounds change
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *backgroundOverlay = [[UIView alloc] init];
        backgroundOverlay.backgroundColor = [UIColor blueColor];
        [self addSubview:backgroundOverlay];
        backgroundOverlay.alpha = 0.5;
        _backgroundOverlay = backgroundOverlay;
        
        UIView *alertContainer = [[UIView alloc] init];
        alertContainer.backgroundColor = [UIColor yellowColor];
        [self addSubview:alertContainer];
        [self bringSubviewToFront:alertContainer];
        _alertContainer = alertContainer;
        
        UIView *alertContentContainer = [[UIView alloc] init];
        alertContentContainer.backgroundColor = [UIColor clearColor];
        [self.alertContainer addSubview:alertContentContainer];
        [self.alertContainer bringSubviewToFront:alertContentContainer];
        _alertContentContainer = alertContentContainer;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        [alertContentContainer addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = self.message;
        [alertContentContainer addSubview:messageLabel];
        _messageLabel = messageLabel;
        
        // 有没有输入框
        if (isInputContentView)
        {
            UITextView *inputView = [[UITextView alloc] init];
            inputView.backgroundColor = [UIColor whiteColor];
            [alertContentContainer addSubview:inputView];
            _inputContentView = inputView;
        }

        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            [self setHasCancelButton:YES];
        }
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg];
        }
        va_end(args);
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (CGAffineTransformIsIdentity(self.alertContainer.transform)) {
        self.backgroundOverlay.frame = self.bounds;
        CGFloat padding = 15;
        CGRect contentContainerFrame = CGRectMake(padding, padding, 0, 0);
        contentContainerFrame.size = [self calculateSize];
        self.alertContentContainer.frame = contentContainerFrame;
        CGRect alertContainerFrame = CGRectInset(contentContainerFrame, -padding, -padding);
        alertContainerFrame.origin = CGPointMake(floorf((self.frame.size.width - alertContainerFrame.size.width) / 2),
                                                 floorf((self.frame.size.height - alertContainerFrame.size.height) / 2));
        
        // 根据键盘高度确定alert弹出位置
        if (!self.isInputContentView)
        {
            alertContainerFrame.origin.y = MAX(30, alertContainerFrame.origin.y - 30);
        }
        else
        {
            alertContainerFrame.origin.y = floorf((self.frame.size.height - KeyboardHeight - alertContainerFrame.size.height) / 2);
        }
        self.alertContainer.frame = alertContainerFrame;
        
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.size.width = self.alertContentContainer.frame.size.width;
        self.titleLabel.frame = titleFrame;
        [self.titleLabel sizeToFit];
        titleFrame = self.titleLabel.frame;
        CGPoint titleOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.titleLabel.frame.size.width)/2), 0);
        titleFrame.origin = titleOrigin;
        self.titleLabel.frame = titleFrame;
        
        CGRect messageFrame = self.messageLabel.frame;
        messageFrame.size.width = self.alertContentContainer.frame.size.width;
        self.messageLabel.frame = messageFrame;
        [self.messageLabel sizeToFit];
        messageFrame = self.messageLabel.frame;
        CGPoint messageOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.messageLabel.frame.size.width)/2), CGRectGetMaxY(titleFrame) + ((titleFrame.size.height && messageFrame.size.height) > 0 ? 10 : 0));
        messageFrame.origin = messageOrigin;
        self.messageLabel.frame = messageFrame;
        
        // 有没有输入框
        if (self.inputContentView)
        {
            CGRect inputContentFrame = _inputContentView.frame;
            inputContentFrame.size = CGSizeMake(self.alertContentContainer.frame.size.width, InputContentViewHeight);
            inputContentFrame.origin = CGPointMake(0, CGRectGetMaxY(messageFrame) + (messageFrame.size.height > 0 ? 10 : 0));
            _inputContentView.frame = inputContentFrame;
        }
        
        /**
         * 方法描述: 修改只有2个button时,button的排版方式
         * 输入参数: 无
         * 返回值: 无
         * 创建人: 龚俊慧
         * 创建时间: 2014-04-23
         */
        __block CGFloat startingButtonY = self.alertContentContainer.frame.size.height - [self totalButtonHeight];
        if (2 != self.buttons.count)
        {
            [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIButton *button = obj;
                if (self.hasCancelButton && idx == 0) {
                    CGFloat lastButtonY = self.alertContentContainer.frame.size.height - button.frame.size.height;
                    /*[self setButton:obj atHeight:lastButtonY];*/
                    [self setButton:obj originX:0 originY:lastButtonY width:self.alertContentContainer.frame.size.width];
                } else {
                    /*[self setButton:obj atHeight:startingButtonY];*/
                    [self setButton:obj originX:0 originY:startingButtonY width:self.alertContentContainer.frame.size.width];
                    startingButtonY += (button.frame.size.height + self.buttonSpacing);
                }
            }];
        }
        else
        {
            CGFloat buttonWidth = (self.alertContentContainer.frame.size.width - 10) / 2;
            
            [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
                if (self.hasCancelButton && idx == 0)
                {
                    [self setButton:button originX:0 originY:startingButtonY width:buttonWidth];
                }
                else
                {
                    [self setButton:button originX:self.alertContentContainer.frame.size.width - buttonWidth originY:startingButtonY width:buttonWidth];
                }
            }];
        }
        
        if(self.messageLabel.superview&&![self.messageLabel.superview isEqual:self.alertContentContainer]) {
            [self.messageLabel removeFromSuperview];
            [self.alertContentContainer addSubview:self.messageLabel];
        }
        if(self.maxHeight) {
            CGSize originalSize = messageFrame.size;
            messageFrame.size.height = self.alertContentContainer.frame.size.height-self.titleLabel.frame.size.height-[self totalButtonHeight]-20 - [self inputContentHeight];
            if(messageFrame.size.height<originalSize.height) {
                UIScrollView *messageScrollView = [[UIScrollView alloc] initWithFrame:messageFrame];
                
                // 重设输入框的frame
                CGRect inputContentFrame = _inputContentView.frame;
                inputContentFrame.origin = CGPointMake(0, CGRectGetMaxY(messageFrame) + 10);
                _inputContentView.frame = inputContentFrame;
                
                messageFrame.origin = CGPointZero;
                messageFrame.size = originalSize;
                self.messageLabel.frame = messageFrame;
                [messageScrollView setContentSize:originalSize];
                [messageScrollView addSubview:self.messageLabel];
                [self.alertContentContainer addSubview:messageScrollView];
            }
        }
    }
}

- (void)setButton:(UIButton *)button originX:(CGFloat)originX originY:(CGFloat)originY width:(CGFloat)width {
    /*
    CGRect buttonFrame = button.frame;
    buttonFrame.origin = CGPointMake(0, originY);
    buttonFrame.size.width = self.alertContentContainer.frame.size.width;
    button.frame = buttonFrame;
     */
    CGRect buttonFrame = button.frame;
    buttonFrame.origin = CGPointMake(originX, originY);
    buttonFrame.size.width = width;
    button.frame = buttonFrame;
}

- (CGFloat) totalButtonHeight {
    /*
     __block CGFloat buttonHeight = 0;
     [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
     buttonHeight += (button.frame.size.height + self.buttonSpacing);
     }];
     buttonHeight -= self.buttonSpacing;
     return buttonHeight;
     */
    if (2 != self.buttons.count)
    {
        __block CGFloat buttonHeight = 0;
        [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
            buttonHeight += (button.frame.size.height + self.buttonSpacing);
        }];
        buttonHeight -= self.buttonSpacing;
        return buttonHeight;
    }
    else
    {
        FUIButton *button = [self.buttons firstObject];
        return button.frame.size.height;
    }
}

- (CGFloat)inputContentHeight
{
    return self.isInputContentView ? (InputContentViewHeight + 10) : 0;
}

- (CGSize) calculateSize {
    CGFloat contentWidth = 250;
    
    CGFloat titleHeight;
    CGFloat messageHeight;
    
    if ([self.titleLabel.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // iOS7 methods
        CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:self.titleLabel.font}
                                                              context:nil];
        CGRect messageRect = [self.messageLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:self.messageLabel.font}
                                                                  context:nil];
        titleHeight = titleRect.size.height;
        messageHeight = messageRect.size.height;
    } else {
        // Pre-iOS7 methods
        titleHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
        messageHeight = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    }
    
    CGFloat buttonHeight = [self totalButtonHeight];
    
    // 没有标题或者内容,10的间隙也不要
    float titleSpace = (titleHeight <= 0) ? 0 : 10;
    float messageSpace = (messageHeight <= 0) ? 0 : 10;
    
    CGFloat contentHeight = titleHeight + titleSpace + messageHeight + messageSpace + buttonHeight + [self inputContentHeight];
    
    if(self.maxHeight && contentHeight>self.maxHeight)
        return CGSizeMake(contentWidth, MAX(titleHeight + titleSpace + buttonHeight + [self inputContentHeight], self.maxHeight));
    else
        return CGSizeMake(contentWidth, contentHeight);
}

- (NSInteger) numberOfButtons {
    return (NSInteger)self.buttons.count;
}

- (void)show {
    self.alertContainer.alpha = 0;
    self.alertContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController && !topController.presentedViewController.isBeingDismissed) {
        topController = topController.presentedViewController;
    }
    UIView *rootView = topController.view;
    self.frame = rootView.bounds;
    
    [rootView addSubview:self];
    [rootView bringSubviewToFront:self];
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 0.5;
        self.alertContainer.alpha = 1;
        self.alertContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished0) {
        _visible = YES;
        if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [self.delegate didPresentAlertView:self];
        }
        
        // 输入框第一响应
        if (_inputContentView)
        {
            [_inputContentView becomeFirstResponder];
        }
    }];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 0 || buttonIndex > (NSInteger)self.buttons.count) {
        return nil;
    }
    return [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] titleForState:UIControlStateNormal];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    //todo delegate
    
    _dismissButtonIndex = buttonIndex;
    
    self.alertContainer.transform = CGAffineTransformIdentity;
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if (self.onDismissAction) {
        self.onDismissAction();
    }
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 0;
        self.alertContainer.alpha = 0;
        self.alertContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _visible = NO;
        if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
            [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
        }
    }];
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    if (!title) return -1;
    if (!self.buttons) {
        self.buttons = [NSMutableArray array];
    }
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    button.cornerRadius = 3;
    button.buttonColor = [UIColor greenColor];
    button.shadowColor = [UIColor brownColor];
    button.shadowHeight = 3;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContentContainer addSubview:button];
    [self.buttons addObject:button];
    return (NSInteger)self.buttons.count-1;
}

- (void) buttonPressed:(FUIButton *)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:(NSInteger)index];
    }
    
    if (index == self.cancelButtonIndex && self.onCancelAction) {
        self.onCancelAction();
    } else if (index != self.cancelButtonIndex && self.onOkAction) {
        self.onOkAction();
    }
    
    [self dismissWithClickedButtonIndex:(NSInteger)index animated:YES];
}

- (void)clickButtonAtIndex:(NSInteger)buttonIndex {
    [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) setDefaultButtonFont:(UIFont *)defaultButtonFont {
    _defaultButtonFont = defaultButtonFont;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.titleLabel.font = defaultButtonFont;
    }];
}

- (void) setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        [button setTitleColor:defaultButtonTitleColor forState:UIControlStateNormal & UIControlStateHighlighted];
    }];
}

- (void) setDefaultButtonColor:(UIColor *)defaultButtonColor {
    _defaultButtonColor = defaultButtonColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.buttonColor = defaultButtonColor;
    }];
}

- (void) setDefaultButtonShadowColor:(UIColor *)defaultButtonShadowColor {
    _defaultButtonShadowColor = defaultButtonShadowColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowColor = defaultButtonShadowColor;
    }];
}

- (void) setDefaultButtonCornerRadius:(CGFloat)defaultButtonCornerRadius {
    _defaultButtonCornerRadius = defaultButtonCornerRadius;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.cornerRadius = defaultButtonCornerRadius;
    }];
}

- (void) setDefaultButtonShadowHeight:(CGFloat)defaultButtonShadowHeight {
    _defaultButtonShadowHeight = defaultButtonShadowHeight;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowHeight = defaultButtonShadowHeight;
    }];
}

// cancel按钮的样式
- (void)setCancelButtonColor:(UIColor *)cancelButtonColor
{
    _cancelButtonColor = cancelButtonColor;
    if (self.isInputContentView)
    {
        FUIButton *btn = [self.buttons firstObject];
        btn.buttonColor = cancelButtonColor;
    }
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
    _cancelButtonTitleColor = cancelButtonTitleColor;
    if (self.isInputContentView)
    {
        FUIButton *btn = [self.buttons firstObject];
        [btn setTitleColor:cancelButtonTitleColor forState:UIControlStateNormal & UIControlStateHighlighted];
    }
}

@end
