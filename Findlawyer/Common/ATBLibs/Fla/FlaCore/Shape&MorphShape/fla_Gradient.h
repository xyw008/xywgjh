//
//  FlaGradient.h
//  FlashExporter
//
//  Created by HJC on 12-10-18.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLAGRADIENT__
#define __FLAGRADIENT__


#include <vector>
#include "fla_Color4.h"
#include "fla_Holder.h"
#include "fla_Matrix.h"


namespace fla
{
    // 渐变
    template <int N>
    class GradientBase
    {
    public:
        typedef Holder<Color4, N>       ColorT;
        typedef Holder<float, N>        FloatT;
        typedef Holder<Matrix, N>       MatrixT;
        
        GradientBase()
        {
            init(Int2Type<N>());
        }

        struct Record
        {
            Record(const ColorT& c, FloatT l) : color(c), location(l)    {}
            bool operator == (const Record& rhs) const
            {
                return color == rhs.color && location == rhs.location;
            }
            ColorT  color;
            FloatT  location;
        };
        
        void addRecord(const ColorT& color, Holder<float, N> location)
        {
            _records.push_back(Record(color, location));
        }
        
        const std::vector<Record>&      records() const      {   return _records;     }
        
        CGFloat radius() const          {   return 16384.0 / 20.0;  }
        
        void setMatrix(const MatrixT& m)  {   _matrix = m;    }
        const MatrixT& matrix() const     {   return _matrix; }
        
        void setFocalPoint(const FloatT& point)   {   _focalPoint = point;  }
        const FloatT& focalPoint() const          {   return _focalPoint;   }
        
        bool operator == (const GradientBase& rhs) const
        {
            return
            _records == rhs._records &&
            _matrix == rhs._matrix &&
            _focalPoint == rhs._focalPoint;
        }
        
    private:
        void init(Int2Type<1>)
        {
            _focalPoint = 0;
        }
        
        void init(Int2Type<2>)
        {
            _focalPoint.start = _focalPoint.end = 0;
        }
        
    private:
        std::vector<Record>     _records;
        MatrixT                 _matrix;
        FloatT                  _focalPoint;
    };
    
    
    typedef GradientBase<1> Gradient;
    typedef GradientBase<2> MorphGradient;
};



#endif
