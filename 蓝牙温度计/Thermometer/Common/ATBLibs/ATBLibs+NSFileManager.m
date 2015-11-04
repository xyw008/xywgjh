//
//  ATBLibs+NSFileManager.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+NSFileManager.h"
#include <dirent.h>

@implementation NSFileManager(ATBLibsAddtions)


+ (NSString*) documentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}



+ (NSString*) resourcePath
{
	return [[NSBundle mainBundle] resourcePath];
}


+ (NSString*) cachesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


+ (NSString*) temporaryPath
{
    return NSTemporaryDirectory();
}



+ (BOOL) letDirectoryExistsAtPath:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath])
	{
		return YES;
	}
    
	NSArray* array = [filePath componentsSeparatedByString:@"/"];
    NSString* oldCurrentDir = [fileManager currentDirectoryPath];
    
    if ([filePath hasPrefix:@"/"])
    {
        [fileManager changeCurrentDirectoryPath:@"/"];
    }
	
	for (NSString* string in array)
	{
		if ([string length] > 0)
		{
			BOOL isDirectory = TRUE;
			if (![fileManager fileExistsAtPath:string isDirectory:&isDirectory] || 
				!isDirectory)
			{
				[fileManager createDirectoryAtPath:string 
                       withIntermediateDirectories:YES 
                                        attributes:nil 
                                             error:nil];
			}
			[fileManager changeCurrentDirectoryPath:string];
		} 
	}
    
    [fileManager changeCurrentDirectoryPath:oldCurrentDir];
	return [fileManager fileExistsAtPath:filePath];
}





+ (NSString*) makeUniqueFileName:(NSString*)fileName basePath:(NSString*)basePath isDirectory:(BOOL)isDirectory
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:basePath];
	
	// 有重名
	if ([fileManager fileExistsAtPath:fileName])
	{
		NSString* pathExtension = isDirectory ? @"" : [fileName pathExtension];
		NSString* saveFilePath = isDirectory ? fileName : [fileName stringByDeletingPathExtension];
		
		NSInteger count = 2;
		if ([saveFilePath hasSuffix:@")"])
		{
			NSRange range = [saveFilePath rangeOfString:@"(" options:NSBackwardsSearch];
			if (range.location != NSNotFound)
			{
				NSRange subRange;
				subRange.location = range.location + 1;
				subRange.length = [saveFilePath length] - subRange.location - 1;
				NSString* subString = [saveFilePath substringWithRange:subRange];
				
				BOOL allDigits = TRUE;
				for (NSInteger idx = 0; idx < [subString length]; idx++)
				{
					unichar c = [subString characterAtIndex:idx];
					if (c > '9' || c < '0')
					{
						allDigits = FALSE;
						break;
					}
				}
				
				if (allDigits)
				{
					count = [subString intValue];
					saveFilePath = [saveFilePath substringToIndex:range.location];
				}
			}
		}
		
		do
		{
			fileName = [saveFilePath stringByAppendingFormat:@"(%d)", count++];
			if ([pathExtension length])
			{
				fileName = [fileName stringByAppendingPathExtension:pathExtension];
			}
		} while ([fileManager fileExistsAtPath:fileName]);
	}
	return fileName;
}



+ (NSString*) makeUniqueFilePath:(NSString*)filePath isDirectory:(BOOL)isDirectory
{
	NSString* name = [filePath lastPathComponent];
	NSString* basePath = [filePath stringByDeletingLastPathComponent];
	
	name = [NSFileManager makeUniqueFileName:name basePath:basePath isDirectory:isDirectory];
	return [basePath stringByAppendingPathComponent:name];
}




static void ATFileTravelPath(NSString* basePath, NSString* refPath, BOOL(^block)(NSString* refPath, NSString* name, ATFileType fileType))
{
    NSString* fullPath = [basePath stringByAppendingPathComponent:refPath];
    DIR* dir = opendir([fullPath length] ? [fullPath fileSystemRepresentation] : ".");
    if (dir == NULL)
    {
        return;
    }
    
    struct dirent* ent = NULL;
    while ((ent = readdir(dir)) != NULL)
    {
        if (ent->d_name[0] != '.')
        {
            ATFileType fileType = ATFileType_None;
            if (ent->d_type == DT_DIR)  
            {
                fileType = ATFileType_Dir;
            }
            else if (ent->d_type == DT_REG)
            {
                fileType = ATFileType_Reg;
            }
            
            NSString* name = [NSString stringWithUTF8String:ent->d_name];
            BOOL result = block(refPath, name, fileType);
            if (result && fileType == ATFileType_Dir)
            {
                NSString* newPath = name;
                if ([newPath length] > 0)
                {
                    newPath = [refPath stringByAppendingPathComponent:name];
                }
                ATFileTravelPath(basePath, newPath, block);
            }
        }
    }
    closedir(dir);
}


+ (void) fileTravelPath:(NSString*)basePath 
                  block:(BOOL(^)(NSString* refPath, NSString* name, ATFileType fileType))block
{
    ATFileTravelPath(basePath, @"", block);
}


@end
