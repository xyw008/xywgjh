//
//  MyPageControll.h
//  KidsPainting
//
//  Created by HJC on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// 模仿系统默认的UIPageControl, 但是可以改变小原点的图片
@interface ATPageControl : UIView
{
@private
    NSInteger   _numberOfPages;
    NSInteger   _currentPage;
    UIImage*    _normalPointImage;
    UIImage*    _currentPointImage;
    BOOL        _hidesForSinglePage;
}
@property (nonatomic, assign)   BOOL        hidesForSinglePage;
@property (nonatomic, assign)   NSInteger   numberOfPages;
@property (nonatomic, assign)   NSInteger   currentPage;
@property (nonatomic, retain)   UIImage*    normalPointImage;
@property (nonatomic, retain)   UIImage*    currentPointImage;
@end
