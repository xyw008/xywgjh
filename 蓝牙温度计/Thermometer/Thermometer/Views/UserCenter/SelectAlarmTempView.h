//
//  SelectAlarmTempView.h
//  Thermometer
//
//  Created by leo on 15/11/30.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlarmTempBtnCallBack) (BOOL isSubmit,CGFloat tempValue);

@interface SelectAlarmTempView : UIView

@property (nonatomic,strong)AlarmTempBtnCallBack    btnCallBack;

- (void)nowSelectTemp:(CGFloat)temp;

@end
