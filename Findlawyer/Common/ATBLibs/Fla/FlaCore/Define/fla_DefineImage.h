//
//  fla_DefineImage.h
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINEIMAGE__
#define __FLA_DEFINEIMAGE__


#include <CoreGraphics/CoreGraphics.h>
#include "fla_Define.h"
#include "cocoa_CFObjHolder.h"


namespace fla
{
    class DefineImage : public Define
    {
    public:
        DefineImage() : _image(nullptr) {}
        
        void        setImage(CGImageRef image);
        CGImageRef  image() const           {   return _image.get();        }
        
        virtual     DefineType type() const {   return DefineType_Image;    }
        virtual void accept(DefineVisitor& visitor) const {   visitor.visitImage(*this);   }
        
    private:
        typedef cocoa::CFObjHolder<CGImageRef>  ImageHolder;
        ImageHolder  _image;
    };
    typedef util::rc_pointer<DefineImage>   DefineImagePtr;
    
    
    
    inline void DefineImage::setImage(CGImageRef image)
    {
        if (_image.get() != image)
        {
            _image = ImageHolder(CGImageRetain(image));
        }
    }
}



#endif
