//
//  FileManager.h
//  ECiOS
//
//  Created by qinwenzhou on 14-3-14.
//  Copyright (c) 2014年 EC. All rights reserved.
//
//用来文件存储，读取
//#import <Foundation/Foundation.h>

#define kIntroducted           @"Introducted" // 引导页是否已显示
#define kEnabledSound          @"EnabledSound" // 开启声音
#define kSharedUIData          @"SharedUIData"
#define kPlaybackMode          @"PlaybackMode"

typedef enum FileType
{
    FileUnknow,
    FileTxt,
    FilePic,
    FilePDF,
    FilePPT,
    FileWord,
    FileExcel,
    FileXML,
    FileEPS,
    FileFla,
    FileGif,
    FileHTML,
    FileInd,
    FileMov,
    FilePHP,
    FileXLS,
    
} FileType;

@class UIImage;

@interface FileManager : NSObject

+ (BOOL)createDirectoryAtPath:(NSString *)dirPath;

// 获取系统配置目录
+ (NSString *)systemConfigureDir;

// 系统版本号
+ (NSInteger)appVersion;
+ (BOOL)saveAppVersion:(NSInteger)version;

// 引导页
+ (NSArray *)introductImages;
+ (BOOL)introducted;
+ (BOOL)saveIntroducted:(BOOL)flag;

// 最后一个登陆的用户
+ (NSInteger)lastLoginedUser;
+ (void)clearLastLoginedUser;
+ (BOOL)saveLastLoginedUser:(NSInteger)uid;

// 声音提醒
+ (BOOL)enabledSound:(NSInteger)user;
+ (BOOL)saveEnabledSound:(BOOL)flag user:(NSInteger)user;

// 播放模式
+ (NSInteger)playbackMode:(NSInteger)user;
+ (BOOL)savePlaybackMode:(NSInteger)mode user:(NSInteger)user;

// 用户目录
+ (NSString *)userDir:(NSInteger)uid;
+ (NSString *)userConfigure:(NSInteger)uid;
+ (NSString *)userGroupMembersDir:(NSInteger)uid;
+ (NSString *)userSendedFileDir:(NSInteger)uid;
+ (NSString *)userReceivedFileDir:(NSInteger)uid;
+ (NSString *)userAudioDir:(NSInteger)uid;
+ (NSString *)userAvatarDir:(NSInteger)uid;
+ (NSString *)userImageDir:(NSInteger)uid;
+ (NSString *)userScaledImageDir:(NSInteger)uid;
+ (NSString *)userLogsDir:(NSInteger)uid;

// 根据seq获取原图
+ (UIImage *)imageWithSeq:(NSInteger)seq user:(NSInteger)uid;

// 根据seq获取缩略图
+ (UIImage *)scaledImageWithSeq:(NSInteger)seq user:(NSInteger)uid;

// 采用默认的压缩方法压缩图片（目前均采用这个接口来创建缩率图）
+ (NSData *)scaleImage:(UIImage *)origin_image size:(NSUInteger)origin_size user:(NSInteger)uid;

// 最大化压缩图片。主要用于类似文件助手中文件的缩略图
+ (NSData *)mostScaleImage:(UIImage *)origin_image size:(NSUInteger)origin_size user:(NSInteger)uid;

// 根据文件路径获取文件类型
+ (FileType)typeForFileWithPath:(NSString *)path;

// 根据文件类型获取图标
+ (UIImage *)iconForType:(FileType)type;

// 文件大小
+ (NSString *)fileSizeStringForSize:(unsigned long long)size;

// 根据id获取头像
+ (UIImage *)avatarWithPersonid:(NSInteger)personid uid:(NSInteger)uid;

// 存储本人签名
+ (void)saveMood:(NSString *)mood withUid:(NSInteger)uid;

// 删除本人签名
+ (void)removeMoodWithUid:(NSInteger)uid;

// 获取本人签名
+ (NSString *)moodWithUid:(NSInteger)uid;

//存储客户库拉取位置
+ (void)saveCrmIndex:(NSInteger)index withUid:(NSInteger)uid;

//删除客户库拉取位置
+ (void)removeCrmIndexWithUid:(NSInteger)uid;

//获取客户库拉取位置
+ (NSInteger)crmIndexWithUid:(NSInteger)uid;


// 生成日志文件
+ (void)openLogFile:(NSInteger)uid;
+ (NSString *)logFilePath:(NSInteger)uid;

//当前城市
+ (NSString *)currentCity;
//保存当前城市
+ (BOOL)saveCurrentCity:(NSString *)city;

@end
