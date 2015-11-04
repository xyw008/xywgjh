/*
  ColorSpaces.c

  Created by HJC on 11-10-11.
  Copyright 2011年 __MyCompanyName__. All rights reserved.
*/

#include "ATColorSpace.h"
#include <math.h>


static inline float color_max3(float a, float b, float c)
{
    float max = a > b ? a : b;
    max = max > c ? max : c;
    return max;
}


static inline float color_min3(float a, float b, float c)
{
    float min = a < b ? a : b;
    min = min < c ? min : c;
    return min;
}



void color_rbg_to_hsb(float red, float green, float blue, float* ph, float* ps, float* pb)
{
    float maxC = color_max3(red, green, blue);    
    float minC = color_min3(red, green, blue);
    
    float delta = maxC - minC;
    
    float V = maxC;
    float S = 0;
    float H = 0;
    
    if (fabsf(delta) > 0.001)
    {
        S = delta / maxC;
        
        float dR = 60.0f * (maxC - red) / delta + 180.0f;
        float dG = 60.0f * (maxC - green) / delta + 180.0f;
        float dB = 60.0f * (maxC - blue) / delta + 180.0f;
        
        if (red == maxC)
        {
            H = dB - dG;
        }
        else if (green == maxC)
        {
            H = 120.0f + dR - dB;
        }
        else
        {
            H = 240.0f + dG - dR;
        }
        
        if (H < 0.0f)
        {
            H += 360.0f;
        }
        
        if (H >= 360.0f)
        {
            H -= 360.0f;
        }
    }
    
    *ph = H;
    *ps = S;
    *pb = V;
}







void color_hsb_to_rgb(float hue, float saturation, float brightness, float* pr, float* pg, float* pb)
{
    float hDiv60 = hue / 60;
    int caseH = (int)hDiv60 % 6;
    
    float f = hDiv60 - caseH;
    float p = brightness * (1.0f - saturation);
    float q = brightness * (1.0f - saturation * f);
    float t = brightness * (1.0f - saturation * (1.0f - f));
    
    float red = 0.0f;
    float green = 0.0f;
    float blue = 0.0f;
    
    switch (caseH)
    {
        case 0:
            red = brightness, green = t, blue = p;
            break;
            
        case 1:
            red = q, green = brightness, blue = p;
            break;
            
        case 2:
            red = p, green = brightness, blue = t;
            break;
            
        case 3:
            red = p, green = q, blue = brightness;
            break;
            
        case 4:
            red = t, green = p, blue = brightness;
            break;
            
        case 5:
            red = brightness, green = p, blue = q;
            break;
            
        default:
            break;
    }
    
    *pr = red;
    *pg = green;
    *pb = blue;
}