//
//  fla_BinaryReader.h
//  SceneEditor
//
//  Created by HJC on 12-11-6.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_BINARYREADER__
#define __fla_BinaryReader__


#include <map>
#include "fla_Define.h"
#include "fla_DefineUtils.h"
#include "fla_Error.h"



namespace fla
{
    class DefineSprite;
    class BinaryReader
    {
    public:
        BinaryReader()
        {
            _frameRate = 24;
            _rootId = 0;
            _checkMd5 = true;
        }
        
        float   frameRate() const                       {   return _frameRate;                      }
        int     rootId() const                          {   return _rootId;                         }
        DefinePtr root() const                          {   return mapFindDefine(_dict, _rootId);   }
        const std::map<int, DefinePtr>& dict() const    {   return _dict;                           }
        
        ErrorCode readFilePath(const std::string& filePath, bool checkMd5);
        
    private:
        bool      parseHeader(const uint8_t*& ptr, int len);
        DefinePtr parseDefine(const uint8_t* ptr, int tag, int len);
        DefinePtr parseScene(const uint8_t* ptr, int len);
        DefinePtr parseSprite(const uint8_t* ptr, int len);
        DefinePtr parseMorphShape(const uint8_t* ptr, int len);
        DefinePtr parseShape(const uint8_t* ptr, int len);
        DefinePtr parseRole(const uint8_t* ptr, int len);
        DefinePtr parseFont(const uint8_t* ptr, int len);
        DefinePtr parseImage(const uint8_t* ptr, int len);
        DefinePtr parseText(const uint8_t* ptr, int len);
        void      parseSprite(DefineSprite& sprite, const uint8_t* ptr);

    private:
        bool                        _checkMd5;
        std::string                 _filePath;
        std::map<int, DefinePtr>    _dict;
        float                       _frameRate;
        int                         _rootId;
    };
}

#endif



