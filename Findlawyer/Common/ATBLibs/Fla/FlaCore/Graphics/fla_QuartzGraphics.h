//
//  fla_QuartzRender.h
//  SceneEditor
//
//  Created by HJC on 12-12-24.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_QUARTZRENDER__
#define __FLA_QUARTZRENDER__


#include "fla_types.h"
#include "fla_Graphics.h"
#include <vector>
#include "fla_Color4.h"


namespace fla
{
    class QuartzGraphics
    {
    public:
        explicit QuartzGraphics(CGContextRef ctx) : _context(ctx)    {}
        
        void moveTo(scalar x, scalar y)
        {
            CGContextMoveToPoint(_context, x, y);
        }
        
        void lineTo(scalar x, scalar y)
        {
            CGContextAddLineToPoint(_context, x, y);
        }
        
        void quadCurveTo(scalar ctlx, scalar ctly, scalar x, scalar y)
        {
            CGContextAddQuadCurveToPoint(_context, ctlx, ctly, x, y);
        }
        
        void beginPath()
        {
            CGContextBeginPath(_context);
        }
        
        void closePath()
        {
            CGContextClosePath(_context);
        }
        
        enum DrawingMode
        {
            PathEOFill          =   kCGPathEOFill,
            PathStroke          =   kCGPathStroke,
            PathEOFillStroke    =   kCGPathEOFillStroke,
        };
        
        void drawPath(DrawingMode mode)
        {
            CGContextDrawPath(_context, (CGPathDrawingMode)mode);
        }
        
        void setStrokeColor(scalar r, scalar g, scalar b, scalar a)
        {
            CGContextSetRGBStrokeColor(_context, r, g, b, a);
        }
        
        void setFillColor(scalar r, scalar g, scalar b, scalar a)
        {
            CGContextSetRGBFillColor(_context, r, g, b, a);
        }
        
        void scaleCTM(scalar sx, scalar sy)
        {
            CGContextScaleCTM(_context, sx, sy);
        }
        
        void translateCTM(scalar tx, scalar ty)
        {
            CGContextTranslateCTM(_context, tx, ty);
        }
        
        void rotateCTM(scalar angle)
        {
            CGContextRotateCTM(_context, angle);
        }
        
        void concatCTM(const Matrix& trans)
        {
            CGContextConcatCTM(_context, trans);
        }
        
        void setLineWidth(scalar lineWidth)
        {
            CGContextSetLineWidth(_context, lineWidth);
        }
        
        void saveGState()
        {
            CGContextSaveGState(_context);
        }
        
        void drawImage(CGRect rt, CGImageRef img)
        {
            CGContextDrawImage(_context, rt, img);
        }
        
        void restoreGState()
        {
            CGContextRestoreGState(_context);
        }
        
        CGContextRef context() const    {   return _context;    }
        
        enum LineCap
        {
            LineCapButt = kCGLineCapButt,
            LineCapRound = kCGLineCapRound,
            LineCapSquare = kCGLineCapSquare,
        };
        
        void setLineCap(LineCap lineCap)
        {
            CGContextSetLineCap(_context, (CGLineCap)lineCap);
        }
        
        void setMiterLimit(CGFloat limit)
        {
            CGContextSetMiterLimit(_context, limit);
        }
        
        
        enum LineJoin
        {
            LineJoinMiter = kCGLineJoinMiter,
            LineJoinRound = kCGLineJoinRound,
            LineJoinBevel = kCGLineJoinBevel,
        };
    
        void setLineJoin(LineJoin join)
        {
            CGContextSetLineJoin(_context, (CGLineJoin)join);
        }
        
        void clipPath()
        {
            CGContextEOClip(_context);
        }
        
        void drawGradient(const std::vector<Color4>& colors,
                          const std::vector<CGFloat>& locations,
                          bool  isLinaer,
                          CGFloat radius,
                          const Matrix& trans
                          );
        
    private:
        QuartzGraphics(const QuartzGraphics& rhs);
        QuartzGraphics& operator = (const QuartzGraphics& rhs);
        
    private:
        CGContextRef    _context;
    };
}



#endif
