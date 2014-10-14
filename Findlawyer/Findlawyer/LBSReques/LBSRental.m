//
//  LBSRental.m
//  LBSYunDemo
//
//  Created by RetVal on 3/25/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRental.h"
#import "LBSDataBase.h"
#import "LBSSharedData.h"
#import "LBSRequestManager.h"
#import <ImageIO/ImageIO.h>

@implementation LBSRental (keyForContents)
+ (NSString *)name:(NSDictionary *)rentalObject
{
	return [rentalObject objectForKey:@"name"];
}

+ (NSString *)addr:(NSDictionary *)rentalObject
{
	return [rentalObject objectForKey:@"addr"];
}

+ (NSString *)city:(NSDictionary *)rentalObject
{
	return [rentalObject objectForKey:@"city"];
}

+ (NSInteger)city_id:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"city_id"] integerValue];
}

+ (NSInteger)databox_id:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"databox_id"] integerValue];
}

+ (NSInteger)distance:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"distance"] integerValue];
}

+ (NSString *)district:(NSDictionary *)rentalObject
{
	return [rentalObject objectForKey:@"district"];
}

+ (NSInteger)district_id:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"district_id"] integerValue];
}

+ (CLLocationDegrees)latitude:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"latitude"] doubleValue];
}

+ (CLLocationDegrees)longitude:(NSDictionary *)rentalObject
{
	return [[rentalObject objectForKey:@"longitude"] doubleValue];
}

+ (NSDictionary *)extInformation:(NSDictionary *)rentalObject
{
	return [rentalObject objectForKey:@"ext"];
}
@end

@implementation LBSRental (Extra)

+ (NSInteger)extBookNight:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"booknight"] integerValue];
}

+ (NSInteger)extCommentNum:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"commentnum"] integerValue];
}

+ (NSString *)extCommentURL:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"commenturl"];
}

+ (NSUInteger)extDayPrice:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"dayprice"] unsignedIntegerValue];
}

+ (NSUInteger)extGoodRate:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"goodrate"] unsignedIntegerValue];
}

+ (NSUInteger)extGuestNumber:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"guestnum"] unsignedIntegerValue];
}

+ (NSURL *)extIconAddress:(NSDictionary *)extraInfo
{
	return [NSURL URLWithString:[extraInfo objectForKey:@"iconaddr"]];
}

+ (NSUInteger)extImageNumber:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"imagenum"] unsignedIntegerValue];
}

+ (NSURL *)extImageURL:(NSDictionary *)extraInfo
{
	return [NSURL URLWithString:[extraInfo objectForKey:@"imageurl"]];
}

+ (NSString *)extKitchen:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"kitchen"];
}

+ (NSUInteger )extLeastType:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"leasetype"] integerValue];
}

+ (NSString *)extLongBookDiscount:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"longbookdiscount"];
}

+ (NSUInteger)extLUID:(NSDictionary *)extraInfo
{
	return [[extraInfo objectForKey:@"luid"] unsignedIntegerValue];
}

+ (NSURL *)extMainimageURL:(NSDictionary *)extraInfo
{
	return [NSURL URLWithString:[extraInfo objectForKey:@"mainimage"]];
}

+ (NSURL *)extRoomURL:(NSDictionary *)extraInfo
{
	return [NSURL URLWithString:[extraInfo objectForKey:@"roomurl"]];
}

+ (NSString *)extStory:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"story"];
}

+ (NSURL *)extStoryURL:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"storyurl"];
}

+ (NSString *)extType:(NSDictionary *)extraInfo
{
	return [extraInfo objectForKey:@"type"];
}
@end

@implementation LBSRental
- (id)init
{
	return [super init];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ <mainImageURL : %@>, <%@,%@,%@,%@,%@,%ld,%@,(%f,%f)>", NSStringFromClass([self class]), _mainImageURL, _rentalName, _locationName, _detail, _districtName, _roomURL, (unsigned long)_price, _rentalType, _coordinate.latitude, _coordinate.longitude];
}

