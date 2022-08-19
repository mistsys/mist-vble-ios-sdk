//
//  MSTBeaconRegion.h
//  MistSDK
//
//  Created by Nirmala Jayaraman on 5/4/17.
//  Copyright © 2017 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTBeaconRegion : NSObject <NSCopying>

#pragma mark - READ ONLY PROPERTIES

//The proximity ID of the beacon being targeted. This value must not be nil
@property (nonatomic, strong, readonly) NSUUID *proximityUUID;

//The major value that you use to identify one or more beacons
@property (nonatomic, readonly) int major;

//The minor value that you use to identify a specific beacon
@property (nonatomic, readonly) int minor;

//A unique identifier to associate with the returned region object. You use this identifier to differentiate regions within your application. This value must not be nil
@property (nonatomic, strong, readonly) NSString *identifier;


#pragma mark - INITIALIZATION

//Initializes and returns a region object that targets a beacon with the specified proximity ID
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID
                           identifier:(NSString *)identifier;

//Initializes and returns a region object that targets a beacon with the specified proximity ID and major value
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID
                                major:(int)major
                           identifier:(NSString *)identifier;

//Initializes and returns a region object that targets a beacon with the specified proximity ID, major value, and minor value
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID
                                major:(int)major
                                minor:(int)minor
                           identifier:(NSString *)identifier;

+(NSString *) description: (MSTBeaconRegion *) beaconRegion;

-(id)copyWithZone:(NSZone *)zone;

@end
