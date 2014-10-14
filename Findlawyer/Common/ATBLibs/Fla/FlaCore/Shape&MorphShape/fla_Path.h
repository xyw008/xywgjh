//
//  fla_PathBase.h
//  SceneEditor
//
//  Created by HJC on 13-1-18.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_PATHBASE_H__
#define __FLA_PATHBASE_H__


#include <vector>
#include "fla_Holder.h"
#include "fla_EdgeList.h"

namespace fla
{
    template <int N, typename PathT>
    class PathBase
    {
    public:
        //! 无效的样式
        static const int InvalidStyle = -1;
    
        PathBase() : _lineStyle(PathBase::InvalidStyle), _fillStyle(PathBase::InvalidStyle)
        {
        }
        
        const std::vector<PathT>& subPaths() const     {   return _subPaths;                 }
        std::vector<PathT>& subPaths()                 {   return _subPaths;                 }
        
        bool hasLineStyle() const           {   return _lineStyle > PathBase::InvalidStyle;     }
        bool hasFillStyle() const           {   return _fillStyle > PathBase::InvalidStyle;     }
        
        void setLineStyle(int style)        {   _lineStyle = style;         }
        void setFillStyle(int style)        {   _fillStyle = style;         }
        
        int lineStyle() const               {   return _lineStyle;          }
        int fillStyle() const               {   return _fillStyle;          }
        
        typedef Holder<EdgeList, N> EdgeListT;
        
        template <int Idx>
        EdgeList& edges()               {   return _edges.get(Int2Type<Idx>());  }
        
        template <int Idx>
        const EdgeList& edges() const   {   return _edges.get(Int2Type<Idx>());  }
        
        const   Point& lastPoint() const        {   return edges().lastPoint();  }
        
        bool isSameLineStyle() const;
        
        
        bool isClosed() const
        {
            return edges<0>().isClosed();
        }
        
    private:
        int                         _lineStyle;
        int                         _fillStyle;
        std::vector<PathT>          _subPaths;
        EdgeListT                   _edges;
    };
    
    
    
    template <int N, typename PathT>
    bool PathBase<N, PathT>::isSameLineStyle() const
    {
        for (auto& holePath : _subPaths)
        {
            if (holePath.lineStyle() != lineStyle())
            {
                return false;
            }
            
            if (!holePath.isSameLineStyle())
            {
                return false;
            }
        }
        return true;
    }
    
    
    /////////////////////////////////////////////////
    struct Path : public PathBase<1, Path>
    {
    public:
        bool joint(const PathBase& path)
        {
            return edges<0>().joint(path.edges<0>());
        }
        
        bool isEdgesEqualTo(const PathBase& other) const
        {
            return edges<0>().isEdgesEqualTo(other.edges<0>());
        }
        
        bool isFlipEdgesEqualTo(const PathBase& other) const
        {
            return edges<0>().isFlipEdgesEqualTo(other.edges<0>());
        }
        
        void flipPath()
        {
            edges<0>().flipPath();
        }
        
    };
    
    
    class MorphPath : public PathBase<2, MorphPath>
    {
    public:
        bool joint(const PathBase& path)
        {
            return
            edges<0>().joint(path.edges<0>()) &&
            edges<1>().joint(path.edges<1>());
        }
        
        bool isEdgesEqualTo(const PathBase& other) const
        {
            return
            edges<0>().isEdgesEqualTo(other.edges<0>()) &&
            edges<1>().isEdgesEqualTo(other.edges<1>());
        }
        
        bool isFlipEdgesEqualTo(const PathBase& other) const
        {
            return
            edges<0>().isFlipEdgesEqualTo(other.edges<0>());
            edges<1>().isFlipEdgesEqualTo(other.edges<1>());
        }
        
        void flipPath()
        {
            edges<0>().flipPath();
            edges<1>().flipPath();
        }
    };
    
    
    template <int N>
    struct PathTypeTratis;
    
    template <>
    struct PathTypeTratis<1>    {   typedef Path PathT;         };
    
    template <>
    struct PathTypeTratis<2>    {   typedef MorphPath PathT;    };
}



#endif
