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
    
    NSMutableDictionary     *_uploadSucceedDic;//上传成功数组（value:上传的原图片 key:上传成功返回字符串）
    
    UIImage                 *_nowUploadingImg;//现在正在上传的图片
//    NSString                *_nowUploadingPathStr;//现在正在上传的图片路径
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
        _uploadSucceedDic = [[NSMutableDictionary alloc] init];
        if ([array isAbsoluteValid])
            [self addUploadImgArray:array];
        
    }
    return self;
}

- (void)addUploadImg:(UIImage *)img
{
    BOOL containsThisImg = NO;;
    
//    for (NSString *key in _uploadImgDic.allKeys)
//    {
//        if ([[_uploadImgDic objectForKey:key] isEqual:img])
//        {
//            containsThisImg = YES;
//            break;
//        }
//    }
    
    if ([_uploadImgArray containsObject:img]) {
        containsThisImg = YES;
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
//    if (_nowUploadingPathStr == nil)
    if (_nowUploadingImg == nil)
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

#pragma mark - delete image method
//删除图片
- (void)deleteImg:(UIImage *)img
{
    //默认是没上传成功的图片
    BOOL _isSucceedImg = NO;
    
    for (NSString *key in [_uploadSucceedDic allKeys])
    {
        id succeedImg = [_uploadSucceedDic objectForKey:key];
        
        //如果是已经上传成功了的图片
        if ([succeedImg isEqual:img])
        {
            _isSucceedImg = YES;
            [_uploadSucceedDic removeObjectForKey:key];
            break;
        }
    }
    
    //没上传成功的图片
    if (!_isSucceedImg)
    {
        if ([_uploadImgArray containsObject:img])
        {
            [_uploadImgArray removeObject:img];
            //从上传图片数组移除
            for (NSString *key in _uploadImgDic)
            {
                id containtImg = [_uploadImgDic objectForKey:key];
                if ([containtImg isEqual:img])
                {
                    [_uploadImgDic removeObjectForKey:key];
                    break;
                }
            }
        }
    }
}

#pragma mark - get succeedStr
- (NSString *)getSucceedReultStr
{
    if (_uploadSucceedDic.allKeys > 0)
        return [_uploadSucceedDic.allKeys componentsJoinedByString:@"|"];
    return @"";
}

#pragma mark - request method

- (void)uploadImgRequest
{
    //现在没有图片上传
//    if (_nowUploadingPathStr == nil && [_uploadImgArray isAbsoluteValid])
    if (_nowUploadingImg == nil && [_uploadImgArray isAbsoluteValid])
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
//                    _nowUploadingPathStr = imgPath;
                    _nowUploadingImg = img;
                    DLog(@"img path = %@",imgPath);
                    
                    
                    NSURL *url =  [[NSURL alloc] initWithString:@"http://test3.sunlawyers.com/AppService/UploadHandler.ashx?fn=AddAskPhoto"];
                    
                    [[NetRequestManager sharedInstance] sendUploadRequest:url parameterDic:@{@"askId":_askId} requestMethodType:RequestMethodType_POST requestTag:NetConsultInfoRequestType_PostPhoto delegate:self fileDic:@{@"Filedata":imgPath}];
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
            //如果正在上传的图片成功上传后 还没有从 上传图片数组里面删除 （表示用户没有手动删除过）
            if ([_uploadImgArray containsObject:_nowUploadingImg])
            {
                NSString *infoStr = [[NSString alloc] initWithData:infoObj encoding:NSUTF8StringEncoding];
                
                //保存上传成功图片和对应的服务器返回值
                if (infoStr)
                    [_uploadSucceedDic setObject:_nowUploadingImg forKey:infoStr];
                
                [_uploadImgArray removeObjectAtIndex:0];
            }
//            _nowUploadingPathStr = nil;
            _nowUploadingImg = nil;
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
//        _nowUploadingPathStr = nil;
        _nowUploadingImg = nil;
        _stateBlock (NO);
    }
}

@end
