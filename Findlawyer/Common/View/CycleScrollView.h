//
//  CycleScrollView.h
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{   /// 根据自身尺寸及图片长宽比自动调整大小全部显示
    ViewShowStyle_AutoResizing = 0,
    /// 根据自身尺寸及图片长宽比剪切成方块显示
    ViewShowStyle_Square,
    /// 不做任何处理
    ViewShowStyle_None
    
} ViewShowStyle;

@protocol CycleScrollViewDelegate;

@interface CycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly)  UIScrollView        *scrollView;
@property (nonatomic, readonly)  UIPageControl       *pageControl;      // default is show
@property (nonatomic, assign)    NSInteger           currentPage;       // default is 0
@property (nonatomic, assign, setter = setDelegate:) id<CycleScrollViewDelegate> delegate;

/**
 @ 方法描述    创建加载本地图片组的循环滚动ScrollView
 @ 输入参数    contenMode: 图像展示方式 isCanZoom: 是否能放大缩小操作
 @ 返回值      实例对象
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (id)initWithFrame:(CGRect)frame
    viewContentMode:(ViewShowStyle)contenMode
           delegate:(id<CycleScrollViewDelegate>)delegate
      localImgNames:(NSArray *)names
       isAutoScroll:(BOOL)YesOrNo
          isCanZoom:(BOOL)canZoom;

/**
 @ 方法描述    创建加载网络图片组的循环滚动ScrollView
 @ 输入参数    contenMode: 图像展示方式 isCanZoom: 是否能放大缩小操作
 @ 返回值      实例对象
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (id)initWithFrame:(CGRect)frame
    viewContentMode:(ViewShowStyle)contenMode
           delegate:(id<CycleScrollViewDelegate>)delegate
    imgUrlsStrArray:(NSArray *)urlsStrArray
       isAutoScroll:(BOOL)YesOrNo
          isCanZoom:(BOOL)canZoom;

/**
 @ 方法描述    ScrollView滚动到指定下标
 @ 输入参数    aIndex: 索引下标
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)scrollToIndex:(int)aIndex;

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index;

@end

