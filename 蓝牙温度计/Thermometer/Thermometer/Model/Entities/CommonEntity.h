//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"


///////////////////////////////////////////////////////////////
//成员Item
@interface UserItem : NetItem


@property (nonatomic,assign)NSInteger       memberId;
@property (nonatomic,copy)NSString          *userName;


@property (nonatomic,assign)NSInteger       gender;//性别
@property (nonatomic,assign)NSInteger       age;//年龄
@property (nonatomic,assign)NSInteger       role;//角色

@property (nonatomic,copy)NSString          *imageUrl;//头像url

@end


///////////////////////////////////////////////////////////////
//远程温度Item
@interface RemoteTempItem : NetItem


@property (nonatomic,assign)CGFloat         temp;//温度
@property (nonatomic,copy)NSString          *time;//时间

@end



