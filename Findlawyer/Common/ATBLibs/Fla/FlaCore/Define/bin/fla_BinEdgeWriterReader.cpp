//
//  fla_BinEdgeWriterReader.cpp
//  SceneEditor
//
//  Created by HJC on 12-12-27.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_BinEdgeWriterReader.h"


namespace fla
{
    namespace bin
    {
        // 判断一个整数最起码可以用多数字节表示
        // 返回1表示1字节，2表示2字节，3表示四字节
        static int numberOfBytes(int32_t value)
        {
            int32_t min = std::numeric_limits<int8_t>::min();
            int32_t max = std::numeric_limits<int8_t>::max();
            
            if (min < value && value < max)
            {
                return 1;
            }
            
            min = std::numeric_limits<int16_t>::min();
            max = std::numeric_limits<int16_t>::max();
            if (min < value && value < max)
            {
                return 2;
            }
            
            return 3;
        }
        
        
        
        static int numberOfBytes(int32_t v0, int32_t v1)
        {
            return std::max(numberOfBytes(v0), numberOfBytes(v1));
        }
        
        
        static int numberOfBytes(int32_t v0, int32_t v1, int32_t v2, int32_t v3)
        {
            return std::max(numberOfBytes(v0, v1), numberOfBytes(v2, v3));
        }
        
        
        
        void EdgeWriterReader::writeOffset(Data& data, const Offset& offset, const Point& pt, const FlagsInfo& flags)
        {
            if (flags.numOfBytes == 0)
            {
                writePoint(data, pt, _scale);
            }
            else if (flags.numOfBytes == 1)
            {
                if (offset.x)    writeSI8(data, offset.x);
                if (offset.y)    writeSI8(data, offset.y);
            }
            else if (flags.numOfBytes == 2)
            {
                if (offset.x)    writeSI16(data, offset.x);
                if (offset.y)    writeSI16(data, offset.y);
            }
            else if (flags.numOfBytes == 3)
            {
                if (offset.x)    writeFloat(data, pt.x * _scale);
                if (offset.y)    writeFloat(data, pt.y * _scale);
            }
            _curPt = pt;
        }
        
        
        
        EdgeWriterReader::Offset EdgeWriterReader::computeOffset(Point last, Point first)
        {
            Offset offset;
            offset.x = (last.x - first.x) * _scale * 20;
            offset.y = (last.y - first.y) * _scale * 20;
            return offset;
        }
        
        
        void EdgeWriterReader::readCurPoint(const uint8_t*& ptr, bool hasX, bool hasY, const FlagsInfo& flags)
        {
            if (flags.numOfBytes == 0)
            {
                _curPt = readPoint(ptr);
            }
            else if (flags.numOfBytes == 1)
            {
                if (hasX)   _curPt.x += (readSI8(ptr) / 20.0);
                if (hasY)   _curPt.y += (readSI8(ptr) / 20.0);
            }
            else if (flags.numOfBytes == 2)
            {
                if (hasX)   _curPt.x += (readSI16(ptr) / 20.0);
                if (hasY)   _curPt.y += (readSI16(ptr) / 20.0);
            }
            else if (flags.numOfBytes == 3)
            {
                if (hasX)   _curPt.x = readFloat(ptr);
                if (hasY)   _curPt.y = readFloat(ptr);
            }
        }
        
    
        void EdgeWriterReader::fillFlagsInfo(FlagsInfo& flags, const Offset& ctrl, const Offset& pt)
        {
            flags.hasXCtrl = (ctrl.x != 0);
            flags.hasYCtrl = (ctrl.y != 0);
            flags.hasXPos = (pt.x != 0);
            flags.hasYPos = (pt.y != 0);
            flags.numOfBytes = numberOfBytes(ctrl.x, ctrl.y, pt.x, pt.y);
        }
        
        
        
        void EdgeWriterReader::fillFlagsInfo(FlagsInfo& flags, const Offset& pt)
        {
            flags.hasXPos = (pt.x != 0);
            flags.hasYPos = (pt.y != 0);
            flags.numOfBytes = numberOfBytes(pt.x, pt.y);
        }
        
        
        void EdgeWriterReader::writeEdgeLine(Data& data, const LineTo& lineTo, bool useCompressed)
        {
            if (useCompressed)
            {
                FlagsInfo flags(EdgeType_Line);
                auto offset = computeOffset(lineTo.pt, _curPt);
                fillFlagsInfo(flags, offset);
                writeUI8(data, flags.pack());
                writeOffset(data, offset, lineTo.pt, flags);
            }
            else
            {
                FlagsInfo flags(EdgeType_Line);
                writeUI8(data, flags.pack());
                writePoint(data, lineTo.pt, _scale);
                _curPt = lineTo.pt;
            }
        }
        
        
        
        void EdgeWriterReader::writeEdgeCurve(Data& data, const CurveTo& curveTo, bool useCompressed)
        {
            if (useCompressed)
            {
                FlagsInfo flags(EdgeType_Curve);
                auto ctrlOffset = computeOffset(curveTo.control, _curPt);
                auto offset = computeOffset(curveTo.pt, curveTo.control);
                
                fillFlagsInfo(flags, ctrlOffset, offset);
                writeUI8(data, flags.pack());
                
                writeOffset(data, ctrlOffset, curveTo.control, flags);
                writeOffset(data, offset, curveTo.pt, flags);
            }
            else
            {
                FlagsInfo flags(EdgeType_Curve);
                writeUI8(data, flags.pack());
                writePoint(data, curveTo.control, _scale);
                writePoint(data, curveTo.pt, _scale);
                _curPt = curveTo.pt;
            }
        }
        
        
        LineTo EdgeWriterReader::readEdgeLine(const uint8_t*& ptr, const FlagsInfo& flags)
        {
            LineTo line;            
            readCurPoint(ptr, flags.hasXPos, flags.hasYPos, flags);
            line.pt = _curPt;
            return line;
        }
        
        
        CurveTo EdgeWriterReader::readEdgeCurve(const uint8_t*& ptr, const FlagsInfo& flags)
        {
            CurveTo curve;
            
            readCurPoint(ptr, flags.hasXCtrl, flags.hasYCtrl, flags);
            curve.control = _curPt;
            
            readCurPoint(ptr, flags.hasXPos, flags.hasYPos, flags);
            curve.pt = _curPt;
            
            return curve;
        }
    };
};

