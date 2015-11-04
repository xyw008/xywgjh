//
//  AppPropertiesInitialize.m
//  o2o
//
//  Created by swift on 14-7-22.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "AppPropertiesInitialize.h"

static NSString * const kRecipesStoreName = @"Recipes.sqlite";

static UIView *statusBarCoverView = nil;

@implementation AppPropertiesInitialize

+ (void)startAppPropertiesInitialize
{
    // 开启网络状态监听
    [NetworkStatusManager startNetworkStatusNotifier];
    
    /*
     在执行App之前必须进到"设定"去,去设定App的值
     连settings.bundle內对各控件进行设定的预设值也沒有办法一开始就直接被读取
     所以要对NSUserDefault的Key注册预设值,值的来源是Settings.Bundle的DefaultValue
     */
    if ([self settingsBundleDefaultValues])
    {
        [[NSUserDefaults standardUserDefaults] registerDefaults:[self settingsBundleDefaultValues]];
    }
    
    // 开启键盘管理
    [self setKeyboardManagerEnable:YES];
    
    // 本地化语言
    [LanguagesManager initialize];
    
    // 初始化coreData库
    // [self copyDefaultStoreIfNecessary];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
    
    // 清空通知数字显示
    [UIFactory clearApplicationBadgeNumber];
    
    // ...
}

// 用来取得Settings.Bundle各控件的预设值
+ (NSDictionary *)settingsBundleDefaultValues
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"plist" inDirectory:@"Settings.bundle"];
    if (filePath)
    {
        NSMutableDictionary *defaultDic = [NSMutableDictionary dictionary];
        
        NSURL *settingsUrl = [NSURL fileURLWithPath:filePath isDirectory:YES];
        
        NSDictionary *settingBundle = [NSDictionary dictionaryWithContentsOfURL:settingsUrl];
        
        NSArray *preference = [settingBundle objectForKey:@"PreferenceSpecifiers"];
        
        for (NSDictionary *component in preference)
        {
            NSString *key = [component objectForKey:@"Key"];
            NSString *defaultValue = [component objectForKey:@"DefaultValue"];
            
            if (!key || !defaultValue) continue;
            
            if (![component objectForKey:key])
            {
                [defaultDic setObject:defaultValue forKey:key];
            }
        }
        return defaultDic;
    }
    return nil;
}

+ (void)setKeyboardManagerEnable:(BOOL)enable
{
    // Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:enable];
    
    // Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:enable];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:enable];
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:NO];
    if (IOS7) [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:enable];
}

+ (void)setBackgroundColorToStatusBar:(UIColor *)color
{
    if (!statusBarCoverView)
    {
        CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
        statusBarCoverView = [[UIView alloc] initWithFrame:statusBarRect];
        statusBarCoverView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [[UIApplication sharedApplication].keyWindow addSubview:statusBarCoverView];
    }
    statusBarCoverView.backgroundColor = color;
}

+ (void) copyDefaultStoreIfNecessary;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kRecipesStoreName];
    
    // 判断沙盒里储存数据库文件的文件夹是否存在
    NSString *storeFolder = [[storeURL path] stringByDeletingLastPathComponent];
    if (!IsFileExists(storeFolder))
    {
        CreateFolder(storeFolder);
    }
    
    // 项目中是否添加了数据库文件
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kRecipesStoreName stringByDeletingPathExtension] ofType:[kRecipesStoreName pathExtension]];
    
    if (defaultStorePath)
    {
        // 如果沙盒里面有数据库文件且和项目中的数据库文件不一样就删除旧的
        if ([fileManager fileExistsAtPath:[storeURL path]])
        {
            NSDictionary *attributesOfStoreFile = [fileManager attributesOfItemAtPath:[storeURL path] error:nil];
            NSDictionary *attributesOfDefaultFile = [fileManager attributesOfItemAtPath:defaultStorePath error:nil];
            
            if (!(attributesOfStoreFile.fileSize == attributesOfDefaultFile.fileSize && [attributesOfStoreFile.fileModificationDate compare:attributesOfDefaultFile.fileModificationDate] == NSOrderedSame) &&
                DeleteFiles([storeURL path]))
            {
                // 把项目中的数据库文件再复制到沙盒里
                NSError *error;
                BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
                if (!success)
                {
                    NSLog(@"Failed to install default recipe store");
                }
            }
        }
        else
        {
            // 直接把项目中的数据库文件复制到沙盒里
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default recipe store");
            }
        }
    }
}

@end
