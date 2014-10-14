//
//  fla_ColorTransform.cpp
//  SceneEditor
//
//  Created by HJC on 12-12-24.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_ColorTransform.h"
#include "fla_Color4.h"
#include <algorithm>


namespace fla
{
    ColorTransform ColorTransform::identity = ColorTransform();
    

    ColorTransform operator * (const ColorTransform& lhs, const ColorTransform& rhs)
    {
        if (lhs.isIdentity() && rhs.isIdentity())
        {
            return lhs;
        }
        
        if (lhs.isIdentity())
        {
            return rhs;
        }
        
        if (rhs.isIdentity())
        {
            return lhs;
        }
        
        ColorTransform result;
        result._rMult = lhs.rMult() * rhs.rMult();
        result._gMult = lhs.gMult() * rhs.gMult();
        result._bMult = lhs.bMult() * rhs.bMult();
        result._aMult = lhs.aMult() * rhs.aMult();
        
        result._rAdd = lhs.rMult() * rhs.rAdd() + lhs.rAdd();
        result._gAdd = lhs.gMult() * rhs.gAdd() + lhs.gAdd();
        result._bAdd = lhs.bMult() * rhs.bAdd() + lhs.bAdd();
        result._aAdd = lhs.aMult() * rhs.aAdd() + lhs.aAdd();
        
        result.updateIsIdentity();
        return result;
    }
    
    
    
    Color4 operator * (const ColorTransform& trans, const Color4& s)
    {
        if (trans.isIdentity())
        {
            return s;
        }
        
        Color4 d;
        d.red = s.red * trans.rMult() + trans.rAdd();
        d.green = s.green * trans.gMult() + trans.gAdd();
        d.blue = s.blue * trans.bMult() + trans.bAdd();
        d.alpha = s.alpha * trans.aMult() + trans.aAdd();
        
        d.red = std::max<scalar>(0.0, std::min<scalar>(1.0, d.red));
        d.green = std::max<scalar>(0.0, std::min<scalar>(1.0, d.green));
        d.blue = std::max<scalar>(0.0, std::min<scalar>(1.0, d.blue));
        d.alpha = std::max<scalar>(0.0, std::min<scalar>(1.0, d.alpha));
        
        return d;
    }
}
