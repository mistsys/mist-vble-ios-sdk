//
//  MSTCentralManager+Analytics.h
//  MistSDK
//
//  Created by Nirmala Jayaraman on 2/16/17.
//  Copyright © 2017 Mist. All rights reserved.
//

#import <MistSDK/MistSDK.h>

@interface MSTCentralManager (Analytics)

// Analyze in/out time for Bob
@property (nonatomic, strong) NSMutableDictionary *requestHandlerCounterDict;
@property (nonatomic, strong) NSMutableArray *requestInTimeIntsDiffArr;
@property (nonatomic, strong) NSMutableDictionary *requestInTimeIntsHistoric;
@property (nonatomic) NSDate *previousOutDate;
@property (nonatomic) unsigned int minCounter;
@property (nonatomic) NSDate *previousInDate;
@property (nonatomic, strong) NSMutableDictionary *histogramInTime;
@property (nonatomic, strong) NSMutableDictionary *clientInformation;
@property (nonatomic) bool shouldCompressData;

/**
 *  Get accumulative transmitted data size;
 *
 *  @return size in bytes
 */
-(NSUInteger)getAccumulativeTXSize;

/**
 *  Get accumulative received data size;
 *
 *  @return size in bytes
 */
-(NSUInteger)getAccumulativeRXSize;

/**
 *  Set the environment type to connect to the correct Mist environment.
 *
 *  @param envType - The values for this param is D,S,P.
 */
- (void) setEnviroment:(NSString *)envType;

//Special APIs

- (void) setPFWayFindingParam1: (int) way1 param2: (int) way2;
- (void) setSpeed: (float) speed;
- (void) setSdsParam1: (int) speedSD param2: (int) speedSDEst param3: (int) angle1SD param4: (int) angle2SD param4: (int) leSD;

@end
