//
//  CppUtils.h
//
//  Created by HJC on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.

#ifndef _IDENTIFIER_H_
#define _IDENTIFIER_H_


#include <climits>


namespace atb 
{
    class ID64
    {
    public:
        static ID64 zero()
        {
            return ID64(0, 0);
        }
        
        ID64(unsigned int low, unsigned int height) : _low(low), _height(height)
        {
            static_assert(sizeof(ID64) == 8, "");
        }
        
        ID64() : _low(0), _height(0)
        {
            static_assert(sizeof(ID64) == 8, "");
        }
        
        bool operator == (const ID64& rhs) const
        {
            return (_low == rhs._low && _height == rhs._height);
        }
        
        bool operator != (const ID64& rhs) const
        {
            return (_low != rhs._low || _height != rhs._height);
        }
        
        bool operator < (const ID64& rhs) const
        {
            if (_height == rhs._height)
            {
                return _low < rhs._low;
            }
            return _height < rhs._height;
        }
        
        
        bool operator > (const ID64& rhs) const
        {
            return (rhs < *this);
        }
        
        ID64& operator++()
        {
            if (_low == UINT_MAX)
            {
                _height++;
            }
            else
            {
                _low++;
            }
            return *this;
        }
        
        ID64 operator++(int)
        {
            ID64 tmp = *this;
            if (_low == UINT_MAX)
            {
                _height++;
            }
            else
            {
                _low++;
            }
            return tmp;
        }
        
        unsigned int  low() const     {   return _low;    }
        unsigned int  height() const  {   return _height; }
        
    private:
        unsigned int    _low;       // 低位
        unsigned int    _height;    // 高位
    };
};



#endif