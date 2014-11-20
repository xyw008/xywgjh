//
//  CommonEntity.h
//  Find lawyer
//
//  Created by 龚 俊慧 on 14-10-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "NetItemList.h"

@interface HomePageNewsEntity : NetItem

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, strong) NSString *newsTitleStr;
@property (nonatomic, strong) NSString *newsDescStr;

@end

////////////////////////////////////////////////////

@interface HomePageBannerEntity : NetItem

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, strong) NSString *imgUrlStr;
@property (nonatomic, strong) NSString *newsUrlStr;

@end
