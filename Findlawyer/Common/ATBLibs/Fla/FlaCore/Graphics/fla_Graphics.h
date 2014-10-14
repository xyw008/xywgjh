//
//  fla_Graphics.h
//  SceneEditor
//
//  Created by HJC on 13-1-11.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_GRAPHICS__
#define __FLA_GRAPHICS__


#include "fla_types.h"
#include "fla_Matrix.h"


namespace fla
{
    // 需要完成这些的接口，才能完成最基本的渲染
    class Graphics
    {
    public:
        // 路径操作
        void beginPath()                                                {}
        void closePath()                                                {}
        void moveTo(scalar x, scalar y)                                 {}
        void lineTo(scalar x, scalar y)                                 {}
        void quadCurveTo(scalar ctlx, scalar ctly, scalar x, scalar y)  {}
    
        // 绘画参数
        void setStrokeColor(scalar r, scalar g, scalar b, scalar a)     {}
        void setFillColor(scalar r, scalar g, scalar b, scalar a)       {}
        void setLineWidth(scalar lineWidth)                             {}
        
        // 绘画
        enum DrawingMode
        {
            PathEOFill       =   kCGPathEOFill,
            PathStroke       =   kCGPathStroke,
            PathEOFillStroke =   kCGPathEOFillStroke,
        };
        void drawPath(DrawingMode mode)                                 {}
        
        void drawImage(CGRect rt, CGImageRef img)                       {}
        

        // 变换
        void scaleCTM(scalar sx, scalar sy)                             {}
        void translateCTM(scalar tx, scalar ty)                         {}
        void rotateCTM(scalar angle)                                    {}
        void concatCTM(const Matrix& trans)                             {}

        // 状态保存
        void saveGState()                                               {}
        void restoreGState()                                            {}
    };
}


#endif



