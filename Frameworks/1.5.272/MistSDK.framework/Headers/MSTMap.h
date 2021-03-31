//
//  Map.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MSTEnum.h"

@interface MSTMap : NSObject <NSCopying>

@property (nonatomic, strong, readonly) NSString *mapName;
@property (nonatomic, strong, readonly) NSString *mapId;
@property (nonatomic, readonly) double mapScale;
@property (nonatomic, readonly) double ppm;
@property (nonatomic, readonly) CLLocationCoordinate2D mapOrigin;
@property (nonatomic, readonly) CLLocationCoordinate2D mapTopLeft;
@property (nonatomic, readonly) CLLocationCoordinate2D mapBottomRight;
@property (nonatomic, readonly) MapType mapType;
@property (nonatomic, readonly) double originX;
@property (nonatomic, readonly) double originY;
@property (nonatomic, readonly) double mapHeight;
@property (nonatomic, readonly) double mapWidth;
@property (nonatomic, readonly) NSString *mapURL;
@property (nonatomic, readonly) NSString *siteId;

@property (nonatomic, readonly) NSDictionary *wayfindingPath;
@property (nonatomic, readonly) NSDictionary *wayfinding;
@property (nonatomic, readonly) NSArray *sitesurveyPath;
@property (nonatomic, readonly) double orientation;

-(instancetype)init;

/**
 *  Creates a deep copy of the object
 */
-(instancetype)copyWithZone:(NSZone *)zone;

@end
