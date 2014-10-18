//
//  ToolView.h
//  Find lawyer
//
//  Created by macmini01 on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ToolBtnTouchType_Consult,//咨询
    ToolBtnTouchType_Call,//打电话
    ToolBtnTouchType_Sms,//发短信
}ToolBtnTouchType;

@protocol ToolViewDelegate;

@interface ToolView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
- (IBAction)btnCall:(id)sender;//打电话
- (IBAction)btnConsult:(id)sender; //咨询
- (IBAction)btnSms:(id)sender; // 发短信
- (void)configViewWithPhone:(NSString *)phone;
@property (weak, nonatomic) id<ToolViewDelegate> delegate;

@end


@protocol ToolViewDelegate <NSObject>

- (void)ToolView:(ToolView *)view didBtnType:(ToolBtnTouchType)type;

@end
