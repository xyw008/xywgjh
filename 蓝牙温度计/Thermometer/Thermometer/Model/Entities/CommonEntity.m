//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"
#import "SystemConvert.h"
#import "BabyToy.h"

@implementation UserItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.memberId = [[dict safeObjectForKey:@"id"] integerValue];
        self.userName = [dict safeObjectForKey:@"name"];
        self.gender = [[dict safeObjectForKey:@"gender"] integerValue];
        self.age = [[dict safeObjectForKey:@"age"] integerValue];
        self.role = [[dict safeObjectForKey:@"role"] integerValue];
        NSString *str = [dict safeObjectForKey:@"image"];
        if (str)
        {
            self.imageStr = str;
            //NSString *dataStr = [NSString stringWithFormat:@"%@",str];
            //NSString *dataStr = [SystemConvert hexToBinary:str];
            //NSData* data= [BabyToy ConvertHexStringToData:str];
            NSData *data = [self stringToByte:str];
            self.image = [UIImage imageWithData:data];
        }
        else
            self.imageStr = @"";
    }
    return self;
}


- (NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}


@end



@implementation RemoteTempItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.temp = [[dict objectForKey:@"temp"] floatValue];
        self.time = [dict objectForKey:@"date"];
        
    }
    return self;
}


@end