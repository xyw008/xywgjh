//
//  fla_Color4.h
//  SceneEditor
//
//  Created by HJC on 12-12-24.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_COLOR4__
#define __FLA_COLOR4__


#include "fla_types.h"


namespace fla
{
    class Color4
    {
    public:
        Color4() : red(1.0), green(1.0), blue(1.0), alpha(1.0)   {}
        Color4(scalar r, scalar g, scalar b, scalar a)
        : red(r), green(g), blue(b), alpha(a)   {}
        
        scalar   red;
        scalar   green;
        scalar   blue;
        scalar   alpha;
        
        bool operator == (const Color4& rhs) const
        {
            return
            red == rhs.red &&
            green == rhs.green &&
            blue == rhs.blue &&
            alpha == rhs.alpha;
        }
    };
}



#endif
