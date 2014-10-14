//
//  fla_BinaryReader.cpp
//  SceneEditor
//
//  Created by HJC on 12-11-6.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_BinaryReader.h"
#include "fla_BinaryFormat.h"
#include "fla_DefineScene.h"
#include "fla_DefineShape.h"
#include "fla_DefineRole.h"
#include "fla_DefineFont.h"
#include "fla_DefineText.h"
#include "fla_BinEdgeWriterReader.h"
#include "cocoa_ImageHelper.h"
#include "util_strAddtions.h"
#include "util_Data.h"
#include "util_json.h"
#include "util_fsys.h"
#include "util_MD5.h"


namespace fla
{
    static std::string nameFromJson(const std::string& json)
    {
        if (json.empty())
        {
            return json;
        }
        
        auto dict = util::json::stringToValue(json);
        if (dict.isDict())
        {
            auto name = dict.dict()["name"];
            if (name.isString())
            {
                return name.string();
            }
        }
        return "";
    }
    
    
    
    inline uint16_t readSpriteFlags(const uint8_t*& ptr)
    {
        uint16_t flags = bin::readUI8(ptr);
        if (flags & bin::PlaceObjFlags_Use16BitFlag)
        {
            ptr--;
            flags = bin::readUI16(ptr);
        }
        return flags;
    }
    
    
    
    static SpriteObject parseSpriteObj(const uint8_t*& ptr)
    {
        fla::SpriteObject obj;
        uint16_t flags = readSpriteFlags(ptr);
        
        if (flags & bin::PlaceObjFlags_Remove)
        {
            obj.removeObject = true;
            obj.depth = bin::readUI16(ptr);
            return obj;
        }
        
        obj.depth = bin::readUI16(ptr);
        if (flags & bin::PlaceObjFlags_HasCharacterID)
        {
            obj.hasCharacterID = true;
            obj.characterID = bin::readUI16(ptr);
        }
        
        if (flags & bin::PlaceObjFlags_HasTrans)
        {
            obj.hasTrans = true;
            obj.trans = bin::readMatrix(ptr);
        }
        
        if (flags & bin::PlaceObjFlags_HasColorTrans)
        {
            obj.hasColorTrans = true;
            obj.colorTrans = bin::readColorTrans(ptr);
        }
        
        if (flags & bin::PlaceObjFlags_HasRatio)
        {
            obj.hasRatio = true;
            obj.ratio = bin::readUI16(ptr) / 65535.0;
        }
        
        if (flags & bin::PlaceObjFlags_HasClipDepth)
        {
            obj.hasClipDepth = true;
            obj.clipDepth = bin::readUI16(ptr);
        }
        
        return obj;
    }
    
    
    
    void BinaryReader::parseSprite(DefineSprite& sprite, const uint8_t* ptr)
    {
        int count = bin::readUI16(ptr);
        sprite.frames().resize(count);
        sprite.setName(nameFromJson(bin::readString(ptr)));
        
        uint16_t index = bin::readUI16(ptr);
        while (index != ((uint16_t)-1))
        {
            size_t objCout = bin::readUI16(ptr);
            for (size_t i = 0; i < objCout; i++)
            {
                fla::SpriteObject obj = parseSpriteObj(ptr);
                if (obj.hasCharacterID && !obj.removeObject)
                {
                    DefinePtr childDefine = _dict[obj.characterID];
                    if (childDefine)
                    {
                        sprite.setDefine(obj.characterID, childDefine);
                    }
                }
                sprite.frames()[index].push_back(obj);
            }
            index = bin::readUI16(ptr);
        }
    }
    
    
    
    DefinePtr BinaryReader::parseScene(const uint8_t* ptr, int len)
    {
        auto scene = util::rc_pointer<fla::DefineScene>(new fla::DefineScene());
        scene->setId(bin::readUI16(ptr));
        scene->setSize(bin::readSize(ptr));
        scene->setColor(bin::readColor(ptr));
        parseSprite(*scene, ptr);
        return scene;
    }
    
    
    
    DefinePtr BinaryReader::parseSprite(const uint8_t* ptr, int len)
    {
        auto sprite = util::rc_pointer<fla::DefineSprite>(new DefineSprite());
        sprite->setId(bin::readUI16(ptr));
        parseSprite(*sprite, ptr);
        return sprite;
    }
    
    
    
