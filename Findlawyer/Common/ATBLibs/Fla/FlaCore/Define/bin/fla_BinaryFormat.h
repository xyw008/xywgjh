//
//  fla_BinaryFormate.h
//  SceneEditor
//
//  Created by HJC on 12-11-6.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_BINARYFORMATE__
#define __FLA_BINARYFORMATE__


#include <stdint.h>
#include <vector>
#include "fla_Define.h"
#include "fla_ColorTransform.h"
#include "fla_Path.h"
#include "fla_Color4.h"
#include "fla_Point.h"
#include "fla_Rect.h"
#include "fla_Matrix.h"


namespace fla
{
    namespace bin
    {
        typedef std::vector<uint8_t>    Data;
        
        
        enum TagType
        {
            TagType_Header  =   0,
            TagType_Shape   =   1,  // 形状
            TagType_Sprite  =   2,  // 动画
            TagType_Scene   =   3,  // 场景
            TagType_Role    =   4,  // 角色
            TagType_Font    =   5,  // 字体
            TagType_Image   =   6,  // 图片
            TagType_Text    =   7,  // 文字
            TagType_MorphShape = 8, // 形变
        };
        
        
        enum PlaceObjFlags
        {
            PlaceObjFlags_Use16BitFlag      =   0x01,
            PlaceObjFlags_Remove            =   0x02,
            PlaceObjFlags_HasCharacterID    =   0x04,
            PlaceObjFlags_HasTrans          =   0x08,
            PlaceObjFlags_HasColorTrans     =   0x10,
            PlaceObjFlags_HasRatio          =   0x20,
            PlaceObjFlags_HasClipDepth      =   0x40,
        };
        
        
        
        enum RoleStateFlags
        {
            RoleStateFlags_IsRef    =   0x01,
            RoleStateFlags_IsEnd    =   0x02,
        };
        
        
        enum
        {
            HeaderFlags_zipCompress     =   0x0001,   // 使用zip压缩
        };
        
        
        enum
        {
            LineStyleFlag_OnlyWidthAndColor = 0x0001,   
        };
        
    
        struct Header
        {
            uint8_t     md5[16];        //  检验，默认为md5
            
            // 从这里开始计算md5，包括版本号和flags
            uint8_t     magic[4];       //  魔数，一定为, atjc,
            uint8_t     majorVersion;   //  主版本号
            uint8_t     minorVersion;   //  次版本号
            uint32_t    flags;          //  标志位, 指明后面的数字是否有压缩
            
            // 当zipCompress标志位为1之后，后面的数据需要先进行zip解压
        };
        
        

        // 这里隐含一个条件，数据格式一定为小尾顺序
        inline void writeBytes(Data& data, const uint8_t* bytes, size_t len)
        {
            data.insert(data.end(), bytes, bytes + len);
        }
        
        inline void readBytes(const uint8_t*& cur, uint8_t* bytes, size_t len)
        {
            memcpy(bytes, cur, len);
            cur += len;
        }
        
        
        inline void writeData(Data& data, const Data& other)
        {
            data.insert(data.end(), other.begin(), other.end());
        }
        
            
        /////////////////////////////////////////////////////////////////////////////////////
        
        void writeTagAndLen(Data& data, int tag, int len);
        void readTagAndLen(const uint8_t*& ptr, int& tag, int& len);
    
        
        inline void writeUI16(Data& data, uint16_t v)
        {
            writeBytes(data, (uint8_t*)&v, 2);
        }
        
        
        inline void writeSI16(Data& data, int16_t v)
        {
            writeBytes(data, (uint8_t*)&v, 2);
        }
        
        
        inline uint16_t readUI16(const uint8_t*& ptr)
        {
            uint16_t v;
            readBytes(ptr, (uint8_t*)&v, 2);
            return v;
        }
        
        
        inline int16_t readSI16(const uint8_t*& ptr)
        {
            int16_t v;
            readBytes(ptr, (uint8_t*)&v, 2);
            return v;
        }
        
        
        inline void writeUI32(Data& data, uint32_t v)
        {
            writeBytes(data, (uint8_t*)&v, 4);
        }
        
        inline void writeUI8(Data& data, uint8_t v)
        {
            writeBytes(data, &v, 1);
        }
        
        inline void writeSI8(Data& data, int8_t v)
        {
            writeBytes(data, (uint8_t*)&v, 1);
        }
        
        inline uint8_t readUI8(const uint8_t*& ptr)
        {
            uint8_t v;
            readBytes(ptr, &v, 1);
            return v;
        }
        
        inline int8_t readSI8(const uint8_t*& ptr)
        {
            int8_t v;
            readBytes(ptr, (uint8_t*)&v, 1);
            return v;
        }
        
        
        inline uint32_t readUI32(const uint8_t*& ptr)
        {
            uint32_t v;
            readBytes(ptr, (uint8_t*)&v, 4);
            return v;
        }
        
        
        inline void writeFloat(Data& data, float v)
        {
            static_assert(sizeof(v) == 4, "");
            writeBytes(data, (uint8_t*)&v, 4);
        }
        
    
        inline float readFloat(const uint8_t*& ptr)
        {
            static_assert(sizeof(float) == 4, "");
            float v;
            readBytes(ptr, (uint8_t*)&v, 4);
            return v;
        }
        
        
        inline void writeString(Data& data, const std::string& str)
        {
            for (auto c : str)
            {
                writeUI8(data, c);
            }
            writeUI8(data, 0);
        }
        
        
        inline std::string readString(const uint8_t*& ptr)
        {
            std::string buf;
            char c = 0;
            while ((c = *ptr++))
            {
                buf.push_back(c);
            }
            return buf;
        }
        
        
        inline void writeSize(Data& data, const CGSize& size, float scale)
        {
            writeFloat(data, size.width * scale);
            writeFloat(data, size.height * scale);
        }
        
