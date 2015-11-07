//
//  BLEManager.m
//  BabyBluetoothAppDemo
//
//  Created by 龚 俊慧 on 15/11/4.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import "BLEManager.h"
#import "SystemConvert.h"

@implementation BLEManager

// data: 蓝牙返回的数据 lenght: 校验的长度
+ (NSString *)hexStrByBLEData:(NSData *)data verifyLenght:(NSInteger)lenght
{
    // 蓝牙返回的数据为16进制的8个字节,或者16进制的13个字节
    if (data && lenght <= data.length)
    {
        NSString *hexStr = [NSString stringWithFormat:@"%@", data];
        hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        return hexStr;
    }
    return nil;
}

+ (CGFloat)getTemperatureWithBLEData:(NSData *)data
{
    NSString *hexStr = [self hexStrByBLEData:data verifyLenght:8];
    
    // 获取第二个和第三个字节符
    if (16 == hexStr.length)
    {
        NSString *byte1Str = [[hexStr substringWithRange:NSMakeRange(2, 2)] uppercaseString];
        NSString *byte2Str = [[hexStr substringWithRange:NSMakeRange(4, 2)] uppercaseString];
        
        // 04 AB 01 00 00 01 0A 02
        // (AB+01*256 ) / 10  = 42.7
        /*
         低于25度时
         输出aa aa 00 00
         高于45度时
         输出55 55 00 00
         */
        if ([byte1Str isEqualToString:@"AA"] && [byte2Str isEqualToString:@"AA"])
        {
            return 24;
        }
        else if ([byte1Str isEqualToString:@"55"] && [byte2Str isEqualToString:@"55"])
        {
            return 46;
        }
        else
        {
            CGFloat result = ([SystemConvert hexToDecimal:byte1Str].integerValue + [SystemConvert hexToDecimal:byte2Str].integerValue * 256) / 10.0;
            
            return result;
        }
    }
    
    return 0.0f;
}

+ (NSInteger)getBatteryWithBLEData:(NSData *)data
{
    NSString *hexStr = [self hexStrByBLEData:data verifyLenght:8];
    
    if (16 == hexStr.length)
    {
        NSString *byte6 = [hexStr substringWithRange:NSMakeRange(12, 2)];
        return [SystemConvert hexToDecimal:byte6].integerValue * 10;
    }
    return NSNotFound;
}

+ (NSDictionary<NSString *,NSArray<BLECacheDataEntity *> *> *)getCacheTemperatureDataWithBLEData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSString *hexStr = [self hexStrByBLEData:data verifyLenght:13];
    
    if (26 == hexStr.length)
    {
        // 01 01 45 45 46 45 45 45 45 45 45  45 b5
        // 45 = (69+200)/10 = 26.9度（得到的十六进制的数据换算成10进制的数据再加200除以10就为温度值）
        /*
         第一字节(数据类型)     第二字节(测量组数)
         0      清除缓存数据	  0	失败
                              1	成功
         1      个/ 30S       1~6
         2      个/ 5min      1~100
         0x77	和校验错误      ——
         0x88	数据类型错误	  ——
         0x99	组数超出范围 	  ——
         */
        NSString *byte0 = [hexStr substringWithRange:NSMakeRange(0, 2)];
        NSInteger byte0Num = [SystemConvert hexToDecimal:byte0].integerValue;
        
        // 拿第一个字节做校验
        if (1 == byte0Num || 2 == byte0Num)
        {
            NSMutableArray<BLECacheDataEntity *> *resultArray = [NSMutableArray array];

            NSString *byte1 = [hexStr substringWithRange:NSMakeRange(2, 2)];
            NSString *key = [NSString stringWithFormat:@"%ld", [SystemConvert hexToDecimal:byte1].integerValue];
            
            for (int i = 4; i <= 23; i = i + 2) {
                NSString *hexSubStr = [hexStr substringWithRange:NSMakeRange(i, 2)];
                CGFloat temperature = ([SystemConvert hexToDecimal:hexSubStr].integerValue + 200) / 10.0;
                
                BLECacheDataEntity *entity = [[BLECacheDataEntity alloc] init];
                entity.temperature = temperature;
                
                [resultArray addObject:entity];
            }
            return @{key: resultArray};
        }
        else
        {
            NSString *errDesc = nil;
            if (byte0Num == [SystemConvert hexToDecimal:@"77"].integerValue)
            {
                errDesc = @"和校验错误";
            }
            else if (byte0Num == [SystemConvert hexToDecimal:@"88"].integerValue)
            {
                errDesc = @"数据类型错误";
            }
            if (byte0Num == [SystemConvert hexToDecimal:@"99"].integerValue)
            {
                errDesc = @"组数超出范围";
            }
            NSError *err = [NSError errorWithDomain:@"解析蓝牙缓存数据错误"
                                               code:1001
                                           userInfo:@{NSLocalizedDescriptionKey: errDesc}];
            *error = err;
        }
    }
    return nil;
}

@end
