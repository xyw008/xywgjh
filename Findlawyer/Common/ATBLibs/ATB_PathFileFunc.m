//
//  PathFileFunc.m
//  used only above IOS 5.0 SDK
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_PathFileFunc.h"

//获得设备当前的语言配置
NSString *getPreferredLanguage()
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

NSString *GetDocumentPathFileName(NSString *lpFileName){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths == nil) return nil;
	
    NSString *documentsDirectory = [paths objectAtIndex:0];
	if (documentsDirectory == nil) return nil;
	
    if (nil != lpFileName)
        return [documentsDirectory stringByAppendingPathComponent:lpFileName];
    return documentsDirectory;
}

NSString *GetApplicationPath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    if (nil == paths) return nil;
    return [paths objectAtIndex:0];
}

NSString *GetLibraryPath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (nil == paths) return nil;
    return [paths objectAtIndex:0];
}

NSString *GetTmpPath()
{
    NSString *tmpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    return tmpPath;
}

NSString *GetApplicationPathFileName(NSString *lpFileName, NSString *lpExt){
    if (nil == lpFileName) return nil;
    return [[NSBundle mainBundle] pathForResource:lpFileName ofType:lpExt];
}

NSString *GetTmpPathFileName(NSString *fileName)
{
    return [GetTmpPath() stringByAppendingPathComponent:fileName];
}

NSString *GetTmpPathDownloadFileName(NSString *fileName)
{
    if (!FileExistsAtPath([GetTmpPath() stringByAppendingPathComponent:@"download"]))
        CreateFolder([GetTmpPath() stringByAppendingPathComponent:@"download"]);
    
    return [GetTmpPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"download/%@",fileName]];
}

NSString *GetTmpPathDownloadTempFileName(NSString *fileName)
{
    if (!FileExistsAtPath([GetTmpPath() stringByAppendingPathComponent:@"download/temp"]))
        CreateFolder([GetTmpPath() stringByAppendingPathComponent:@"download/temp"]);
    
    return [GetTmpPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"download/temp/%@",fileName]];
}

NSString *GetParentPath(NSString *pFileName){
    if (nil == pFileName) return nil;
    NSRange path = [pFileName rangeOfString:@"/" options:NSBackwardsSearch];
    if (path.length > 0){
        pFileName = [pFileName substringToIndex:path.location];
        return pFileName;
    }
    return nil;
}

NSString *GetFileName(NSString *pFileName){
    if (nil == pFileName) return nil;
    NSRange path = [pFileName rangeOfString:@"/" options:NSBackwardsSearch];
    if (path.length > 0)
        pFileName = [pFileName substringFromIndex:path.location+1];
    
    NSRange range = [pFileName rangeOfString:@"." options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    if (range.length == 0) return pFileName;
    return [pFileName substringToIndex:range.location];
}

NSString *GetFileExt(NSString *pFileName){
    if (nil == pFileName) return nil;
    NSRange range = [pFileName rangeOfString:@"." options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    if (range.length == 0) return nil;
    return [pFileName substringFromIndex:range.location+1];
}

unsigned long long GetFileSize(NSString *pFileName){
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:pFileName error:nil];
    return [dic fileSize];
}

BOOL DeleteFiles(NSString *pFilePath){
    return [[NSFileManager defaultManager] removeItemAtPath:pFilePath error:nil];
}

BOOL CreateFolder(NSString *pPath){
    return [[NSFileManager defaultManager] createDirectoryAtPath:pPath withIntermediateDirectories:YES attributes:nil error:NULL];
}

BOOL FileExistsAtPath(NSString *filePath)
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

int IsDictionary(NSString *file){
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES == [fm fileExistsAtPath:file isDirectory:&isDir]){
        return isDir;
    }
    return -1;
}

BOOL IsFileExists(NSString *file){
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:file];
}

BOOL IsSystemFile(NSString *filename){
    return ([filename compare:@".DS_Store"] == NSOrderedSame);
}

NSArray* SimpleSearchFiles(NSString *docPath){
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm contentsOfDirectoryAtPath:docPath error:nil];
}

NSDictionary *fileAttributesOfItemAtPath(NSString *filePath, NSError **error)
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager attributesOfItemAtPath:filePath error:error];
}