#define PI 3.1415926
double LantitudeLongitudeDist(double lon1,double lat1,
							  double lon2,double lat2)
{
	double er = 6378137;
	double radlat1 = PI*lat1/180.0f;
	double radlat2 = PI*lat2/180.0f;
	//now long.
	double radlong1 = PI*lon1/180.0f;
	double radlong2 = PI*lon2/180.0f;
	if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
	if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
	if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);
	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);
	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double dist  = theta*er;
	return dist;
}

- (id)initWithDataModel:(NSDictionary *)dataModel
{
	if (self = [super init])
	{
		if (dataModel)
		{
            if (1)
            {
                if ([dataModel[@"leasetype"] intValue] > 4) {
                    NSLog(@"warning range");
                    return nil;
                }
                self.locationName = dataModel[@"address"];
                self.price = [dataModel[@"dayprice"] unsignedIntegerValue];
                self.rentalName = dataModel[@"title"];
                id location = dataModel[@"location"];
                self.coordinate = CLLocationCoordinate2DMake([location[1] doubleValue], [location[0] doubleValue]);
                self.mainImageURL = [NSURL URLWithString:dataModel[@"mainimage"]];
                self.roomURL = [NSURL URLWithString:dataModel[@"roomurl"]];
                self.districtName = dataModel[@"district"];
                if ([[LBSSharedData sharedData] currentCoordinate2D].longitude == 0 &&
                    [[LBSSharedData sharedData] currentCoordinate2D].latitude == 0)
                    self.distance = 0;
                else
                    self.distance = LantitudeLongitudeDist(self.coordinate.longitude,
                                                           self.coordinate.latitude,
                                                           [[LBSSharedData sharedData] currentCoordinate2D].longitude,
                                                           [[LBSSharedData sharedData] currentCoordinate2D].latitude);
                self.rentalType = [[LBSDataBase sharedInstance] rentalTypes][[dataModel[@"leasetype"] intValue]];
                if (self.mainImageURL)
                {
                    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:self.mainImageURL] dataComplete:^(LBSRequest *request, id dataModel) {
                        if (dataModel)
                        {
#if TARGET_OS_IPHONE
                            self.mainImage = [UIImage imageWithData:dataModel];
                            
#endif
                        }
                    }];
                }
            }
            else {
                self.locationName = [LBSRental addr:dataModel];
                self.price = [LBSRental extDayPrice:[LBSRental extInformation:dataModel]];
                self.rentalName = [LBSRental name:dataModel];
                self.coordinate = CLLocationCoordinate2DMake([LBSRental latitude:dataModel], [LBSRental longitude:dataModel]);
                self.mainImageURL = [LBSRental extMainimageURL:[LBSRental extInformation:dataModel]];
                self.roomURL = [LBSRental extRoomURL:[LBSRental extInformation:dataModel]];
                self.districtName = [LBSRental district:dataModel];
                if ([[LBSSharedData sharedData] currentCoordinate2D].longitude == 0 &&
                    [[LBSSharedData sharedData] currentCoordinate2D].latitude == 0)
                    self.distance = 0;
                else
                    self.distance = LantitudeLongitudeDist(self.coordinate.longitude,
                                                           self.coordinate.latitude,
                                                           [[LBSSharedData sharedData] currentCoordinate2D].longitude,
                                                           [[LBSSharedData sharedData] currentCoordinate2D].latitude);
                self.rentalType = [[[LBSDataBase sharedInstance] rentalTypes] objectAtIndex:[LBSRental extLeastType:[LBSRental extInformation:dataModel]]];
                if (self.mainImageURL)
                {
                    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:self.mainImageURL] dataComplete:^(LBSRequest *request, id dataModel) {
                        if (dataModel)
                        {
#if TARGET_OS_IPHONE
                            self.mainImage = [UIImage imageWithData:dataModel];
                            
#endif
                        }
                    }];
                }
            }
		}
        
	}
	return self;
}
@end
