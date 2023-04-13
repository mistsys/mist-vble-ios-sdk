//
//  MistZone.h
//  MistSDK
//
//  Created by Dinkar Kumar on 29/03/22.
//  Copyright © 2022 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MistZone;
@class ZonePosition;


@interface MistZone : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *userID;
@property (nonatomic, copy)   NSString *orgID;
@property (nonatomic, copy)   NSString *siteID;
@property (nonatomic, copy)   NSString *mapID;
@property (nonatomic, copy)   NSString *clientType;
@property (nonatomic, assign) BOOL isRandom;
@property (nonatomic, copy)   NSString *zoneID;
@property (nonatomic, strong) ZonePosition *position;
@property (nonatomic, copy)   NSString *trigger;
@property (nonatomic, copy)   NSString *time;
@property (nonatomic, copy)   NSString *sinceTime;
@property (nonatomic, assign) long timeEpoch;
@property (nonatomic, assign) long sinceTimeEpoch;
@property (nonatomic, copy)   NSString *sessionID;
@property (nonatomic, copy)   NSString *sessionBehavior;
@property (nonatomic, assign) long duration;
@property (nonatomic, assign) long deltaDuration;
@property (nonatomic, copy)   NSString *timezone;
@property (nonatomic, assign) long tzoffset;
@property (nonatomic, assign) long origin;
@property (nonatomic, copy)   NSString *timestamp;
@property (nonatomic, assign) long level;
@property (nonatomic, copy)   NSString *recipient;
@property (nonatomic, nullable, copy) id recipientID;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface ZonePosition : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

