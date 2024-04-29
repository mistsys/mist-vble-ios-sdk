//
//  DrLib.h
//  MistDR
//
//  Created by Rajesh Vishwakarma on 03/07/23.
//  Copyright © 2023 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DREstimateData : NSObject
@property(nonatomic, copy) NSString *jsonData;
@property(nonatomic, assign) double scale;
@property(nonatomic, assign) double magHeading;
@property(nonatomic, assign) double leX;
@property(nonatomic, assign) double leY;
@property(nonatomic, assign) double vX;
@property(nonatomic, assign) double vY;
@end

@interface DrLib : NSObject

+ (void)initDR;
+ (NSArray*)getDrEstimateWith:(DREstimateData*)inputData;
+ (void)adjustHeading:(double)magHeading;

@end


NS_ASSUME_NONNULL_END
