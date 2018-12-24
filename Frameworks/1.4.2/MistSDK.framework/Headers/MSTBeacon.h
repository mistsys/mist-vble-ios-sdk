//
//  Beacon.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MSTBeacon : NSObject

//The proximity ID of the beacon
@property (nonatomic, strong, readonly) NSUUID *proximityUUID;

//The most significant value in the beacon
@property (nonatomic, readonly) int major;

//The least significant value in the beacon
@property (nonatomic, readonly) int minor;

//The relative distance to the beacon as CLProximity
@property (nonatomic, readonly) CLProximity proximity;

//The relative distance to the beacon
@property (nonatomic, readonly) double distance;

//The accuracy of the proximity value, measured in meters from the beacon
@property (nonatomic, readonly) double accuracy;

//The received signal strength of the beacon, measured in decibels
@property (nonatomic, readonly) int rssi;

//Pretty print
- (NSString *) description;

@end
