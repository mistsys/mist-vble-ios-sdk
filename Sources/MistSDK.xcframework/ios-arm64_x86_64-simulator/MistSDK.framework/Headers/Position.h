//
//  Position.h
//  MistSDK
//
//  Created by edelacruz on 2/15/22.
//  Copyright © 2022 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;

-(id)initWithX:(double)x Y:(double)y;

+(Position*)positionMakeX:(double)x Y:(double)y;

@end


