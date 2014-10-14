//
//  PathFileFunc.h
//  huangpu
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *getPreferredLanguage();

NSString *GetDocumentPathFileName(NSString *lpFileName);
NSString *GetApplicationPath();
NSString *GetLibraryPath();
NSString *GetTmpPath();
NSString *GetApplicationPathFileName(NSString *lpFileName, NSString *lpExt);
NSString *GetTmpPathFileName(NSString *fileName);
NSString *GetTmpPathDownloadFileName(NSString *fileName);
NSString *GetTmpPathDownloadTempFileName(NSString *fileName);

NSString *GetParentPath(NSString *pFileName);
NSString *GetFileName(NSString *pFileName);
NSString *GetFileExt(NSString *pFileName);
unsigned long long GetFileSize(NSString *pFileName);
BOOL DeleteFiles(NSString *pFilePath);
BOOL CreateFolder(NSString *pPath);
BOOL FileExistsAtPath(NSString *filePath);

int IsDictionary(NSString *file);
BOOL IsFileExists(NSString *file);
BOOL IsSystemFile(NSString *filename);//filename equals to ".DS_Store"

NSArray *SimpleSearchFiles(NSString *docPath);
NSDictionary *fileAttributesOfItemAtPath(NSString *filePath, NSError **error);
