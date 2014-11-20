//
//  UploadImageBC.h
//  Find lawyer
//
//  Created by leo on 14-10-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  上传图片

#import <Foundation/Foundation.h>

typedef void (^UploadImage) (BOOL success);

@interface UploadImageBC : NSObject

- (instancetype)initWithAskId:(NSString*)askId
               UploadImgArray:(NSArray*)array
                      uploadStateBlock:(UploadImage)suceessOrFail;


//- (void)addUploadImg:(UIImage*)img;

- (void)addUploadImgArray:(NSArray*)array;

- (void)uploadImgRequest;

/**
 *  删除上传图片，如果是上传成功了的会同时把保存的返回成功字符串删掉
 *
 *  @param img 需要删除的图片
 */
- (void)deleteImg:(UIImage*)img;

/**
 *  获取所有上传成功图片返回的字符串组合 以 | 隔断
 *
 *  @return 组合字符串
 */
- (NSString*)getSucceedReultStr;

@end
