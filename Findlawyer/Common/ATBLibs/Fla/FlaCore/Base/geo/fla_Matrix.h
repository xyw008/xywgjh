//
//  fla_Matrix.h
//  SceneEditor
//
//  Created by HJC on 13-1-23.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_MATRIX__
#define __FLA_MATRIX__


#include "fla_types.h"
#include <cmath>
#include "fla_Point.h"


namespace fla
{
    class Matrix
    {
    public:
        Matrix()
        {
            _impl = CGAffineTransformIdentity;
        }
        
        Matrix(CGFloat a, CGFloat c, CGFloat tx,
               CGFloat b, CGFloat d, CGFloat ty)
        {
            set(a, c, tx,
                b, d, ty);
        }
        
        
        explicit Matrix(const CGAffineTransform& trans) : _impl(trans) {}
        
        void set(CGFloat a, CGFloat c, CGFloat tx,
                 CGFloat b, CGFloat d, CGFloat ty)
        {
            _impl.a = a;
            _impl.b = b;
            _impl.c = c;
            _impl.d = d;
            _impl.tx = tx;
            _impl.ty = ty;
        }
        
        
        void get(CGFloat& a, CGFloat& c, CGFloat& tx,
                 CGFloat& b, CGFloat& d, CGFloat& ty) const
        {
            a = _impl.a;
            b = _impl.b;
            c = _impl.c;
            d = _impl.d;
            tx = _impl.tx;
            ty = _impl.ty;
        }
        
        
        static Matrix makeTranslation(CGFloat tx, CGFloat ty)
        {
            return Matrix(CGAffineTransformMakeTranslation(tx, ty));
        }
        
        static Matrix makeScale(CGFloat sx, CGFloat sy)
        {
            return Matrix(CGAffineTransformMakeScale(sx, sy));
        }
        
        static Matrix makeScale(CGFloat s)
        {
            return makeScale(s, s);
        }
        
        static Matrix makeRotation(CGFloat angle)
        {
            return Matrix(CGAffineTransformMakeRotation(angle));
        }
        
        void scale(CGFloat sx, CGFloat sy)
        {
            _impl = CGAffineTransformScale(_impl, sx, sy);
        }
        
        void rotate(CGFloat angle)
        {
            _impl = CGAffineTransformRotate(_impl, angle);
        }
        
        void translate(CGFloat tx, CGFloat ty)
        {
            _impl = CGAffineTransformTranslate(_impl, tx, ty);
        }
        
        CGFloat calScaleX() const       {   return std::sqrt(_impl.a * _impl.a + _impl.c * _impl.c);    }
        CGFloat calScaleY() const       {   return std::sqrt(_impl.b * _impl.b + _impl.d * _impl.d);    }
        CGFloat calRotation() const     {   return std::atan(_impl.b / _impl.d);                        }
        
        operator CGAffineTransform() const  {   return _impl;   }
        
        friend Matrix operator * (const Matrix& lhs, const Matrix& rhs);
        friend bool   operator == (const Matrix& lhs, const Matrix& rhs);
        
    private:
        CGAffineTransform   _impl;
    };
    
    
    inline Matrix operator * (const Matrix& lhs, const Matrix& rhs)
    {
        return Matrix(CGAffineTransformConcat(lhs._impl, rhs._impl));
    }
    
    
    inline Point operator * (const Matrix& lhs, const Point& pt)
    {
        auto tmp = CGPointApplyAffineTransform(pt, lhs);
        return Point(tmp.x, tmp.y);
    }
    
    
    inline bool operator == (const Matrix& lhs, const Matrix& rhs)
    {
        return CGAffineTransformEqualToTransform(lhs._impl, rhs._impl);
    }
}



#endif
