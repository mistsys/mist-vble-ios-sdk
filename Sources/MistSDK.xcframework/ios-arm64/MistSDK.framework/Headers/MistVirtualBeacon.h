//
//  MistVBeacon.h
//  MistSDK
//
//  Created by Dinkar Kumar on 29/03/22.
//  Copyright © 2022 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MistVirtualBeacon;
@class AdditionalInfo;
@class BeaconPosition;


@interface MistVirtualBeacon : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *orgID;
@property (nonatomic, copy)   NSString *siteID;
@property (nonatomic, copy)   NSString *mapID;
@property (nonatomic, copy)   NSString *vbID;
@property (nonatomic, copy)   NSString *vbUUID;
@property (nonatomic, assign) long vbMajor;
@property (nonatomic, assign) long vbMinor;
@property (nonatomic, strong) BeaconPosition *position;
@property (nonatomic, strong) AdditionalInfo *additionalInfo;
@property (nonatomic, copy)           NSString *message;
@property (nonatomic, copy)           NSString *url;
@property (nonatomic, assign)         long power;
@property (nonatomic, copy)           NSString *power_mode;
@property (nonatomic, assign)         long created_time;
@property (nonatomic, assign)         long modified_time;
@property (nonatomic, nullable, copy) id tag_id;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
@interface AdditionalInfo : NSObject
@property (nonatomic, copy)   NSString *userID;
@property (nonatomic, copy)   NSString *clientType;
@property (nonatomic, assign) BOOL isRandom;
@property (nonatomic, copy)   NSString *proximity;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double rssi;
@property (nonatomic, assign) long orientation;
@property (nonatomic, copy)   NSString *direction;
@property (nonatomic, assign) long timeEpoch;
@property (nonatomic, copy)   NSString *timezone;
@property (nonatomic, assign) long tzoffset;
@property (nonatomic, assign) long origin;
@property (nonatomic, copy)           NSString *timestamp;
@property (nonatomic, assign)         long level;
@property (nonatomic, copy)           NSString *recipient;
@property (nonatomic, nullable, copy) id recipientID;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface BeaconPosition : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
