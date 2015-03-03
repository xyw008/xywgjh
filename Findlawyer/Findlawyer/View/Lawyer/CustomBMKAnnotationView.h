//
//  CustomBMKAnnotationView.h
//  zmt
//
//  Created by apple on 14-2-25.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import "BMKPinAnnotationView.h"

@interface CustomBMKAnnotationView : BMKPinAnnotationView

/// annotationView显示的标题
@property (nonatomic, copy) NSString *title;

@end
