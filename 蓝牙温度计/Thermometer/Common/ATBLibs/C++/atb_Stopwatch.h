//
//  atb_Stopwatch.h
//  PaintingBoard
//
//  Created by HJC on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef _ATB_STOPWATCH_H_
#define _ATB_STOPWATCH_H_


#include <sys/time.h>


namespace atb 
{
    // 一个计时器
    class Stopwatch
    {
    public:
        Stopwatch() : _startTime(0.0)   {}
        
        // 开始计算时间
        void    start()                {    _startTime = _currentTime();             }
        
        // 过去的时间
        double  elapsedTime()          {    return _currentTime() - _startTime;      }
        
    private:
        Stopwatch(const Stopwatch& rhs);
        Stopwatch& operator = (const Stopwatch& rhs);
        
        double _currentTime();
        
    private:
        double  _startTime;
    };
    
    
    ////////////////////////////////////////////
    inline double Stopwatch::_currentTime()
    {
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv,&tz);
        return  tv.tv_sec + static_cast<double>(tv.tv_usec) / 1000000.0;
    }
};



#endif