    namespace bin
    {
        template <int N>
        Holder<Color4, N> readColor(const uint8_t*& ptr)
        {
            return readColor(ptr);
        }
        
        template <>
        Holder<Color4, 2> readColor(const uint8_t*& ptr)
        {
            Holder<Color4, 2> result;
            result.start = readColor(ptr);
            result.end = readColor(ptr);
            return result;
        }
        
        template <int N>
        Holder<float, N> readFloat(const uint8_t*& ptr)
        {
            return readFloat(ptr);
        }
        
        template <>
        Holder<float, 2> readFloat(const uint8_t*& ptr)
        {
            Holder<float, 2> result;
            result.start = readFloat(ptr);
            result.end = readFloat(ptr);
            return result;
        }
        
        
        template <int N>
        Holder<uint8_t, N> readUI8(const uint8_t*& ptr)
        {
            return readUI8(ptr);
        }
        
        template <>
        Holder<uint8_t, 2> readUI8(const uint8_t*& ptr)
        {
            Holder<uint8_t, 2> result;
            result.start = readUI8(ptr);
            result.end = readUI8(ptr);
            return result;
        }
        
        template <int N>
        Holder<Matrix, N> readMatrix(const uint8_t*& ptr)
        {
            return readMatrix(ptr);
        }
        
        template <>
        Holder<Matrix, 2> readMatrix(const uint8_t*& ptr)
        {
            Holder<Matrix, 2> matrix;
            matrix.start = readMatrix(ptr);
            matrix.end = readMatrix(ptr);
            return matrix;
        }
    }
    
    
    template <int N>
    static LineStyleBase<N> parseLineStyle(const uint8_t*& ptr)
    {
        LineStyleBase<N> style;
        style.width = bin::readFloat<N>(ptr);
        style.color = bin::readColor<N>(ptr);
        
        uint8_t flags = bin::readUI8(ptr);
        if (flags & bin::LineStyleFlag_OnlyWidthAndColor)
        {
            style.onlyWidthAndColor = true;
        }
        else
        {
            style.onlyWidthAndColor = false;
        }
        
        if (!style.onlyWidthAndColor)
        {
            style.startCapStyle = bin::readUI8(ptr);
            style.endCapStyle = bin::readUI8(ptr);
            style.jointStyle = bin::readUI8(ptr);
            style.miterLimitFactor = bin::readFloat(ptr);
        }
        return style;
    }
    
    
    
