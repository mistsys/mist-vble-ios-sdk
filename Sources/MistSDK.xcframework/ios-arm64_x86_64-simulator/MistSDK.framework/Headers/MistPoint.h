//
//  MistPoint.h
//  MistSDK
//
//  Created by Dinkar Kumar on 01/04/22.
//  Copyright © 2022 Mist. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MistMap.h"

typedef NS_ENUM(NSInteger, MistPointType) {
    MistPointTypeLE,
    MistPointTypeDR,
    MistPointTypeLast,
};

@interface MistPoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic) bool hasMotion;
@property (nonatomic) MistPointType type;
@property (nonatomic) double latency;
@property (nonatomic, strong) NSNumber *heading;
@property (nonatomic, strong) MistMap *map;

-(id)init:(id)point;

@end
