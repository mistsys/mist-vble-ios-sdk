//
//  MSPoint.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/22/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSTPointType) {
    MSTPointTypeLE,
    MSTPointTypeDR,
    MSTPointTypeLast,
};

@interface MSTPoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) bool hasMotion;
@property (nonatomic) MSTPointType type;
@property (nonatomic) double latency;
@property (nonatomic) bool headingFlag;
@property (nonatomic) double heading;

@property (nonatomic, strong) NSNumber *rX;
@property (nonatomic, strong) NSNumber *rY;
@property (nonatomic, strong) NSNumber *rZ;
@property (nonatomic, strong) NSNumber *rHeading;
@property (nonatomic, strong) NSNumber *rSpeed;
@property (nonatomic, strong) NSNumber *rQ;
@property (nonatomic, strong) NSNumber *rU;
@property (nonatomic, strong) NSNumber *rV;
@property (nonatomic, strong) NSNumber *rLat;
@property (nonatomic, strong) NSNumber *rLon;
@property (nonatomic, strong) NSNumber *rMapID;
@property (nonatomic, strong) NSNumber *rTime;

@property (nonatomic, strong) NSNumber *sX;
@property (nonatomic, strong) NSNumber *sY;
@property (nonatomic, strong) NSNumber *sZ;
@property (nonatomic, strong) NSNumber *sHeading;
@property (nonatomic, strong) NSNumber *sSpeed;
@property (nonatomic, strong) NSNumber *sQ;
@property (nonatomic, strong) NSNumber *sU;
@property (nonatomic, strong) NSNumber *sV;
@property (nonatomic, strong) NSNumber *sLat;
@property (nonatomic, strong) NSNumber *sLon;
@property (nonatomic, strong) NSNumber *sMapID;
@property (nonatomic, strong) NSNumber *sTime;

@property (nonatomic) MSTPointType pointType;

-(id)initWithX:(double)x andY:(double)y;

-(id)initWithDict:(NSDictionary *)dr;

-(id)initWithCGPoint:(CGPoint)point;

-(CGPoint)convertToCGPoint;

@end
