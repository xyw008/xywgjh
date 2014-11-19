//
//  LBSLawyer.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "LBSLawyer.h"
#import "LBSDataBase.h"
#import "LBSSharedData.h"
#import "LBSRequestManager.h"
#import <ImageIO/ImageIO.h>

@implementation LBSLawyer

#define PI 3.1415926

double calculateDist(double lon1,double lat1,
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
           // self.lfid = @([STRING_UN_NSNULL(dataModel[@"LF_id"]) integerValue]);
            self.lfid = dataModel[@"LF_id"] ;
            self.lawerid = dataModel[@"L_Id"] ;
            self.name = STRING_UN_NSNULL(dataModel[@"title"]);
            self.address = STRING_UN_NSNULL(dataModel[@"address"]);
            self.certificateNo = STRING_UN_NSNULL(dataModel[@"CertificateNo"]);
            self.specialArea = STRING_UN_NSNULL(dataModel[@"SpecialArea"]);
            self.isPhoto = dataModel[@"IsPhoto"];
            self.lawfirmName = STRING_UN_NSNULL(dataModel[@"LFName"]);
            id location = dataModel[@"location"];
            if (location) {
                self.coordinate = CLLocationCoordinate2DMake([location[1] doubleValue], [location[0] doubleValue]);
            }
            
            if ([[LBSSharedData sharedData] currentCoordinate2D].longitude == 0 &&
                [[LBSSharedData sharedData] currentCoordinate2D].latitude == 0)
                self.distance = 0;
            else
                self.distance = calculateDist(self.coordinate.longitude,
                                                                self.coordinate.latitude,
                                                                [[LBSSharedData sharedData] currentCoordinate2D].longitude,
                                                                [[LBSSharedData sharedData] currentCoordinate2D].latitude);
            if (dataModel[@"LawyerPhotoURL"])
            {
                NSDictionary * dic = (NSDictionary *)dataModel[@"LawyerPhotoURL"];
                self.mainImageURL = [NSURL URLWithString:dic[@"mid"]];
            }
            self.city = STRING_UN_NSNULL(dataModel[@"city"]);
            self.district = STRING_UN_NSNULL(dataModel[@"district"]);
            self.tel = STRING_UN_NSNULL(dataModel[@"Tel"]);
            self.mobile = STRING_UN_NSNULL(dataModel[@"Mobile"]);
        }
    }
    
	return self;
    
}


@end
