//
//  ATUtf8.c
//  HJCLibs
//
//  Created by HJC on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "ATUtf8.h"


typedef unsigned int    uint32_t;
typedef unsigned char   uint8_t;


static unsigned int utf8Len(const char* utf8)
{
    uint8_t lead = *utf8;
    if (lead < 0x80)
        return 1;
    
    else if ((lead >> 5) == 0x6)
        return 2;
    
    else if ((lead >> 4) == 0xe)
        return 3;
    
    else if ((lead >> 3) == 0x1e)
        return 4;
    
    return 0;
}


static unsigned int toUtf8Len(uint32_t cp)
{
    if (cp < 0x80)
        return 1;
    
    else if (cp < 0x800)              
        return 2;
    
    else if (cp < 0x10000)            
        return 3;
    
    else      
        return 4;
    
    return 0;
}


inline static uint8_t mask8(char oc)
{
    return oc;
}


static const unsigned int nextUtf8(const char* utf8, const char* end, uint16_t* c)
{
    unsigned int len = utf8Len(utf8);
    if (utf8 + len > end)
    {
        return 0;
    }
    
    switch (len) 
    {
        case 0:
            break;
            
        case 1:
            *c = *utf8++;
            break;
            
        case 2:
        {
            uint32_t cp = mask8(*utf8++);
            cp = ((cp << 6) & 0x7ff) + (mask8(*utf8++) & 0x3f);
            *c = cp;
        }
            break;
            
        case 3:
        {
            uint32_t cp = mask8(*utf8++);
            cp = ((cp << 12) & 0xffff) + ((mask8(*utf8++) << 6) & 0xfff);
            cp += (*utf8++) & 0x3f;
            *c = cp;
        }
            break;
            
        case 4:
        {
            uint32_t cp = mask8(*utf8++);
            cp = ((cp << 18) & 0x1fffff) + ((mask8(*utf8++) << 12) & 0x3ffff);
            cp += (mask8(*utf8++) << 6) & 0xfff;
            cp += (*utf8++) & 0x3f;
            *c = cp;
        }
            break;
            
        default:
            break;
    }
    return len;
}



static unsigned int fillUtf8(char* utf8, const char* end, uint32_t cp)
{
    unsigned int len = toUtf8Len(cp);
    if (utf8 + len > end)
    {
        return 0;
    }
    
    switch (len) 
    {
        case 1:
            *(utf8++) = cp;
            break;
            
        case 2:
            *(utf8++) = (char)((cp >> 6)            | 0xc0);
            *(utf8++) = (char)((cp & 0x3f)          | 0x80);
            break;
            
        case 3:
            *(utf8++) = (char)((cp >> 12)           | 0xe0);
            *(utf8++) = (char)(((cp >> 6) & 0x3f)   | 0x80);
            *(utf8++) = (char)((cp & 0x3f)          | 0x80);
            break;
            
        case 4:
            *(utf8++) = (char)((cp >> 18)           | 0xf0);
            *(utf8++) = (char)(((cp >> 12) & 0x3f)  | 0x80);
            *(utf8++) = (char)(((cp >> 6) & 0x3f)   | 0x80);
            *(utf8++) = (char)((cp & 0x3f)          | 0x80);
            break;
            
        default:
            break;
    }
    
    return len;
}



extern unsigned int utf_16from8(uint16_t* dst, unsigned int dlen, const char* src, unsigned int slen)
{
    const char* ptr = src;
    const char* end = src + slen;
    unsigned int count = 0;
    
    if (dst == 0 || dlen == 0)
    {
        while (ptr < end)
        {
            unsigned int tmp = utf8Len(ptr);
            if (tmp == 0)
            {
                break;
            }
            ptr += tmp;
            count++;
        }
        return count;
    }
    else
    {
        while (ptr < end && count < dlen)
        {
            unsigned int tmp = nextUtf8(ptr, end, dst);
            if (tmp == 0)
            {
                break;
            }
            
            ptr += tmp;
            count++;
            dst++;
        }
    }
    return count;
}




extern unsigned int utf_8from16(char* dst, unsigned int dlen, const uint16_t* src, unsigned int slen)
{
    const uint16_t* ptr = src;
    const uint16_t* end = src + slen;
    unsigned int count = 0;
    
    if (dst == 0 || dlen == 0)
    {
        while (ptr < end)
        {
            count += toUtf8Len((uint32_t)*ptr);
            ptr++;
        }
    }
    else
    {
        const char* utf8End = dst + dlen;
        const char* begin = dst;
        
        while (ptr < end && dst < utf8End)
        {
            unsigned int tmp = fillUtf8(dst, utf8End, (uint32_t)*ptr);
            if (tmp == 0)
            {
                break;
            }
            ptr++;
            dst += tmp;
        }
        count = dst - begin;
    }
    return count;
}
