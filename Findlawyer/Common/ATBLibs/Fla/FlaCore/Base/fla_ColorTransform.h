//
//  fla_ColorTransform.h
//  SceneEditor
//
//  Created by HJC on 12-12-24.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_COLORTRANSFORM__
#define __FLA_COLORTRANSFORM__


#include "fla_types.h"
#include <memory.h>


namespace fla
{
    class Color4;
    class ColorTransform
    {
    public:
        static ColorTransform identity;
        
        ColorTransform();
        ColorTransform(scalar rM, scalar gM, scalar bM, scalar aM,
                       scalar rA, scalar gA, scalar bA, scalar aA);
        
        
        scalar rMult()      const    {   return _rMult;  }
        scalar gMult()      const    {   return _gMult;  }
        scalar bMult()      const    {   return _bMult;  }
        scalar aMult()      const    {   return _aMult;  }
        scalar rAdd()       const    {   return _rAdd;   }
        scalar gAdd()       const    {   return _gAdd;   }
        scalar bAdd()       const    {   return _bAdd;   }
        scalar aAdd()       const    {   return _aAdd;   }
        
        void setAMult(const scalar& a)
        {
            _aMult = a;
        }
        
        bool   isIdentity() const    {   return _isIdentity;  }
        
        bool operator == (const ColorTransform& rhs) const;
        bool operator != (const ColorTransform& rhs) const;
        
    private:
        void   updateIsIdentity();
        friend ColorTransform operator * (const ColorTransform& lhs, const ColorTransform& rhs);
        friend Color4 operator * (const ColorTransform& trans, const Color4& s);
        
    private:
        scalar   _rMult;
        scalar   _gMult;
        scalar   _bMult;
        scalar   _aMult;
        scalar   _rAdd;
        scalar   _gAdd;
        scalar   _bAdd;
        scalar   _aAdd;
        bool     _isIdentity;
    };
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    inline ColorTransform::ColorTransform()
    {
        _rMult = _gMult = _bMult = _aMult = 1.0;
        _rAdd = _gAdd = _bAdd = _aAdd = 0.0;
        _isIdentity = true;
    }
    
    
    inline ColorTransform::ColorTransform(scalar rM, scalar gM, scalar bM, scalar aM,
                                          scalar rA, scalar gA, scalar bA, scalar aA)
    {
        _rMult = rM;
        _gMult = gM;
        _bMult = bM;
        _aMult = aM;
        
        _rAdd = rA;
        _gAdd = gA;
        _bAdd = bA;
        _aAdd = aA;
        updateIsIdentity();
    }
    
    
    inline void ColorTransform::updateIsIdentity()
    {
        _isIdentity =
        (_rMult == 1.0) &&
        (_gMult == 1.0) &&
        (_bMult == 1.0) &&
        (_aMult == 1.0) &&
        (_rAdd == 0.0) &&
        (_gAdd == 0.0) &&
        (_bAdd == 0.0) &&
        (_aAdd == 0.0);
    }
    
    
    inline bool ColorTransform::operator == (const ColorTransform& rhs) const
    {
        if (_isIdentity && rhs._isIdentity)
        {
            return true;
        }
        return memcmp(this, &rhs, sizeof(ColorTransform)) == 0;
    }
    
    
    inline bool ColorTransform::operator != (const ColorTransform& rhs) const
    {
        return !(*this == rhs);
    }
}



#endif
