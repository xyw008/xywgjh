//
//  FlaShapeWithStyle.h
//  FlashExporter
//
//  Created by HJC on 12-9-27.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLASHAPEWITHSTYLE__
#define __FLASHAPEWITHSTYLE__


#include <vector>
#include "fla_LineStyle.h"
#include "fla_FillStyle.h"
#include "fla_Path.h"


namespace fla
{
    template <int N>
    class ShapeBase
    {
    public:
        typedef     FillStyleBase<N>                FillStyleT;
        typedef     LineStyleBase<N>                LineStyleT;
        typedef  typename PathTypeTratis<N>::PathT  PathT;
        
        std::vector<FillStyleT>          fillStyles;
        std::vector<LineStyleT>          lineStyles;
        std::vector<PathT>               paths;
    };
    
    
    
    class Shape : public ShapeBase<1>
    {
    public:
        // 计算所有的边合起来的大小
        Rect computeEdgeBounds() const;
    };
    
    
    class MorphShape : public ShapeBase<2>
    {
    };
}



#endif
