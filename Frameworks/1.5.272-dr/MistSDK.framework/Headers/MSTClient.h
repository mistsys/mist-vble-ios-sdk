//
//  Client.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSTUser.h"
#import "MSTZone.h"

@interface MSTClient : NSObject

@property (nonatomic, strong, readonly) NSUUID *clientUUID;
@property (nonatomic, strong, readonly) MSTUser *userInformation;
@property (nonatomic, strong, readonly) NSArray *zoneList;

@end
