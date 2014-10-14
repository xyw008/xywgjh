//
//  fla_QuartzGraphics.cpp
//  FlashIOSTest
//
//  Created by HJC on 13-2-19.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "fla_QuartzGraphics.h"
#include "ScopeGuard.h"


namespace fla
{
    void QuartzGraphics::drawGradient(const std::vector<Color4>& colors,
                                      const std::vector<CGFloat>& locations,
                                      bool  isLinaer,
                                      CGFloat radius,
                                      const Matrix& trans)
    {
        this->saveGState();
        ON_SCOPE_EXIT([&] { this->restoreGState(); });
        
        this->clipPath();
        this->concatCTM(trans);
        
        CGContextRef context = _context;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        ON_SCOPE_EXIT([=] { CGColorSpaceRelease(space); });
        
        auto recSize = colors.size();
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(space, &colors[0].red, &locations[0], recSize);
        ON_SCOPE_EXIT([=] { CGGradientRelease(gradient); });
        
        
        if (isLinaer)
        {
            CGPoint start = CGPointMake(-radius, 0);
            CGPoint end = CGPointMake(radius, 0);
            CGContextDrawLinearGradient(context, gradient, start, end,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        }
        else
        {
            CGContextDrawRadialGradient(context,
                                        gradient,
                                        CGPointMake(0, 0), 0,
                                        CGPointMake(0, 0),
                                        radius,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        }
    }
}