//
//  FileManager.m
//  ECiOS
//
//  Created by qinwenzhou on 14-3-14.
//  Copyright (c) 2014年 qwz. All rights reserved.
//

#import "FileManager.h"
#import "UIImage+Scale.h"

#define kAppVersion     @"AppVersion" // App本号
#define kLastUser       @"LastUser" // 上次在本机登录的用户
#define kMood           @"Mood" // 签名
#define kCrmIndex       @"kCrmIndex" //客户库拉取位置

#define AppCurrentCity     @"AppCurrentCity"  //App当前城市


@implementation FileManager

+ (BOOL)createDirectoryAtPath:(NSString *)dirPath
{
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"创建用户目录失败。错误信息：%@", [error localizedDescription]);
            return NO;
        }
    }
    
    return YES;
}

+ (NSString *)systemConfigureDir
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dir = [docsdir stringByAppendingPathComponent:@"configure"];
    if ([FileManager createDirectoryAtPath:dir])
    {
      return dir;
    }
    return nil;
}

+ (NSInteger)appVersion
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kAppVersion];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [str intValue];
    }
    return 0;
}

+ (BOOL)saveAppVersion:(NSInteger)version
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kAppVersion];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSString *str = [NSString stringWithFormat:@"%d", version];
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (NSArray *)introductImages
{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    for (int i=1; i<=4; i++)
    {
        NSString *name = nil;
        if (IS_SCREEN40)
        {
            name = [NSString stringWithFormat:@"start%d-568h.png", i];
        }
        else
        {
            name = [NSString stringWithFormat:@"start%d.png", i];
        }
        
        UIImage *img = [UIImage imageNamed:name];
        if (img)
        {
            [images addObject:img];
        }
    }
    
    return images;
}

+ (BOOL)introducted
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kIntroducted];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return NO;
    }
    else {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [str boolValue];
    }
}

+ (BOOL)saveIntroducted:(BOOL)flag
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kIntroducted];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSString *str = [NSString stringWithFormat:@"%d", flag];
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (NSInteger)lastLoginedUser
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kLastUser];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [str intValue];
    }
    return 0;
}

+ (void)clearLastLoginedUser
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kLastUser];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (BOOL)saveLastLoginedUser:(NSInteger)uid
{
    [FileManager clearLastLoginedUser];
    
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kLastUser];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    NSString *str = [NSString stringWithFormat:@"%d", uid];
    
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (BOOL)enabledSound:(NSInteger)user
{
    NSString *configureDir = [FileManager userConfigure:user];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kEnabledSound];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    else {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [str boolValue];
    }
}

+ (BOOL)saveEnabledSound:(BOOL)flag user:(NSInteger)user
{
    NSString *configureDir = [FileManager userConfigure:user];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kEnabledSound];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSString *str = [NSString stringWithFormat:@"%d", flag];
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (NSInteger)playbackMode:(NSInteger)user
{
    NSString *configureDir = [FileManager userConfigure:user];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kPlaybackMode];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return 1;
    }
    else {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [str intValue];
    }
}

+ (BOOL)savePlaybackMode:(NSInteger)mode user:(NSInteger)user
{
    NSString *configureDir = [FileManager userConfigure:user];
    NSString *file = [NSString stringWithFormat:@"%@.plist", kPlaybackMode];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSString *str = [NSString stringWithFormat:@"%d", mode];
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (NSString *)userDir:(NSInteger)uid
{
    if (uid > 0)
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dir = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", uid]];
        if ([FileManager createDirectoryAtPath:dir])
        {
            return dir;
        }
        return nil;
    }
    else
    {
        NSLog(@"获取用户目录失败，uid为0");
    }
    
    return nil;
}

