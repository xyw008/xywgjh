//
//  ATLayout+UIView.h
//  UITest
//
//  Created by  on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// edge是父view的边框，跟父views的bounds结合，表示排版的范围，比如edge.left=10, 就从x=10的地方开始排

// location是如 left,top的形式
// x方向可以取left,right,center,middle, 
// y方向可以取top,bottom,center,middle
// 其实middle,center意义一样（因为我自己分不清middle和center的区别)

// spaces表示view与view之间的空白，比如spaces="1,2", 有view0,view1,view2, view0和view1之间的空白就是1
// 有一特殊的取值为auto(也可写成flex), 使得view于view之间的空白变成一样的
// spaces可以写成 "1,2,auto,2,auto,3",

// isVertical为true表示垂直排版

// isGrid为true时表示使用grid模式，忽略spaces字段
typedef struct ATLayoutInfo
{
    UIEdgeInsets    edge;
    NSString*       location;
    NSString*       spaces;
    BOOL            isVertical;
    BOOL            isGrid;
} ATLayoutInfo;



@interface UIView(ATLayoutAddtions)

- (void) layoutSubview:(UIView*)aView withInfo:(ATLayoutInfo*)info;
- (void) layoutSubviews:(NSArray*)views withInfo:(ATLayoutInfo*)info;

@end


extern ATLayoutInfo ATLayoutInfoZero;

