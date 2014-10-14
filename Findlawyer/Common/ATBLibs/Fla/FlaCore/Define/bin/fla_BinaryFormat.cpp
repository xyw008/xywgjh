//
//  fla_BinaryFormate.cpp
//  SceneEditor
//
//  Created by HJC on 12-11-6.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_BinaryFormat.h"
#include "util_strAddtions.h"
#include <sstream>


namespace fla
{
    namespace bin
    {
        void writeTagAndLen(Data& data, int tag, int len)
        {
            if (len < 0x3f)
            {
                uint16_t tagAndLen = (tag << 6) | len;
                writeUI16(data, tagAndLen);
            }
            else
            {
                uint16_t tagAndLen = (tag << 6) | 0x3f;
                writeUI16(data, tagAndLen);
                writeUI32(data, len);
            }
        }
        
        
        void readTagAndLen(const uint8_t*& ptr, int& tag, int& len)
        {
            int tagAndLen = readUI16(ptr);
            int tagLen = tagAndLen & 0x3f;
            if (tagLen == 0x3f)
            {
                tagLen = readUI32(ptr);
            }
            tag = tagAndLen >> 6;
            len = tagLen;
        }
        
        
        std::string resourceBasePath(const std::string& filePath)
        {
            std::string basePath = util::str_deletingLastPathComponent(filePath);
            std::string name = util::str_lastPathComponent(filePath);
            name = util::str_deletingPathExtension(name);
            name += ".Resources";
            return util::str_appendingPathComponent(basePath, name);
        }
        
        
        
        std::string sharedBasePath(const std::string& filePath)
        {
            std::string basePath = util::str_deletingLastPathComponent(filePath);
            std::string name = "Shared.Resources";
            return util::str_appendingPathComponent(basePath, name);
        }
        
        
        
        std::string nameOfDefine(const Define& define)
        {
            std::stringstream stream;
            if (!define.name().empty())
            {
                stream << define.name() << "_";
            }
            
            stream << define.Id();
            
            if (define.type() == DefineType_Image)
            {
                stream << ".png";
            }
            else if (define.type() == DefineType_Font)
            {
                stream << ".bin";
            }
            return stream.str();
        }
        
        
        void writeColorTrans(Data& data, const ColorTransform& trans)
        {
            uint8_t flags = 0;
            if (trans.isIdentity())
            {
                flags |= 0x01;
                writeUI8(data, flags);
                return;
            }
            
            auto saveLen = data.size();
            writeUI8(data, flags);
            
            if (trans.rMult() != 1 || trans.rAdd() != 0)
            {
                flags |= 0x02;
                writeFloat(data, trans.rMult());
                writeFloat(data, trans.rAdd());
            }
            
            if (trans.gMult() != 1 || trans.gAdd() != 0)
            {
                flags |= 0x04;
                writeFloat(data, trans.gMult());
                writeFloat(data, trans.gAdd());
            }
            
            if (trans.bMult() != 1 || trans.bAdd() != 0)
            {
                flags |= 0x08;
                writeFloat(data, trans.bMult());
                writeFloat(data, trans.bAdd());
            }
            
            if (trans.aMult() != 1 || trans.aAdd() != 0)
            {
                flags |= 0x10;
                writeFloat(data, trans.aMult());
                writeFloat(data, trans.aAdd());
            }
            
            data[saveLen] = flags;
        }
        
        
        ColorTransform readColorTrans(const uint8_t*& ptr)
        {
            float_t rMult = 1.0, gMult = 1.0, bMult = 1.0, aMult = 1.0;
            float_t rAdd = 0.0,  gAdd = 0.0, bAdd = 0.0, aAdd = 0.0;
            
            uint8_t flags = readUI8(ptr);
            if (flags & 0x01)
            {
                return ColorTransform();
            }
            
            if (flags & 0x02)
            {
                rMult = readFloat(ptr);
                rAdd = readFloat(ptr);
            }
            
            if (flags & 0x04)
            {
                gMult = readFloat(ptr);
                gAdd = readFloat(ptr);
            }
            
            if (flags & 0x08)
            {
                bMult = readFloat(ptr);
                bAdd = readFloat(ptr);
            }
            
            if (flags & 0x10)
            {
                aMult = readFloat(ptr);
                aAdd = readFloat(ptr);
            }
            
            return ColorTransform(rMult, gMult, bMult, aMult,
                                  rAdd, gAdd, bAdd, aAdd);
        }

    }
}


