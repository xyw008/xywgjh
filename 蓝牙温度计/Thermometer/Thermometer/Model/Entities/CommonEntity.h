//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"

@interface FAQEntity : NetItem

@property (nonatomic, strong) NSString *questionStr;
@property (nonatomic, strong) NSString *answerStr;

@end

///////////////////////////////////////////////////////////////

@interface _168Entity : NetItem

/*
"id": 8,
"topicId": 6,
"productId": 9,
"productName": "花唐草48型多用碗",
"productDesc1": "釉下彩工艺，长久如新",
"tag": 1,
"status": 0,
"price": 0,
"saleNum": 0,
"saleStatus": 0,
"promotionPrice": 1000,
"sort": 1,
"picture": "",
"createTime": 1413276954000,
"updateTime": 1413276954000
 */

@property (nonatomic, assign) NSInteger ID;                     // ID
@property (nonatomic, assign) NSInteger productId;              // 产品ID
@property (nonatomic, assign) NSInteger tag;                    // 产品类型标示   1:爆款 3:主推 6:一般性商品
@property (nonatomic, strong) NSString  *productPictureUrlStr;  // 产品图片
@property (nonatomic, strong) NSString  *productNameStr;        // 产品名称
@property (nonatomic, strong) NSString  *productDescStr;        // 产品描述
@property (nonatomic, assign) double    marketPrice;            // 原价
@property (nonatomic, assign) double    promotionPrice;         // 优惠价
@property (nonatomic, assign) NSInteger saleStatus;             // 销售状态       0:未售完 1:已售完
@property (nonatomic, assign) NSInteger saleNum;                // 以售出件数

@end