    template <int N>
    static FillStyleBase<N> parseFillStyle(const uint8_t*& ptr)
    {
        FillStyleBase<N> style;
        style.setFillType((FillType)bin::readUI8(ptr));
        
        if (style.isSolidStyle())
        {
            auto solid = RcWrapObj<typename FillStyleBase<N>::SolidData>::create();
            solid->val = bin::readColor<N>(ptr);
            style.setFillData(solid);
        }
        
        else if (style.isGradientStyle())
        {
            auto data = RcWrapObj<typename FillStyleBase<N>::GradientData>::create();
            style.setFillData(data);
            
            auto& gradient = data->val;
            gradient.setMatrix(bin::readMatrix<N>(ptr));
            
            if (style.fillType() == FillType::FocalRadialGradient)
            {
                gradient.setFocalPoint(bin::readFloat<N>(ptr));
            }
            
            size_t count = bin::readUI16(ptr);
            for (auto i = 0; i < count; i++)
            {
                auto color = bin::readColor<N>(ptr);
                auto loc = bin::readUI8<N>(ptr) / 255.0;
                gradient.addRecord(color, loc);
            }
        }
        
        else if (style.isBitmapStyle())
        {
            auto bitmap = RcWrapObj<typename FillStyleBase<N>::BitmapData>::create();
            bitmap->val.matrix = bin::readMatrix<N>(ptr);
            bitmap->val.bitmapId = bin::readUI16(ptr);
            style.setFillData(bitmap);
        }
        
        return style;
    }
    
    
    size_t readPathSize(const uint8_t*& ptr)
    {
        size_t size = bin::readUI16(ptr);
        if (size & 0x01)
        {
            ptr -= 2;
            size = bin::readUI32(ptr);
            size = size >> 1;
        }
        else
        {
            size = size >> 1;
        }
        return size;
    }
    
    
    void readEdgeList(const uint8_t*& ptr, EdgeList& edgeList)
    {
        Point curPt = edgeList.firstPt();
        bin::EdgeWriterReader edgeHelper(1.0, curPt);
        bin::EdgeWriterReader::FlagsInfo flags;
        flags.unpack(bin::readUI8(ptr));
        
        while (flags.type != bin::EdgeWriterReader::EdgeType_End)
        {
            if (flags.type == bin::EdgeWriterReader::EdgeType_Line)
            {
                edgeList.addEdge(edgeHelper.readEdgeLine(ptr, flags));
            }
            else if (flags.type == bin::EdgeWriterReader::EdgeType_Curve)
            {
                edgeList.addEdge(edgeHelper.readEdgeCurve(ptr, flags));
            }
            flags.unpack(bin::readUI8(ptr));
        }
    }
    
    
    static void parsePaths(std::vector<fla::MorphPath>& paths, const uint8_t*& ptr)
    {
        size_t size = readPathSize(ptr);
        if (size > 0)
        {
            paths.resize(size);
        }
        
        for (auto i = 0; i < size; i++)
        {
            paths[i].edges<0>().setFirstPt(bin::readPoint(ptr));
            paths[i].edges<1>().setFirstPt(bin::readPoint(ptr));
            paths[i].setLineStyle((int)bin::readUI16(ptr) - 1);
            paths[i].setFillStyle((int)bin::readUI16(ptr) - 1);
            
            readEdgeList(ptr, paths[i].edges<0>());
            readEdgeList(ptr, paths[i].edges<1>());
            
            parsePaths(paths[i].subPaths(), ptr);
        }
    }
    
    
    static void parsePaths(std::vector<fla::Path>& paths, const uint8_t*& ptr)
    {
        size_t size = readPathSize(ptr);
        
        if (size > 0)
        {
            paths.resize(size);
        }
        
        for (size_t i = 0; i < size; i++)
        {
            paths[i].edges<0>().setFirstPt(bin::readPoint(ptr));
            paths[i].setLineStyle((int)bin::readUI16(ptr) - 1);
            paths[i].setFillStyle((int)bin::readUI16(ptr) - 1);
            
            readEdgeList(ptr, paths[i].edges<0>());
            
            parsePaths(paths[i].subPaths(), ptr);
        }
    }
    
    
    template <int N>
    static void parseSingleShape(ShapeBase<N>& shape, const uint8_t*& ptr)
    {
        size_t count = bin::readUI16(ptr);
        for (size_t i = 0; i < count; i++)
        {
            shape.lineStyles.push_back(parseLineStyle<N>(ptr));
        }
        
        count = bin::readUI16(ptr);
        for (size_t i = 0; i < count; i++)
        {
            shape.fillStyles.push_back(parseFillStyle<N>(ptr));
        }
        
        parsePaths(shape.paths, ptr);
    }
    
    
    
    DefinePtr BinaryReader::parseShape(const uint8_t* ptr, int len)
    {
        auto shape = util::rc_pointer<fla::DefineShape>(new fla::DefineShape());
        shape->setId(bin::readUI16(ptr));
        shape->setShapeBounds(bin::readRect(ptr));
        shape->setName(nameFromJson(bin::readString(ptr)));
        parseSingleShape(shape->shape(), ptr);
        
        for (auto& style : shape->shape().fillStyles)
        {
            if (style.isBitmapStyle())
            {
                auto define = _dict[style.bitmapId()];
                if (define && define->type() == DefineType_Image)
                {
                    shape->addBitmapDefine(util::rc_static_cast<DefineImage>(define));
                }
            }
        }
        
        return shape;
    }
    
    
    
    DefinePtr BinaryReader::parseMorphShape(const uint8_t* ptr, int len)
    {
        auto shape = DefineMorphShapePtr(new DefineMorphShape());
        shape->setId(bin::readUI16(ptr));
        
        DefineMorphShape::RectT rt;
        rt.start = bin::readRect(ptr);
        rt.end = bin::readRect(ptr);
        shape->setBounds(rt);
        shape->setName(nameFromJson(bin::readString(ptr)));
        parseSingleShape(shape->shape(), ptr);
        
        return shape;
    }
    
    
    
