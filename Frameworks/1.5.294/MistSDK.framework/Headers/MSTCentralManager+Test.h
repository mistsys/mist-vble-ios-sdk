//
//  MSTCentralManager+Test.h
//  MistSDK
//
//  Created by Nirmala Jayaraman on 2/11/17.
//  Copyright © 2017 Mist. All rights reserved.
//

/*
 * All test only and Mist private methods will reside here
 */
#import <MistSDK/MistSDK.h>

@interface MSTCentralManager (Test)

#pragma mark - TEST only
@property (nonatomic) long timeElapsed;
@property (nonatomic) BOOL isAccuracyTestingOn;
@property (nonatomic) BOOL isStopAndGoDataCollection;
@property (nonatomic) BOOL isWalkTest;

@property (nonatomic, strong) NSString *zoneName;
@property (nonatomic, strong) NSString *zoneType;
@property (nonatomic, strong) NSDate *zoneDate;

- (NSString *) getDeviceId;
- (NSDictionary *) getDeviceInformation;
- (CLLocationCoordinate2D) getCurrentOSLocation;
- (NSString *) getResponseString;

//Test only APIs
- (void) setTopicName:(NSString *)topic;
- (void) setHostURL:(NSString *)hostUri;

#pragma mark - Data collection

- (void) setMarkerInformationWithDate:(NSString *)time MarkerX:(int)x AndY:(int)y;
- (void) setMarkerInformationWithDate:(NSString *)time MarkerX:(int)x AndY:(int)y AndRecordingId:(NSString *)recordingId;
- (void) setMarkerInformationWithDate:(NSString *)time MarkerX:(int)x AndY:(int)y AndRecordingId:(NSString *)recordingId AndWaypointName:(NSString *)waypointName;
- (void) setWalkMarkerInformationWithDate:(NSString *)time MarkerX:(int)x AndY:(int)y EndX: (int)endX AndEndY: (int)endY AndComments: (NSString *) walkComment __deprecated_msg("unsused");
- (void) startDataCollection;
- (void) stopDataCollection;
- (int) getCollectionCounter;
//- (void) spottedVbeacon;
- (void) incrementStaticX;
- (void) incrementStaticY;
- (void) decrementStaticX;
- (void) decrementStaticY;
- (NSString *) currentStaticLocation;

@end
