//
//  fla_Error.cpp
//  SceneEditor
//
//  Created by HJC on 12-12-17.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_Error.h"


namespace fla
{
    static struct
    {
        int         code;
        const char* desc;
    } descTable[] = {
        { Code_Success,             "success"               },
        { Error_ReadFileFails,      "read file fails"       },
        { Error_WrongFormat,        "wrong format"          },
        { Error_CheckMd5Fails,      "check md5 fails"       },
        { Error_VersionIsTooHigh,   "version is too high"   }
    };
    
    
    std::string descriptionFromCode(ErrorCode code)
    {
        for (int i = 0; i < sizeof(descTable) / sizeof(descTable[0]); i++)
        {
            if (descTable[i].code == code)
            {
                return std::string(descTable[i].desc);
            }
        }
        return "unkown error";
    }
}
