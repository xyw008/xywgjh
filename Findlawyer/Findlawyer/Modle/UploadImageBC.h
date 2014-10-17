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

@end
