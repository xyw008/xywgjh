//
//  fla_Error.h
//  SceneEditor
//
//  Created by HJC on 12-12-17.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_ERROR__
#define __FLA_ERROR__

#include <string>

namespace fla
{
    enum ErrorCode
    {
        Code_Success            =   0,  // 成功，无错误
        Error_ReadFileFails     =   1,  // 读取文件失败，有可能是权限不够或者无这个文件
        Error_WrongFormat       =   2,  // 错误格式
        Error_CheckMd5Fails     =   3,  // 文件可能经过修改或者不完整，导致md5检验失败
        Error_VersionIsTooHigh  =   4,  // 不能读取高版本
    };
    
    std::string descriptionFromCode(ErrorCode code);
}


#endif