        inline CGSize readSize(const uint8_t*& ptr)
        {
            float width = readFloat(ptr);
            float height = readFloat(ptr);
            return CGSizeMake(width, height);
        }
        
        
        inline void writePoint(Data& data, const Point& pt, float scale)
        {
            writeFloat(data, pt.x * scale);
            writeFloat(data, pt.y * scale);
        }
        
        
        inline Point readPoint(const uint8_t*& ptr)
        {
            float x = readFloat(ptr);
            float y = readFloat(ptr);
            return Point(x, y);
        }
        
        
        inline void writeColor(Data& data, const Color4& color)
        {
            writeUI8(data, color.red * 255);
            writeUI8(data, color.green * 255);
            writeUI8(data, color.blue * 255);
            writeUI8(data, color.alpha * 255);
        }
        
        
        inline Color4 readColor(const uint8_t*& ptr)
        {
            Color4 color;
            color.red = readUI8(ptr) / 255.0;
            color.green = readUI8(ptr) / 255.0;
            color.blue = readUI8(ptr) / 255.0;
            color.alpha = readUI8(ptr) / 255.0;
            return color;
        }
        
        
        void writeColorTrans(Data& data, const ColorTransform& trans);
        ColorTransform readColorTrans(const uint8_t*& ptr);
        
        
        inline void writeMatrix(Data& data, const Matrix& trans, float scale)
        {
            CGFloat xscale, yscale, rotate0, rotate1, tx, ty;
            trans.get(xscale, rotate1, tx,
                      rotate0, yscale, ty);
            
            uint8_t flags = 0;
            if (xscale != 1)    flags |= 0x01;  // xscale
            if (yscale != 1)    flags |= 0x02;  // yscale
            if (rotate0!= 0)    flags |= 0x04;  // rotate0
            if (rotate1 != 0)   flags |= 0x08;  // rotate1
            if (tx != 0)        flags |= 0x10;  // tx
            if (ty != 0)        flags |= 0x20;  // ty;
            
            writeUI8(data, flags);
            
            if (flags & 0x01)   writeFloat(data, xscale);
            if (flags & 0x02)   writeFloat(data, yscale);
            if (flags & 0x04)   writeFloat(data, rotate0);
            if (flags & 0x08)   writeFloat(data, rotate1);
            if (flags & 0x10)   writeFloat(data, tx * scale);
            if (flags & 0x20)   writeFloat(data, ty * scale);
        }
    
    
        inline Matrix readMatrix(const uint8_t*& ptr)
        {
            CGFloat xscale = 1, yscale = 1, rotate0 = 0, rotate1 = 0, tx = 0, ty = 0;
            
            uint8_t flags = readUI8(ptr);

            if (flags & 0x01)   xscale = readFloat(ptr);
            if (flags & 0x02)   yscale = readFloat(ptr);
            if (flags & 0x04)   rotate0 = readFloat(ptr);
            if (flags & 0x08)   rotate1 = readFloat(ptr);
            if (flags & 0x10)   tx = readFloat(ptr);
            if (flags & 0x20)   ty = readFloat(ptr);
            
            return Matrix(xscale, rotate1, tx,
                          rotate0, yscale, ty);
        }
        
        
        inline void writeRect(Data& data, const Rect& rt, float scale)
        {
            writeFloat(data, rt.x * scale);
            writeFloat(data, rt.y * scale);
            writeFloat(data, rt.width * scale);
            writeFloat(data, rt.height * scale);
        }
        
        
        inline Rect readRect(const uint8_t*& ptr)
        {
            Rect rt;
            rt.x = readFloat(ptr);
            rt.y = readFloat(ptr);
            rt.width = readFloat(ptr);
            rt.height = readFloat(ptr);
            return rt;
        }
        
        
        inline void writeHeader(Data& data, const Header& header)
        {
            writeBytes(data, header.md5, 16);
            writeBytes(data, header.magic, 4);
            writeUI8(data, header.majorVersion);
            writeUI8(data, header.minorVersion);
            writeUI32(data, header.flags);
        }
        

        inline Header readHeader(const uint8_t*& ptr)
        {
            Header header;
            readBytes(ptr, header.md5, 16);
            readBytes(ptr, header.magic, 4);
            header.majorVersion = readUI8(ptr);
            header.minorVersion = readUI8(ptr);
            header.flags = readUI32(ptr);
            return header;
        }
        
        
        std::string resourceBasePath(const std::string& filePath);
        std::string sharedBasePath(const std::string& filePath);
        std::string nameOfDefine(const Define& define);
    }
}


#endif
