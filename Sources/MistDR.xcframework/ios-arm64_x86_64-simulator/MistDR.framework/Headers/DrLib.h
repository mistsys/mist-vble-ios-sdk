//
//  DrLib.h
//  MistDR
//
//  Created by Rajesh Vishwakarma on 03/07/23.
//  Copyright © 2023 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrLib : NSObject

+ (void)initDR;
+ (NSArray*)getDrEstimate:(NSString*)jsonData scale:(double)scale magHeading:(double)magHeading leX:(double)leX leY:(double)leY vX:(double)vX vY:(double)vY;
+ (void)adjustHeading:(double)magHeading;

@end

NS_ASSUME_NONNULL_END