    DefinePtr BinaryReader::parseImage(const uint8_t* ptr, int len)
    {
        auto savePtr = ptr;
        DefineImagePtr image(new fla::DefineImage());
        image->setId(bin::readUI16(ptr));
        image->setName(nameFromJson(bin::readString(ptr)));
        
        auto pngSize = len - (ptr - savePtr);
        if (pngSize > 0)
        {
            auto imageHolder = cocoa::ImageHelper::loadPNGFromData(ptr, pngSize);
            image->setImage(imageHolder.get());
        }
        else
        {
            std::string resPath = bin::resourceBasePath(_filePath);
            std::string name = bin::nameOfDefine(*image);
            std::string imgPath = util::str_appendingPathComponent(resPath, name);
            if (!util::file_isExists(imgPath))
            {
                resPath = bin::sharedBasePath(_filePath);
                imgPath = util::str_appendingPathComponent(resPath, name);
            }
            auto imageHolder = cocoa::ImageHelper::loadPNGFromFile(imgPath.c_str());
            image->setImage(imageHolder.get());
        }
        
        return image;
    }
    
    
    
    DefinePtr BinaryReader::parseText(const uint8_t* ptr, int len)
    {
        DefineTextPtr text(new DefineText());
        text->setId(bin::readUI16(ptr));
        text->setTextBounds(bin::readRect(ptr));
        text->setTextMatrix(bin::readMatrix(ptr));
        text->setName(nameFromJson(bin::readString(ptr)));
        
        uint8_t flags = bin::readUI8(ptr);
        while (flags != 0)
        {
            TextRecord r;
            r.styleFlags = flags;
            
            if (r.hasFont())
            {
                uint16_t fontId = bin::readUI16(ptr);
                auto font = _dict[fontId];
                if (font && font->type() == DefineType_Font)
                {
                    r.font = util::rc_static_cast<DefineFont>(font);
                }
                r.textHeight = bin::readFloat(ptr);
            }
            
            if (r.hasColor())
            {
                r.color = bin::readColor(ptr);
            }
            
            if (r.hasXOffset())
            {
                r.offset.x = bin::readFloat(ptr);
            }
            
            if (r.hasYOffset())
            {
                r.offset.y = bin::readFloat(ptr);
            }
            
            auto size = bin::readUI16(ptr);
            for (auto i = 0; i < size; i++)
            {
                GlyphEntry en;
                en.code = bin::readUI16(ptr);
                en.advance = bin::readFloat(ptr);
                r.glyphEntries.push_back(en);
            }
            
            text->records().push_back(r);
            flags = bin::readUI8(ptr);
        }
        
        return text;
    }
    
    
    DefinePtr BinaryReader::parseFont(const uint8_t* ptr, int len)
    {
        auto savePtr = ptr;
        DefineFontPtr font(new DefineFont());
        font->setId(bin::readUI16(ptr));
        font->languageCode = bin::readUI8(ptr);
        font->fontFlags = bin::readUI8(ptr);
        font->setName(nameFromJson(bin::readString(ptr)));
        
        auto fontSize = len - (ptr - savePtr);
        if (fontSize > 0)
        {
            if (font->hasLayout())
            {
                font->ascent = bin::readFloat(ptr);
                font->descent = bin::readFloat(ptr);
                font->leading = bin::readFloat(ptr);
                
                auto size = bin::readUI16(ptr);
                for (auto i = 0; i < size; i++)
                {
                    KerningRecord r;
                    r.code1 = bin::readUI16(ptr);
                    r.code2 = bin::readUI16(ptr);
                    r.adjustment = bin::readFloat(ptr);
                }
            }
            
            auto size = bin::readUI16(ptr);
            for (auto i = 0; i < size; i++)
            {
                FontItem item;
                item.code = bin::readUI16(ptr);
                if (font->hasLayout())
                {
                    item.bounds = bin::readRect(ptr);
                    item.advance = bin::readFloat(ptr);
                }
                bin::readString(ptr);
                font->addItem(item);
                
                auto* findItem = font->findItem(item.code);
                if (findItem)
                {
                    parseSingleShape(findItem->glyph, ptr);
                }
            }
        }
        else
        {
            BinaryReader reader;
            std::string resPath = bin::resourceBasePath(_filePath);
            std::string name = bin::nameOfDefine(*font);
            std::string imgPath = util::str_appendingPathComponent(resPath, name);
            if (!util::file_isExists(imgPath))
            {
                resPath = bin::sharedBasePath(_filePath);
                imgPath = util::str_appendingPathComponent(resPath, name);
            }
            reader.readFilePath(imgPath, _checkMd5);
            return reader.root();
        }
        return font;
    }
    
    
    
