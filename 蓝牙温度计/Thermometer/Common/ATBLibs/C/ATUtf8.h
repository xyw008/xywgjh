/*
  ATUtf8.h
  HJCLibs

  Created by HJC on 12-3-15.
  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
*/

#ifndef _ATUTF8_H_
#define _ATUTF8_H_


#if defined(__cplusplus)
#define UTF_EXTERN extern "C"
#else
#define UTF_EXTERN extern
#endif



/* utf8 和 utf16之间的相互转换 */
/* 返回值为转换后的长度 */
/* 使用的时候，可以先传进 0, 0 先得到需要空间的长度，分配好空间再进行转换 */

/* 比如
    int size = utf_16from8(0, 0, utf8, utf8len);
    uint16_t utf16 = malloc((size + 1) * 2);
    utf_16from8(utf16, size, utf8, utf8len);
    utf16[size] = 0;
*/
 
typedef unsigned short  uint16_t;
UTF_EXTERN unsigned int utf_16from8(uint16_t* dst,      unsigned int dlen, 
                                    const char* src,    unsigned int slen);


UTF_EXTERN unsigned int utf_8from16(char* dst,           unsigned int dlen, 
                                    const uint16_t* src, unsigned int slen);


#endif
