//
//  Zone.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSTClient.h"

@interface MSTZone : NSObject

@property (nonatomic, strong, readonly) NSString *zoneId;
@property (nonatomic, strong, readonly) NSArray *clientList;
@property (nonatomic, strong, readonly) NSArray *assetList;

@end