+ (NSString *)userConfigure:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *configureDir = [udir stringByAppendingPathComponent:@"configure"];
        if ([FileManager createDirectoryAtPath:configureDir])
        {
            return configureDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userGroupMembersDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *groupMembersDir = [udir stringByAppendingPathComponent:@"groups"];
        if ([FileManager createDirectoryAtPath:groupMembersDir])
        {
            return groupMembersDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userSendedFileDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *fileDir = [udir stringByAppendingPathComponent:@"sndfs"];
        if ([FileManager createDirectoryAtPath:fileDir])
        {
            return fileDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userReceivedFileDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *fileDir = [udir stringByAppendingPathComponent:@"rcvfs"];
        if ([FileManager createDirectoryAtPath:fileDir])
        {
            return fileDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userAudioDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *audioDir = [udir stringByAppendingPathComponent:@"amrs"];
        if ([FileManager createDirectoryAtPath:audioDir])
        {
            return audioDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userAvatarDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *avatarDir = [udir stringByAppendingPathComponent:@"avts"];
        if ([FileManager createDirectoryAtPath:avatarDir])
        {
            return avatarDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userImageDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *picDir = [udir stringByAppendingPathComponent:@"shots"];
        if ([FileManager createDirectoryAtPath:picDir])
        {
            return picDir;
        }
        return nil;
    }
    return nil;
}

+ (NSString *)userScaledImageDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *scaleImgDir = [udir stringByAppendingPathComponent:@"scaleds"];
        if ([FileManager createDirectoryAtPath:scaleImgDir])
        {
            return scaleImgDir;
        }
        return nil;
    }
    return nil;
}

+ (UIImage *)imageWithSeq:(NSInteger)seq user:(NSInteger)uid
{
    NSString *file = [NSString stringWithFormat:@"%d.png", seq];
    NSString *dir = [FileManager userImageDir:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

+ (UIImage *)scaledImageWithSeq:(NSInteger)seq user:(NSInteger)uid
{
    NSString *file = [NSString stringWithFormat:@"%d.png", seq];
    NSString *dir = [FileManager userScaledImageDir:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

+ (UIImage *)scaleImageWithSeq:(NSInteger)seq user:(NSInteger)uid compressionQuality:(CGFloat)compressionQuality
{
    NSString *file = [NSString stringWithFormat:@"%d.png", seq];
    NSString *dir = [FileManager userScaledImageDir:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    UIImage *originImg = [FileManager imageWithSeq:seq user:uid];
    if (originImg)
    {
        UIImage *scaledImg = [UIImage scaleImage:originImg withCompressionQuality:compressionQuality];
        if (scaledImg)
        {
            NSString *scaledFile = [NSString stringWithFormat:@"%d.png", seq];
            NSString *scaledPath = [[FileManager userScaledImageDir:uid] stringByAppendingPathComponent:scaledFile];
            [UIImagePNGRepresentation(scaledImg) writeToFile:scaledPath atomically:YES];
            return scaledImg;
        }
    }
    
    return nil;
}

+ (NSData *)scaleImage:(UIImage *)origin_image size:(NSUInteger)origin_size user:(NSInteger)uid
{
    if (!origin_image)
    {
        return nil;
    }
    
    NSData *compressedData = nil;
    CGFloat cq = 0;
    if (origin_size >= 1024 * 1024) // 100K以上的图片需要先压缩尺寸再压缩质量
    {
        cq = 0.1;
    }
    else if (origin_size < 1024 * 1024 && origin_size >= 512 * 1024) // 512K到1M之间
    {
        cq = 0.4;
    }
    else if (origin_size < 512 * 1024 && origin_size >= 100 * 1024) // 100K到512K之间
    {
        cq = 0.7;
    }
    
    if (cq > 0)
    {
        UIGraphicsBeginImageContext(CGSizeMake(origin_image.size.width*cq, origin_image.size.height*cq));
        [origin_image drawInRect:CGRectMake(0, 0, origin_image.size.width*cq, origin_image.size.height*cq)];
        UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        compressedData = UIImageJPEGRepresentation(compressedImage, 0.5);
    }
    else
    {
        compressedData = UIImageJPEGRepresentation(origin_image, 0.5); // 小于100K图片不压缩尺寸，只压缩质量
    }
    
    QDLog(@"orgin size: %d, compressed size: %d, k=%.4f", origin_size, compressedData.length, compressedData.length/(origin_size * 1.0));
    return compressedData;
}

+ (NSData *)mostScaleImage:(UIImage *)origin_image size:(NSUInteger)origin_size user:(NSInteger)uid
{
    if (!origin_image)
    {
        return nil;
    }
    
    NSData *compressedData = nil;
    CGFloat cq = 0;
    if (origin_size >= 1024 * 1024) // 100K以上的图片需要先压缩尺寸再压缩质量
    {
        cq = 0.01;
    }
    else if (origin_size < 1024 * 1024 && origin_size >= 512 * 1024) // 512K到1M之间
    {
        cq = 0.05;
    }
    else if (origin_size < 512 * 1024 && origin_size >= 100 * 1024) // 100K到512K之间
    {
        cq = 0.3;
    }
    
    if (cq > 0)
    {
        UIGraphicsBeginImageContext(CGSizeMake(origin_image.size.width*cq, origin_image.size.height*cq));
        [origin_image drawInRect:CGRectMake(0, 0, origin_image.size.width*cq, origin_image.size.height*cq)];
        UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        compressedData = UIImageJPEGRepresentation(compressedImage, 0.3);
    }
    else
    {
        compressedData = UIImageJPEGRepresentation(origin_image, 0.3); // 小于100K图片不压缩尺寸，只压缩质量
    }
    
    QDLog(@"orgin size: %d, compressed size: %d, k=%.4f", origin_size, compressedData.length, compressedData.length/(origin_size * 1.0));
    return compressedData;
}

+ (FileType)typeForFileWithPath:(NSString *)path
{
    NSString *str = [path pathExtension];
    str = [str uppercaseString];
    
    if ([str isEqualToString:@"DOCX"]|| [str isEqualToString:@"DOC"] || [str isEqualToString:@"TXT"] || [str isEqualToString:@"TEXT"])
        return FileWord;
    
    if ([str isEqualToString:@"PPTX"] || [str isEqualToString:@"PPT"])
        return FilePPT;
    
    if ([str isEqualToString:@"XLSX"] || [str isEqualToString:@"XLS"])
        return FileXLS;
    
    if ([str isEqualToString:@"PDF"])
        return FilePDF;

    if ([str isEqualToString:@"XML"] || [str isEqualToString:@"HTML"])
        return FileHTML;
    
    if ([str isEqualToString:@"EPS"])
        return FileEPS;
    
    if ([str isEqualToString:@"FLA"])
        return FileFla;
    
    if ([str isEqualToString:@"GIF"])
        return FileGif;
    
    if ([str isEqualToString:@"IND"])
        return FileInd;
    
    if ([str isEqualToString:@"AVI"] || [str isEqualToString:@"RMVB"] || [str isEqualToString:@"MOV"] || [str isEqualToString:@"WMV"])
        return FileMov;
    
    if ([str isEqualToString:@"PNG"] || [str isEqualToString:@"JPEG"])
        return FilePic;
    
    return FileUnknow;
}

+ (UIImage *)iconForType:(FileType)type
{
    UIImage *icon = nil;
    
    switch (type)
    {
        case FileWord:
        case FileTxt:
            icon = [UIImage imageNamed:@"doc.png"];
            break;
            
        case FilePDF:
            icon = [UIImage imageNamed:@"pdf.png"];
            break;
            
        case FilePic:
            icon = nil; // 图片使用缩略图作为文件图标
            break;
            
        case FilePPT:
            icon = [UIImage imageNamed:@"ppt.png"];
            break;
            
        case FileXML:
        case FileHTML:
            icon = [UIImage imageNamed:@"html.png"];
            break;
            
        case FileEPS:
            icon = [UIImage imageNamed:@"eps.png"];
            break;
            
        case FileFla:
            icon = [UIImage imageNamed:@"fla.png"];
            break;
            
        case FileGif:
            icon = [UIImage imageNamed:@"gif.png"];
            break;
            
        case FileInd:
            icon = [UIImage imageNamed:@"ind.png"];
            break;
            
        case FileMov:
            icon = [UIImage imageNamed:@"mov.png"];
            break;
            
        case FilePHP:
            icon = [UIImage imageNamed:@"php.png"];
            break;
            
        case FileXLS:
            icon = [UIImage imageNamed:@"xls.png"];
            break;
            
        default:
            icon = [UIImage imageNamed:@"unknow.png"];
            break;
    }
    
    return icon;
}

+ (NSString *)fileSizeStringForSize:(unsigned long long)size
{
    NSString *str = nil;
    CGFloat M = size / (1000 * 1000.0);
    
    if ((int)M > 0)
    {
        str = [NSString stringWithFormat:@"%.1fM", M];
    }
    else
    {
        CGFloat K = size / 1000.0;
        str = [NSString stringWithFormat:@"%.1fK", K];
    }
    
    return str;
}

// 根据id获取头像
+ (UIImage *)avatarWithPersonid:(NSInteger)personid uid:(NSInteger)uid
{
    NSString *name = [NSString stringWithFormat:@"%d.png", personid];
    NSString *dic = [FileManager userAvatarDir:uid];
    NSString *path = [dic stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

// 存储本人签名
+ (void)saveMood:(NSString *)mood withUid:(NSInteger)uid
{
    [FileManager removeMoodWithUid:uid];
    
    if (mood.length > 0)
    {
        NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kMood, uid];
        NSString *dir = [FileManager userConfigure:uid];
        NSString *path = [dir stringByAppendingPathComponent:file];
        
        NSError *error = nil;
        [mood writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

// 删除本人签名
+ (void)removeMoodWithUid:(NSInteger)uid
{
    NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kMood, uid];
    NSString *dir = [FileManager userConfigure:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

// 获取本人签名
+ (NSString *)moodWithUid:(NSInteger)uid
{
    NSString *mood = nil;
    
    NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kMood, uid];
    NSString *dir = [FileManager userConfigure:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        mood = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return mood;
}

//存储客户库拉取位置
+ (void)saveCrmIndex:(NSInteger)index withUid:(NSInteger)uid
{
    [FileManager removeCrmIndexWithUid:uid];
    NSString * mood = [NSString stringWithFormat:@"%d",index];
    if (mood.length > 0)
    {
        NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kCrmIndex, uid];
        NSString *dir = [FileManager userConfigure:uid];
        NSString *path = [dir stringByAppendingPathComponent:file];
        
        NSError *error = nil;
        [mood writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }

}

//删除客户库拉取位置
+ (void)removeCrmIndexWithUid:(NSInteger)uid
{
    NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kCrmIndex, uid];
    NSString *dir = [FileManager userConfigure:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }

}

//获取客户库拉取位置
+ (NSInteger)crmIndexWithUid:(NSInteger)uid
{
    NSString *mood = nil;
    
    NSString *file = [NSString stringWithFormat:@"%@_%d.plist", kCrmIndex, uid];
    NSString *dir = [FileManager userConfigure:uid];
    NSString *path = [dir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        mood = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    if (mood == nil) {
        return 0;
    }
    return [mood integerValue];

}

+ (NSString *)userLogsDir:(NSInteger)uid
{
    NSString *udir = [FileManager userDir:uid];
    if (udir)
    {
        NSString *logsDir = [udir stringByAppendingPathComponent:@"logs"];
        if ([FileManager createDirectoryAtPath:logsDir])
        {
            return logsDir;
        }
        return nil;
    }
    return nil;
}

+ (void)openLogFile:(NSInteger)uid
{
#ifndef DEBUG
    NSString *logFilePath = [FileManager logFilePath:uid];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
#endif
}

+ (NSString *)logFilePath:(NSInteger)uid
{
#ifndef DEBUG
    NSString *logsDir = [FileManager userLogsDir:uid];
    return [logsDir stringByAppendingPathComponent:@"eclite.log"];
#else
    return nil;
#endif
}

+ (NSString *)currentCity
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", AppCurrentCity];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return str;
    }
    return @"深圳";
}

+ (BOOL)saveCurrentCity:(NSString *)city
{
    NSString *configureDir = [FileManager systemConfigureDir];
    NSString *file = [NSString stringWithFormat:@"%@.plist", AppCurrentCity];
    NSString *path = [configureDir stringByAppendingPathComponent:file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@", city];
    NSError *error = nil;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}


@end
