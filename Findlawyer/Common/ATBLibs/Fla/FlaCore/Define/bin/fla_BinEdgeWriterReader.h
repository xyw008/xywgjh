//
//  fla_BinEdgeWriterReader.h
//  SceneEditor
//
//  Created by HJC on 12-12-27.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_BINEDGEWRITERREADER__
#define __FLA_BINEDGEWRITERREADER__


#include "fla_BinaryFormat.h"
#include "fla_Point.h"



namespace fla
{
    namespace bin
    {
        /* 形状的边有两种，lineto, 和curveTo, 其中
         lineTo需要保持一个点，curveTo需要保存两个点
         
         不采用压缩的时候，lineto的保持方式为
         flags, pt.x, pt.y,
         curveTo的保持方式为
         flags, ctl.x, ctl.y, pt.x, pt,y
         每个float需要4个字节，这样需要保持的数据量就比较大，
         
         采用一定的压缩方式保持，原理大概为, 假如需要保持一系列的点
         p0, p1, p2, p3, pt4，
         只需要保持
         p0, offset1, offset2, offset3, offset4,
         其中 offset1 = p1 - p0, offset2 = p2 - p1, 这样就可以还原成
         p0, p1 = p0 + offset1, p2 = p1 + offset2,
         offset指点与点之间的偏移，这个数字通常会比较小，就有可能采用1字节或者2节保存
         另外 offset，中的x或者y很有可能会是0，为0的分量也可以不保存。
         通过这种方式，可以使得保持的数据量会减少一大半。
         
         具体是利用flags字段，有1字节，8个位，可以分成
         | 7 | 6 | 5 | 4 | 3  2 | 1 0
         0，1  两位，保持边的类型，
         2, 3  表示压缩之后每个float使用的字节数目, 0表示无压缩，1使用1字节，2表示使用2字节，3表示使用4字节
         4  是否有XControl数据(只针对曲线)
         5  是否有YControl数据(只针对曲线)
         6  是否有XPos数据
         7  是否有YPos数据
         */        
        class EdgeWriterReader
        {
        public:
            enum EdgeType
            {
                EdgeType_End    =   0,
                EdgeType_Line   =   1,
                EdgeType_Curve  =   2,
            };
            
            
            struct FlagsInfo
            {
                FlagsInfo(EdgeType t = EdgeType_End);
                
                uint8_t pack() const;           // 将信息打包成一字节
                void    unpack(uint8_t flags);  // 将字节解压
                
                EdgeType    type;
                int         numOfBytes;
                bool        hasXCtrl;
                bool        hasYCtrl;
                bool        hasXPos;
                bool        hasYPos;
            };
            
            
            EdgeWriterReader(float scale, const Point& curPt) : _scale(scale), _curPt(curPt)   {}
            
            void writeEdgeLine(Data& data, const LineTo& lineTo, bool useCompressed);
            void writeEdgeCurve(Data& data, const CurveTo& curveTo, bool useCompressed);
            
            LineTo  readEdgeLine(const uint8_t*& ptr, const FlagsInfo& flags);
            CurveTo readEdgeCurve(const uint8_t*& ptr, const FlagsInfo& flags);
            
        private:
            struct Offset
            {
                int32_t x;
                int32_t y;
            };
            
            Offset computeOffset(Point last, Point first);
            void readCurPoint(const uint8_t*& ptr, bool hasX, bool hasY, const FlagsInfo& flags);
            void writeOffset(Data& data, const Offset& offset, const Point& pt, const FlagsInfo& flags);
            void fillFlagsInfo(FlagsInfo& info, const Offset& ctrl, const Offset& pt);
            void fillFlagsInfo(FlagsInfo& info, const Offset& pt);
            
            enum
            {
                EdgeMask_HasXControl    =   1 << 4,
                EdgeMask_HasYControl    =   1 << 5,
                EdgeMask_HasXPos        =   1 << 6,
                EdgeMask_HasYPos        =   1 << 7,
            };
            
        private:
            float     _scale;
            Point     _curPt;
        };
        
        
        ///////////////
        inline EdgeWriterReader::FlagsInfo::FlagsInfo(EdgeType t) : type(t)
        {
            numOfBytes = 0;
            hasXPos = false;
            hasYPos = false;
            hasXCtrl = false;
            hasYCtrl = false;
        }
        
        
        inline uint8_t EdgeWriterReader::FlagsInfo::pack() const
        {
            uint8_t flags = type;
            flags |= (numOfBytes << 2);
            if (hasXCtrl)   {   flags |= EdgeWriterReader::EdgeMask_HasXControl;    }
            if (hasYCtrl)   {   flags |= EdgeWriterReader::EdgeMask_HasYControl;    }
            if (hasXPos)    {   flags |= EdgeWriterReader::EdgeMask_HasXPos;        }
            if (hasYPos)    {   flags |= EdgeWriterReader::EdgeMask_HasYPos;        }
            return flags;
        }
        
        
        inline void EdgeWriterReader::FlagsInfo::unpack(uint8_t flags)
        {
            type = (EdgeWriterReader::EdgeType)(flags & 0x3);
            numOfBytes = (flags >> 2) & 0x3;
            hasXCtrl = (flags & EdgeMask_HasXControl);
            hasYCtrl = (flags & EdgeMask_HasYControl);
            hasXPos  = (flags & EdgeMask_HasXPos);
            hasYPos  = (flags & EdgeMask_HasYPos);
        }
    };
};



#endif
