/*
  ColorSpaces.h

  Created by HJC on 11-10-11.
  Copyright 2011年 __MyCompanyName__. All rights reserved.
*/

#ifndef _COLORSPACES_H_
#define _COLORSPACES_H_


#if defined(__cplusplus)
#define COLOR_EXTERN extern "C"
#else
#define COLOR_EXTERN extern
#endif


/* red, green, blue　between 0 and 1 */
/* hue 0 - 360, saturation, brightness 0 - 1 */

COLOR_EXTERN 
void color_rbg_to_hsb(float red, float green, float blue, float* ph, float* ps, float* pb);


COLOR_EXTERN 
void color_hsb_to_rgb(float hue, float saturation, float brightness, float* pr, float* pg, float* pb);



#endif