//
//  SlideActionSheet.h
//  Sephome
//
//  Created by leo on 14/12/12.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//  显示底部可以滑动、可以自动调整高度的 actionSheet

#import <Foundation/Foundation.h>


/**
 *  选择一个选项后触发block
 *
 *  @param selectIndex 选项所在数据源数组的 index
 *  @param selectStr   选项的字符串
 */
typedef void (^SlideActionSheetSelectHandle) (NSInteger selectIndex, NSString *selectStr);


@interface SlideActionSheet : NSObject

AS_SINGLETON(SlideActionSheet);

/**
 *  显示底部可以滑动的 actionSheet
 *
 *  @param titleStr     标题名字
 *  @param stringArray  选项数据源数组（数组元素必须是字符串）
 *  @param selectHandle 选择一个选项后触发block
 */
- (void)showActionSheetTitleString:(NSString*)titleStr
                       stringArray:(NSArray*)stringArray
                      selectHnadle:(SlideActionSheetSelectHandle)selectHandle;



/**
 *  显示底部可以滑动的 actionSheet
 *
 *  @param titleStr     标题名字
 *  @param stringArray  选项数据源数组（数组元素必须是字符串）
 *  @param titleColor   标题字体颜色
 *  @param titleFont    标题字体大小
 *  @param optionColor  选项内容字体颜色
 *  @param optionFont   选项内容字体大小
 *  @param selectHandle 选择一个选项后触发block
 */
- (void)showActionSheetTitleString:(NSString*)titleStr
                       stringArray:(NSArray*)stringArray
                        titleColor:(UIColor*)titleColor
                         titleFont:(UIFont*)titleFont
                      optionColor:(UIColor*)optionColor
                       optionFont:(UIFont*)optionFont
                      selectHnadle:(SlideActionSheetSelectHandle)selectHandle;




@end