    DefinePtr BinaryReader::parseRole(const uint8_t* ptr, int len)
    {
        DefineRolePtr role(new fla::DefineRole());
        role->setId(bin::readUI16(ptr));
        const std::string& defaultName = bin::readString(ptr);
        role->setName(nameFromJson(bin::readString(ptr)));
        
        uint8_t flag = bin::readUI8(ptr);
        while (!(flag & bin::RoleStateFlags_IsEnd))
        {
            if (flag & bin::RoleStateFlags_IsRef)
            {
                uint16_t Id = bin::readUI16(ptr);
                auto state = bin::readString(ptr);
                auto define = _dict[Id];
                if (define)
                {
                    role->addState(state, define);
                }
            }
            else
            {
                int tag = 0;
                int len = 0;
                bin::readTagAndLen(ptr, tag, len);
                auto savePtr = ptr;
                DefinePtr define = parseDefine(ptr, tag, len);
                ptr = savePtr + len;
                auto state = bin::readString(ptr);
                if (define)
                {
                    define->setId(Define::roleStateId);
                    role->addState(state, define);
                }
            }
            flag = bin::readUI8(ptr);
        }
        
        role->setDefualtState(defaultName);
        return role;
    }
    
    
    DefinePtr BinaryReader::parseDefine(const uint8_t* ptr, int tag, int len)
    {
        switch (tag)
        {
            case bin::TagType_Scene:
                return parseScene(ptr, len);
                
            case bin::TagType_Shape:
                return parseShape(ptr, len);
                
            case bin::TagType_Sprite:
                return parseSprite(ptr, len);
                
            case bin::TagType_Role:
                return parseRole(ptr, len);
                
            case bin::TagType_Font:
                return parseFont(ptr, len);
                
            case bin::TagType_Image:
                return parseImage(ptr, len);
                
            case bin::TagType_Text:
                return parseText(ptr, len);
                
            case bin::TagType_MorphShape:
                return parseMorphShape(ptr, len);
                
            default:
                break;
        }
        return DefinePtr();
    }
    
    
    ErrorCode BinaryReader::readFilePath(const std::string& filePath, bool checkMd5)
    {
        util::Data data;
        if (!data.loadFromFile(filePath))
        {
            return Error_ReadFileFails;
        }
        
        if (data.size() < sizeof(bin::Header))
        {
            return Error_WrongFormat;
        }
        
        const uint8_t* begin = data.bytes();
        const uint8_t* end = data.bytes() + data.size();
        
        bin::Header header = bin::readHeader(begin);
        if (strncmp((char*)header.magic, "atjc", 4) != 0)
        {
            return Error_WrongFormat;
        }
        
        _checkMd5 = checkMd5;
        if (checkMd5)
        {
            auto md5 = util::MD5Ctx::md5(&data[16], (unsigned int)data.size() - 16);
            if (md5 != util::MD5(header.md5))
            {
                return Error_CheckMd5Fails;
            }
        }
        
        if (header.majorVersion > 1 || header.minorVersion > 0)
        {
            return Error_VersionIsTooHigh;
        }
        
        
        // 需要zip解压
        if (header.flags & bin::HeaderFlags_zipCompress)
        {
            data.zipUncompress(begin, end - begin);
            begin = data.bytes();
            end = data.bytes() + data.size();
        }
        
        _rootId = bin::readUI16(begin);
        _frameRate = bin::readUI16(begin);
        /* 
         frameRate是浮点数，写入的时候乘以256，可以表示一些小数位
         */
        if (_frameRate > 256.0)
        {
            _frameRate /= 256.0f;
        }
        bin::readString(begin);
        
        
        _filePath = filePath;
        while (end - begin >= 2)
        {
            int tag = 0;
            int len = 0;
            bin::readTagAndLen(begin, tag, len);
            
            DefinePtr define = parseDefine(begin, tag, len);
            if (define)
            {
                _dict[define->Id()] = define;
            }

            begin += len;
        }
        
        return Code_Success;
    }
}

