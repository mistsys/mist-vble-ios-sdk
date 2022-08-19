//
//  Asset.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSTZone.h"

@interface MSTAsset : NSObject

@property (nonatomic, strong, readonly) NSString *assetName;
@property (nonatomic, strong, readonly) NSArray *zoneList;

@end
