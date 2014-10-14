//
//  Global.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-11.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

/*#ifndef LBSYunDemo_LBSYunDemoUIKey_h
#define LBSYunDemo_LBSYunDemoUIKey_h

#ifndef LBSMapKey
#define LBSMapKey @"3599D0BCD3569F06EB70D4704AD3D79203ED0AEC"
#endif

#ifndef LBSAppCloudDataBoxID
#define LBSAppCloudDataBoxID	30960
#endif

#ifndef LBSAppCloudKey
#define LBSAppCloudKey	@"A4749739227af1618f7b0d1b588c0e85"
#endif


#ifndef	LBSUIIndex0Title
#define LBSUIIndex0Title @"百度LBS云 短租"
#endif

#ifndef	LBSUIIndex1Title
#define LBSUIIndex1Title @"百度LBS云 短租"
#endif

#ifndef LBSUIIndex0BarTitle
#define LBSUIIndex0BarTitle	@"Info"
#endif

#ifndef LBSUIIndex0CellID
#define LBSUIIndex0CellID	@"LBSTableViewCell"
#endif

#ifndef LBSUIIndex1BarTitle
#define LBSUIIndex1BarTitle	@"Map"
#endif

#ifndef	LBSUINetWorkError
#define LBSUINetWorkError @"网络不给力:("
#endif

#ifndef	LBSUINoMoreData
#define LBSUINoMoreData @"没有满足条件的信息:("
#endif

#ifndef	LBSUIDataComplete
#define LBSUIDataComplete @"加载完毕:)"
#endif

#ifndef	LBSUIBarBtnPlace
#define LBSUIBarBtnPlace @"筛选"
#endif

#ifndef	LBSUIBarBtnNear
#define LBSUIBarBtnNear @"附近"
#endif

#ifndef LBSRequestBaseURLString
#define LBSRequestBaseURLString @"http://api.map.baidu.com/geosearch/poi"
#endif
#endif*/

#define STRING_UN_NSNULL(string)  ([string isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", string])
#define STRING_UN_NIL(string)  (string.length == 0 ? @"" : [NSString stringWithFormat:@"%@", string])

#define ChangeCitySignal       @"ChangeCitySignal"          // 更换城市

#define SignalCellShowMap      @"SignalCellShowMap"  //cell 中点了地图Button后发的通知
#define SignalCellopenUrl      @"SignalCellopenUrl"  //cell 中点了网址Button后发的通知
#define SignalCellCall         @"SignalCellCall"     //cell 中点了电话Button后发的通知
#define SignalCellSendSms      @"SignalCellSendSms"  //cell 中点了短信Button后的通知

#define SignalCellConSult      @"SignalCellConSult"  //cell 中点了咨询Button后的通知




typedef void (^CompletionBlock) (NSInteger result, NSString *message, id userInfo);

typedef enum NetReturnType : NSInteger
{
    WebSucceed = 100,
    NetBeginRequest = 1,
    NetRequesting,
    
    NetErrorUnknow,           // 未知的错误
    NetParameterError,        // 参数错误
    NetworkDisenable,         // 无网络
    NetDisconnection,         // 断开连接
    
} NetReturnType;

typedef enum SearchType : NSInteger
{
   SearchHouse = 0, // 搜索律所
   searchLawyer = 1, // 搜索律师
    
} SearchType;

typedef enum SearchItem : NSInteger
{
    SearchDetail = 0,
    SearchNearby = 1,
    SearchRegion = 2,

}  SearchItem;


typedef void (^NetworkBlock) (NSInteger result, NSError *error, id userInfo);