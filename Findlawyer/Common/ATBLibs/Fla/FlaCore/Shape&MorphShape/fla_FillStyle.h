//
//  FlaFillStyle.h
//  FlashExporter
//
//  Created by HJC on 12-10-19.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLAFILLSTYLE__
#define __FLAFILLSTYLE__


#include <stdint.h>
#include "fla_Gradient.h"
#include "fla_RcObj.h"
#include "fla_Matrix.h"
#include <assert.h>



namespace fla
{
    enum class FillType : uint8_t
    {
        Solid                      = 0x00,
        LinearGradient             = 0x10,
        RadialGradient             = 0x12,
        FocalRadialGradient        = 0x13,   /* 暂时不支持这个格式 */
        RepeatingBitmap            = 0x40,
        ClippedBitmap              = 0x41,
        NonSmoothedRepeatingBitmap = 0x42,
        NonSmoothedClippedBitmap   = 0x43,
    };
    
    
    template <int N>
    class FillStyleBase
    {
    public:
        FillStyleBase();
        
        typedef Holder<Color4, N>       SolidData;
        typedef GradientBase<N>         GradientData;
        typedef Holder<Matrix, N>       MatrixT;
        
        struct BitmapData
        {
            uint16_t    bitmapId;
            MatrixT     matrix;
        };
        
        
        bool isBitmapStyle()    const;
        bool isGradientStyle()  const;
        bool isSolidStyle()     const;
        
        void setFillType(FillType type)                 {   _type = type;                   }
        void setFillData(RcObjPtr data)                 {   _data = data;                   }
        
        FillType fillType() const                       {   return _type;                   }
        
        uint16_t bitmapId() const                           {   return data<BitmapData>().bitmapId;     }
        const    MatrixT& bitmapMatrix() const             {   return data<BitmapData>().matrix;       }
        
        const GradientData&     gradient()  const           {   return data<GradientData>();        }
        const SolidData&        solidColor() const          {   return data<SolidData>();         }
        
        bool operator == (const FillStyleBase& rhs) const;
        bool operator != (const FillStyleBase& rhs) const   {   return !(*this == rhs); }
        
    private:
        template <typename T>
        const T& data() const
        {
            assert(_data);
            return util::rc_static_cast<RcWrapObj<T>>(_data)->val;
        }
        
        FillType     _type;
        RcObjPtr     _data;
    };
    
    
    template <int N>
    inline FillStyleBase<N>::FillStyleBase()
    {
        _type = FillType::Solid;
    }
    
    template <int N>
    inline bool FillStyleBase<N>::isSolidStyle() const
    {
        return _type == FillType::Solid;
    }
    
    template <int N>
    inline bool FillStyleBase<N>::isBitmapStyle() const
    {
        return
        (_type == FillType::RepeatingBitmap) ||
        (_type == FillType::ClippedBitmap) ||
        (_type == FillType::NonSmoothedRepeatingBitmap) ||
        (_type == FillType::NonSmoothedClippedBitmap);
    }
    
    
    template <int N>
    inline bool FillStyleBase<N>::isGradientStyle() const
    {
        return
        (_type == FillType::LinearGradient) ||
        (_type == FillType::RadialGradient) ||
        (_type == FillType::FocalRadialGradient);
    }
    
    
    template <int N>
    bool FillStyleBase<N>::operator == (const FillStyleBase& rhs) const
    {
        if (fillType() != rhs.fillType())
        {
            return false;
        }
        
        if (isSolidStyle())
        {
            return solidColor() == rhs.solidColor();
        }
        
        if (isBitmapStyle())
        {
            return
            bitmapId() == rhs.bitmapId() &&
            bitmapMatrix() == rhs.bitmapMatrix();
        }
        
        if (isGradientStyle())
        {
            return gradient() == rhs.gradient();
        }
        
        return false;
    }
    
    
    typedef FillStyleBase<1>    FillStyle;
    typedef FillStyleBase<2>    MorphFillStyle;
}



#endif 
