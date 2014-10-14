//
//  fla_Holder.h
//  SceneEditor
//
//  Created by HJC on 13-1-18.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_HOLDER__
#define __FLA_HOLDER__


namespace fla
{
    template <typename T, int N = 1>
    class Holder;
    
    template <int N>
    struct Int2Type {};
    

    template <typename T>
    class Holder<T, 1>
    {
    public:
        Holder()                                        {}
        Holder(const T& v)                : val(v)      {}
        Holder& operator = (const T& v)
        {
            val = v;
            return *this;
        }
        
        Holder& operator = (const Holder<T, 1>& rhs)
        {
            val = rhs.val;
            return *this;
        }
        
        bool operator == (const Holder& rhs) const
        {
            return val == rhs.val;
        }
        
        T& get(Int2Type<0>)
        {
            return val;
        }
        
        const T& get(Int2Type<0>) const
        {
            return val;
        }
        
        const operator T() const    {   return val;    }
        operator T()                {   return val;    }
        
        T   val;
    };
    
    
    
    template <typename T>
    class Holder<T, 2>
    {
    public:
        bool operator == (const Holder& rhs) const
        {
            return start == rhs.start && end == rhs.end;
        }
        
        
        template <typename TT>
        Holder(const Holder<TT, 2>& rhs)
        {
            start = rhs.start;
            end = rhs.end;
        }
        
        
        Holder()
        {
        }
        
        
        T& get(Int2Type<0>)
        {
            return start;
        }
        
        const T& get(Int2Type<0>) const
        {
            return start;
        }
        
        T& get(Int2Type<1>)
        {
            return end;
        }
        
        const T& get(Int2Type<1>) const
        {
            return end;
        }
        
        template <typename ScaleT>
        auto operator * (ScaleT scale) const -> Holder<decltype(scale * T()), 2>
        {
            typedef decltype(scale * start) TT;
            Holder<TT, 2> result;
            result.start = start * scale;
            result.end = start * scale;
            return result;
        }
        
        
        template <typename ScaleT>
        auto operator / (ScaleT scale) const -> Holder<decltype(scale / T()), 2>
        {
            typedef decltype(scale * start) TT;
            Holder<TT, 2> result;
            result.start = start / scale;
            result.end = start / scale;
            return result;
        }
        
        
        T   start;
        T   end;
    };
}



#endif
