//
//  GJHAlertView.h
//  o2o
//
//  Created by swift on 14-8-22.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GJHAlertViewDelegate;

@interface GJHAlertView : UIView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
 isInputContentView:(BOOL)isInputContentView
           delegate:(id<GJHAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic,assign) id<GJHAlertViewDelegate> delegate;    // weak reference

@property (nonatomic, copy) void(^onOkAction)(void); //called if dismissed with other button
@property (nonatomic, copy) void(^onCancelAction)(void);//called if dismissed with cancel button
@property (nonatomic, copy) void(^onDismissAction)(void);//called after onOkAction or onCancelAction. Useful if alert has more than 2 buttons

@property (nonatomic, assign, readonly) NSInteger dismissButtonIndex;//index of button that was tapped to dismiss the alert


@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;   // secondary explanation text

// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
// cancel button which will be positioned based on HI requirements. Buttons cannot be customized. If you pass nil as a title no button will be added.
- (NSInteger)addButtonWithTitle:(NSString *)title;    // returns index of button. 0 based.
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@property(nonatomic,readonly) NSInteger numberOfButtons;
@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

//max height of the alert, if set
@property(nonatomic) NSInteger maxHeight;

// TODO: not implemented
//@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used

@property(nonatomic,readonly,getter=isVisible) BOOL visible;

// shows popup alert animated.
- (void)show;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)clickButtonAtIndex:(NSInteger)buttonIndex;

@property(nonatomic, strong) NSMutableArray *buttons;
@property(nonatomic, weak, readonly) UILabel *titleLabel;
@property(nonatomic, weak, readonly) UILabel *messageLabel;
@property(nonatomic, weak, readonly) UITextView *inputContentView; // 文本输入框
@property(nonatomic, weak, readonly) UIView *backgroundOverlay;
@property(nonatomic, weak, readonly) UIView *alertContainer;
@property(nonatomic) CGFloat animationDuration UI_APPEARANCE_SELECTOR;
@property(nonatomic) BOOL hasCancelButton;

//setting these properties overwrites any other button colors/fonts that have already been set
@property(nonatomic, strong) UIFont *defaultButtonFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *defaultButtonTitleColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *defaultButtonColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *defaultButtonShadowColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat defaultButtonCornerRadius UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat defaultButtonShadowHeight UI_APPEARANCE_SELECTOR;

// cancel按钮的样式
@property (nonatomic, strong) UIColor *cancelButtonColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL shouldDismissOnTouchOutside;         // default is NO
@property (nonatomic, assign) NSTimeInterval autoDismissAfterDelay;     // default is -1.0

@end


@protocol GJHAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(GJHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
// TODO: not implemented
//- (void)alertViewCancel:(GJHAlertView *)alertView;

- (void)willPresentAlertView:(GJHAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(GJHAlertView *)alertView;  // after animation

- (void)alertView:(GJHAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(GJHAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
// TODO: not implemented
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end