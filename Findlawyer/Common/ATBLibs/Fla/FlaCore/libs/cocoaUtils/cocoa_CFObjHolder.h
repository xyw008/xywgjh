//
//  cocoa_CFObjHolder.h
//  SDKiOSLayerTest
//
//  Created by HJC on 13-1-5.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __COCOA_CFOBJHOLDER__
#define __COCOA_CFOBJHOLDER__


namespace cocoa
{
    template <typename T>
    class CFObjHolder
    {
    public:
        explicit CFObjHolder(T ref = nullptr) : _ref(ref)
        {
        }
        
        ~CFObjHolder()
        {
            if (_ref)
            {
                CFRelease(_ref);
            }
        }
        
        CFObjHolder(const CFObjHolder<T>& rhs)
        {
            _ref = nullptr;
            if (rhs._ref)
            {
                _ref = (T)CFRetain(rhs._ref);
            }
        }
        
        CFObjHolder& operator = (const CFObjHolder<T>& rhs)
        {
            if (this != &rhs)
            {
                if (_ref)           {     CFRelease(_ref);    }
                _ref = nullptr;
                if (rhs._ref)       {   _ref = (T)CFRetain(rhs._ref);  }
                
            }
            return *this;
        }
        
        
        T get() const   {   return  _ref;   }
        
    private:
        T       _ref;
    };
}



#endif 
