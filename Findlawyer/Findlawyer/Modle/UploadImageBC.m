//
//  UploadImageBC.m
//  Find lawyer
//
//  Created by leo on 14-10-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "UploadImageBC.h"
#import "NetRequestManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface UploadImageBC()<NetRequestDelegate>
{
    NSMutableArray          *_uploadImgArray;//上传数组
    NSMutableDictionary     *_uploadImgDic;//上传字典（key： imgage%d.jpeg）
    
    NSString                *_nowUploadingPathStr;//现在正在上传的图片路径
    NSInteger               _imgId;//图片的ID 只加不减
    
    UploadImage             _stateBlock;
    NSString                *_askId;
}

@end

@implementation UploadImageBC

- (instancetype)initWithAskId:(NSString *)askId UploadImgArray:(NSArray *)array uploadStateBlock:(UploadImage)suceessOrFail
{
    self = [super init];
    if (self)
    {
        _imgId = 0;
        _askId = askId;
        _stateBlock = suceessOrFail;
        _uploadImgArray = [[NSMutableArray alloc] init];
        _uploadImgDic = [[NSMutableDictionary alloc] init];
        if ([array isAbsoluteValid])
            [self addUploadImgArray:array];
        
    }
    return self;
}

- (void)addUploadImg:(UIImage *)img
{
    BOOL containsThisImg = NO;;
    for (NSString *key in _uploadImgDic.allKeys)
    {
        if ([[_uploadImgDic objectForKey:key] isEqual:img])
        {
            containsThisImg = YES;
            break;
        }
    }
    
    //不包含
    if (!containsThisImg)
    {
        NSData *imageData = UIImageJPEGRepresentation(img ,0.1);
        NSString *suffix = [NSString stringWithFormat:@"imgage%d.jpeg",_imgId];
        [imageData writeToFile:[self getImageTempPath:suffix] atomically:YES];
        
        _imgId++;
        [_uploadImgArray addObject:img];
        [_uploadImgDic setObject:img forKey:suffix];
    }
    if (_nowUploadingPathStr == nil)
    {
        [self uploadImgRequest];
    }
}

- (void)addUploadImgArray:(NSArray *)array
{
    if ([array isAbsoluteValid])
    {
        for (UIImage *img in array)
        {
            [self addUploadImg:img];
        }
    }
}

- (NSString*)getImageTempPath:(NSString*)imgName
{
    return [[NSFileManager temporaryPath] stringByAppendingPathComponent:imgName];
}

#pragma mark - request method

- (void)uploadImgRequest
{
    //现在没有图片上传
    if (_nowUploadingPathStr == nil && [_uploadImgArray isAbsoluteValid])
    {
        UIImage *img = [_uploadImgArray objectAtIndex:0];
        if ([img isKindOfClass:[UIImage class]])
        {
            NSString *keyStr;
            for (NSString *key in [_uploadImgDic allKeys])
            {
                if ([[_uploadImgDic objectForKey:key] isEqual:img])
                {
                    keyStr = key;
                }
            }
            if (keyStr)
            {
                NSString *imgPath = [self getImageTempPath:keyStr];
                
                NSFileManager *defaultFile = [NSFileManager defaultManager];
                if ([defaultFile fileExistsAtPath:imgPath] )
                {
                    _nowUploadingPathStr = imgPath;
                    
                    
                    NSURL *url =  [[NSURL alloc] initWithString:@"http://test3.sunlawyers.com/AppService/UploadHandler.ashx?fn=AddAskPhoto"];
                    
                    [[NetRequestManager sharedInstance] sendUploadRequest:url parameterDic:@{@"askId":_askId} requestMethodType:RequestMethodType_POST requestTag:NetConsultInfoRequestType_PostPhoto delegate:self fileDic:@{@"path":imgPath}];
                }
            }
        }
        else
        {
            [self failJudgeUplodaImgNum];
        }
    }
    else
    {
        _stateBlock (YES);
    }
}

#pragma mark - NetRequest delegate
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    switch (request.tag)
    {
        case NetConsultInfoRequestType_PostPhoto:
        {
            [_uploadImgArray removeObjectAtIndex:0];
            _nowUploadingPathStr = nil;
            [self uploadImgRequest];
        }
            break;
            
        default:
            break;
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [self failJudgeUplodaImgNum];
}

- (void)failJudgeUplodaImgNum
{
    if (_uploadImgArray.count > 1)
    {
        //如果有多个图片在上传，这个失败了就把它移动到数组最后一位。然后继续下面的图片上传
        UIImage *img = [_uploadImgArray objectAtIndex:0];
        [_uploadImgArray removeObjectAtIndex:0];
        [_uploadImgArray addObject:img];
        [self uploadImgRequest];
    }
    else
    {
        _nowUploadingPathStr = nil;
        _stateBlock (NO);
    }
}

@end
