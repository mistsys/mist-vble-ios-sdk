//
//  MSCentralManager.h
//  MistLocation
//
//  Created by Nirmala Jayaraman on 1/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MSTEnum.h"
#import "MSTPoint.h"
#import "MSTMap.h"
#import "MSTUser.h"
#import "MSTAsset.h"
#import "MSTClient.h"
#import "MSTZone.h"
#import "MSTBeaconRegion.h"
#import "MSTBeacon.h"
#import "MSTEnum.h"

#import "MSTCentralManagerMapDataSource.h"

@protocol MSTCentralManagerDelegate;
@protocol MSTProximityDelegate;

/**
 *  The Mist Manager is the manager of all the other managers. It offers the ability to connect to the Mist Cloud, start the desired services, stop and terminate connection.
 *  Methods:
 *  Start mist manager service
 *
 *  Stop mist manager service
 *
 *  Prepare GroundOverlayOptions
 *
 *  Set Map Origin
 *
 *  Get current Mist Location
 *  Get current OS location
 *  Get Map Origin
 *
 *  Subscribe to the MSTCentralManagerDelegate to be notified of Mist Location updates, and to get debug messages
 *
 */
@interface MSTCentralManager : NSObject

@property (nonatomic, weak) id<MSTCentralManagerDelegate> delegate;
@property (nonatomic, weak) id<MSTProximityDelegate> proximityDelegate;
@property (nonatomic, weak) id<MSTCentralManagerMapDataSource> mapDataSource;

@property (nonatomic) NSUInteger smoothingNumber;

@property (nonatomic, assign) BOOL isSmoothingEnabled; //Private?

@property (nonatomic, assign) BOOL isRunning;

@property (nonatomic, assign) BOOL shouldShowVerboseLogs;

@property (nonatomic, assign) BOOL shouldSendLocationResponseAlways;

@property (nonatomic, assign) BOOL shouldSwitchToOSLocation;

@property (nonatomic, assign) BOOL shouldEnableDebugInfo;

@property (nonatomic, assign) BOOL shouldFetchApInfo;

/**
 *  Only send device motion if the user opt in, otherwise send NO for isDeviceMoving
 */
@property (nonatomic, assign) bool shouldSendDeviceIsMoving;

/**
 *  Set this property to true to send data via UDP, false will use TCP.
 */
@property (nonatomic, assign) BOOL shouldUseUDP;

@property (nonatomic, assign) BOOL shouldSendLogs; //Flag for checking if the logs should be sent

//Millibars off / on

@property (nonatomic, assign) BOOL shouldSendMillibars;

// Ranging Virtual Beacon

@property (nonatomic, assign) BOOL shouldRangeVirtualBeacon;

/**
 *  Get the SDK Bundle version
 */
+(NSString *)getSDKBundleVersion;

/**
 *  Get the Mobile SDK version
 */
+(NSString *)getMobileSDKVersion;

//Initialization

+(instancetype) sharedInstance;

-(void) removeNotifier;

/**
 *  Initialize the MSTCentralManager with orgID and orgSecret
 *
 *  @param orgId     tokenID for the organization
 *  @param orgSecret the tokenSecret for the organization
 *
 *  @return id an instance of MSTCentralManager
 */
-(id) initWithOrgID: (NSString *) orgId AndOrgSecret: (NSString *) orgSecret;

/**
 * Turn on or off compass
 * @param compassStatus on / off
 */
-(void) setCompassStatus: (BOOL) compassStatus;

//App Information
#pragma marker -
#pragma marker - App information (optional)

-(void) setAppInfoWithName: (NSString *) appName andVersion: (NSString *) appVersion;

/**
 *  Start the location updates
 */
-(void) startLocationUpdates;

/**
 *  Stop the location updates
 */
-(void) stopLocationUpdates;

//Location Response

/**
 *  Get the current location in lat, long
 *
 *  @return Returns the current location in CLLocationCoordinate2D (lat,long).
 */
-(CLLocationCoordinate2D) getCurrentLocation;

/**
 *  Get the current location in X, Y relative to top left corner of the floorplan
 *
 *  @return Returns the current location in MSTPoint.
 */
-(MSTPoint *) getCurrentRelativeLocation;

//Mapping

/**
 *  Get the map origin
 *
 *  @return Returns the map origin in CLLocationCoordinate2D.
 */
-(CLLocationCoordinate2D) getMapOrigin;

/**
 *  Get the map ID
 *
 *  @return Returns the map identifier.
 */
-(NSString *) getMapId;

/**
 *  Get the map object.
 *
 *  @return Returns the map object in MSTMap.
 */
-(MSTMap *) getMapDetails;

/**
 *  Get the map name.
 *
 *  @return Returns the map name.
 */
-(NSString *) getMapName;

/*!
 * Get all the maps on the site
 * @return maps a dictionary of maps keyed by mapId
 */
-(NSDictionary *)getMaps;

//Settings

/**
 *  Check if BLE power status is on.
 *
 *  @return Returns true or false for BLE power.
 */
-(BOOL) isBluetoothPowerOn;

/**
 *  Check if Location is authorized.
 *
 *  @return Returns true or false for Location authorization.
 */
-(BOOL) isLocationAuthorized;

/**
 *  Get the Location authorization status.
 *
 *  @return Returns the location authorization status.
 */
-(CLAuthorizationStatus) getLocationAuthorizationStatus;

-(void) requestAuthorization: (AuthorizationType) authorizationType;

-(void)saveClientInformation:(NSMutableDictionary *)clientInformation;

#pragma mark -- DR in Path

// TODO: move to a category once DR is well tested.

/**
 * Ingest the navigation path so DR can better snap the dot.
 */
-(void)setPathToDR:(NSData *)data;

/**
 * Clear the navigation path so DR can forget about the path
 */
-(void)clearPath;

/**
 * Get the inside dot configuration from DR. DR can either use LE vs. PF dot.
 * @return true means the DR is using LE. Default is false.
 */
-(BOOL)getUseLE;

/**
 * Set the inside dot configuration from DR. DR can either use LE vs. PF dot.
 */
-(void)setUseLE:(BOOL)useLE;

/**
 * Get the DR offset from DR
 */
-(NSNumber *)getDROffset;

/**
 * Get the DR snapped heading from DR
 */
-(NSNumber *)getDRClient;

#pragma mark --  RF recording

-(void)startRFRecording:(NSString *)siteId withFloorName:(NSString *)floorName withSurveyId:(NSString *)surveyId withSurveyName:(NSString *)surveyName;

-(void)stopRFRecording:(NSString *)siteId withRequestBody:(NSDictionary *)requestBody andRecordingId:(NSString *)recodringId;

/**
 * Setting that enables or disables SDK usage when app is woken using iBeacon regions
 */

/**
 * Setting that enables or disables SDK to work in background mode
 */
#pragma mark - Background app settings

-(void)wakeUpAppSetting:(BOOL)shouldWakeUpApp;

-(void)setMonitoringInBackground:(NSArray *)regions __deprecated;

-(void)setRangingInBackground:(NSArray *)regions __deprecated;

-(void)backgroundAppSetting:(BOOL)shouldWorkInBackground __deprecated;

-(void)setAppState: (UIApplicationState) appState;

+(UIApplicationState) getAppState;

// App wakeup

-(void) setSentTimeInBackgroundInMins: (double) sendTimeInBackgroundInMins
            restTimeInBackgroundInMins: (double) restTimeInBackgroundInMins;

-(void) sendWithoutRest;

#pragma mark - Ranging Virtual Beacons. Enable shouldRangeVirtualBeacon to receive virtual beacon ranging

/**
 *  Check if Location is authorized.
 *
 */
// Starts the delivery of notifications for beacons in the specified region
-(void)startRangingBeaconsInRegion:(MSTBeaconRegion *)beaconRegion;

/**
 *  Check if Location is authorized.
 *
 */
// Stops the delivery of notifications for the specified beacon region
-(void)stopRangingBeaconsInRegion:(MSTBeaconRegion *)beaconRegion;

/**
 * Optionally set log level
 */
-(void)setLogLevel:(MSTLoggerLogLevel)level;

/*
 * Method to set the value of the dwell property.
 * @param enable : BOOL
 * @param timestamp: NSString
 */
-(void)setDwell:(BOOL)enable atTimestamp:(NSString *)timestamp;

#pragma mark -

//UNIMPLEMENTED

//Clients
-(NSArray *) getAllClients;
//Zones
-(NSArray *) getAllZones;
//Assets
-(NSArray *) getAllAssets;

-(void) resumeLocationUpdates;
-(void) pauseLocationUpdates;

-(void)alert:(NSDictionary *)msgDict;

#pragma mark - App modified locations

-(void) sendAppModifiedLocation: (CLLocationCoordinate2D) location;

-(void) sendAppModifiedLocationX:(double) x y:(double) y;

#pragma mark - Convert x,y to lat, long

-(CLLocationCoordinate2D) getLatitudeLongitudeUsingMapOriginForX: (double) x AndY: (double) y;

#pragma mark - Lab for Testing

-(void) startTestsForDurationInMins: (long) mins;

#pragma mark - Compass / Dead reckoning settings

-(void) setCompassOffset: (int) compassOffset;
-(void) setUseOffset: (bool) useOffset;
-(void) setdDead: (bool) dDead;

-(void)setSendDRInternalsAlways:(BOOL)sendDRInternalsAlways;
-(BOOL) getSendDRInternalsAlways;
@end

@protocol MSTCentralManagerDelegate <NSObject>

#pragma mark - Old APIs
//TODO: Remove?

@optional
-(void)manager:(MSTCentralManager *) manager receive:(id)message;
-(void)manager:(MSTCentralManager *) manager receiveLogMessage: (NSString *)logMessages;

-(void)manager:(MSTCentralManager *) manager receivedLogMessage: (NSString *)message forCode:(MSTCentralManagerStatusCode)code;
-(void)manager:(MSTCentralManager *) manager receivedVerboseLogMessage: (NSString *)message;

-(void)manager:(MSTCentralManager *) manager notifications:(NSString *)notificationMessage;
-(void)manager:(MSTCentralManager *)manager restMessage: (NSString *)restMessage;//TODO: Debugging purposes. Need to remove

#pragma mark - New APIs

@optional

#pragma mark - Compass Callback
-(void) mistManager: (MSTCentralManager *) manager didUpdateHeading: (CLHeading *) headingInformation;

-(void) mistManager: (MSTCentralManager *) manager didUpdateLEHeading: (NSDictionary *) leInfo;

-(void) mistManager: (MSTCentralManager *) manager didUpdateDRHeading: (NSDictionary *) drInfo;

#pragma mark - Raw Beacon RSSIs
-(void) mistManager:(MSTCentralManager *)manager didUpdateBeaconList: (NSArray *) beaconList at: (NSDate *) dateUpdated;

#pragma mark - Raw estimate
-(void) mistManager:(MSTCentralManager *)manager didUpdateSecondEstimate: (MSTPoint *) estimate inMaps: (NSArray *) maps at: (NSDate *) dateUpdated;

#pragma mark - Virtual Beacon callbacks
/**
 * Called when beacons have been ranged in the beacon region
 * @param manager       Returns the caller
 * @param beacons       Returns the list of beacons ranged
 * @param region        Returns the beacon region in which maps were ranged
 */
-(void) manager: (MSTCentralManager *) manager didRangeBeacons:(NSArray<MSTBeacon *> *)beacons inRegion:(MSTBeaconRegion *)region;

#pragma mark - Location Callbacks

// Relative location callback

/**
 *  Called when MistFramework receives a location update and retrieving map information.
 *
 *  @param manager          Returns the caller
 *  @param relativeLocation Returns the relative location
 *  @param maps             Returns the maps
 *  @param dateUpdated      Returns the timeUpdated
 */
-(void)mistManager: (MSTCentralManager *) manager willUpdateRelativeLocation: (MSTPoint *) relativeLocation inMaps: (NSArray *) maps at: (NSDate *) dateUpdated;

// didUpdateRelativeLocation
// INDOOR ONLY: This function is called when we have both relative location and the actual map details for rendering.

/**
 *  Called when MistFramework receives a location update and has map information.
 *
 *  @param manager          Returns the caller
 *  @param relativeLocation Returns the relative location
 *  @param maps             Returns the maps
 *  @param dateUpdated      Returns the timeUpdated
 */
-(void)mistManager: (MSTCentralManager *) manager didUpdateRelativeLocation: (MSTPoint *) relativeLocation inMaps: (NSArray *) maps at: (NSDate *) dateUpdated;

/**
 *  Called when MistFramework receives a DR location update and has map information.
 *
 *  @param manager          Returns the caller
 *  @param drInfo Returns the relative location
 *  @param maps             Returns the maps
 *  @param dateUpdated      Returns the timeUpdated
 */
-(void)mistManager: (MSTCentralManager *) manager didUpdateDRRelativeLocation: (NSDictionary *) drInfo inMaps: (NSArray *) maps at: (NSDate *) dateUpdated;

-(void)mistManager: (MSTCentralManager *) manager didUpdateDRBackendRelativeLocation: (NSDictionary *) drInfo inMaps: (NSArray *) maps at: (NSDate *) dateUpdated;

//-(void)mistManager: (MSTCentralManager *)manager didUpdateComputedLocation:(MSTPoint *)point inMaps:(NSArray *)maps at:(NSDate *)dateUpdated;
//
//-(void)mistManager: (MSTCentralManager *)manager didUpdateAverageLocation:(MSTPoint *)point inMaps:(NSArray *)maps at:(NSDate *)dateUpdated;

-(void)mistManager: (MSTCentralManager *)manager didUpdatePle:(NSInteger)ple andIntercept:(NSInteger)intercept inMaps:(NSArray *)maps at:(NSDate *)dateUpdated;

-(void) mistManager:(MSTCentralManager *)manager didUpdateAngle: (double) angleOrientation inMaps:(NSArray *)maps at:(NSDate *)dateUpdated;

//Pressure callback
-(void) mistManager:(MSTCentralManager *)manager didUpdatePressure: (double) pressure at: (NSDate *)dateUpdated;

//Geolocation Callback

// willUpdateLocation
// INDOOR ONLY: This function is called when we have a location but the actual map details are not yet available. SourceType will always be MIST

-(void) mistManager: (MSTCentralManager *) manager willUpdateLocation: (CLLocationCoordinate2D) location inMaps: (NSArray *) maps withSource: (SourceType) locationSource  at: (NSDate *) dateUpdated;

// didUpdateRelativeLocation
// INDOOR and OUTDOOR: This function is called when we have both relative location and the actual map details.
/*
    SourceType:
    OS Location - This type will be returned when Bluetooth is turned off or beacons have not been detected. Most likely when the user is outdoor.
    MIST Location - This type will be returned when Bluetooth is turned on and beacons have been detected.
 */

-(void) mistManager: (MSTCentralManager *) manager didUpdateLocation: (CLLocationCoordinate2D) location inMaps: (NSArray *) maps withSource: (SourceType) locationSource  at: (NSDate *) dateUpdated;

//Accuracy of the location callback
//This function is called only when we have a location (relative or geolocation)

-(void) mistManager:(MSTCentralManager *)manager didLocateWithProbability: (double) probability andRadius: (double) radius at: (NSString *) dateUpdated;

#pragma mark - Beacon Callbacks

// Beacon callbacks

-(void) mistManager: (MSTCentralManager *) manager didRangeBeacons:(NSArray *)beacons inRegion: (CLRegion *) region  at: (NSDate *) dateUpdated;

#pragma mark - virtual beacons

-(void)mistManager:(MSTCentralManager *)manager didReceivedVirtualBeacons:(NSArray *)virtualBeacons;

#pragma mark - client information

-(void)mistManager:(MSTCentralManager *)manager didReceivedClientInformation:(NSDictionary *)clientInformation;

#pragma mark - virtual beacon proximity

-(void)startVirtualBeaconProximity:(CGPoint)currentLocation;

#pragma mark - app messages

/**
 *  Called when the SDK / Mist cloud wants to pass back non-location information to the app
 *
 *  @param manager     Returns the caller
 *  @param message     Returns the message
 *  @param dateUpdated Returns the date updated.
 */

-(void) mistManager:(MSTCentralManager *)manager didUpdateAppMessage: (NSString *) message dateUpdated: (NSString *) dateUpdated;

#pragma mark - STUBS

//Zone Stats callback
-(void) mistManager: (MSTCentralManager *) manager didUpdateZoneStats: (NSArray *)zones  at: (NSDate *) dateUpdated;
//User callback
-(void) mistManager: (MSTCentralManager *) manager didUpdateClients: (NSArray *)clients inZones: (NSArray *) zones  at: (NSDate *) dateUpdated;
//Asset callback
-(void) mistManager: (MSTCentralManager *)manager didUpdateAssets: (NSArray *)assets inZones: (NSArray *) zones  at: (NSDate *) dateUpdated;

#pragma mark - Background Mode

-(void)manager:(MSTCentralManager *)manager didUpdateLocations:(NSArray *)locations;
-(void)manager:(MSTCentralManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;

#pragma mark -

#pragma mark - Health Callbacks

// Health of connection callback

// didConnect
// This function is a little indicator letting the user knows it's connected

-(void) mistManager:(MSTCentralManager *)manager didConnect: (BOOL) isConnected;

//Error message callback
//This function is called to give an insight into any issues that might be occurring

-(void) manager:(MSTCentralManager *)manager didErrorOccurWithType: (ErrorType) errorType andDetails: (NSString *) errorDetails;

#pragma mark - Map Callbacks

// Map callback

/**
 *  Called when a map is being detected and fetched from the backend. This function will not be called when bluetooth is not turned on, hence it is for indoor purposes
 *
 *  @param manager     Returns the caller
 *  @param map         Returns the new map information
 *  @param dateUpdated Returns the date updated.
 */
-(void) mistManager: (MSTCentralManager *) manager willUpdateMap: (MSTMap *) map at: (NSDate *) dateUpdated;

/**
 *  Called when a map is being detected and fetched from the backend. This function will not be called when bluetooth is not turned on, hence it is for indoor purposes
 *
 *  @param manager     Returns the caller
 *  @param map         Returns the new map information
 *  @param dateUpdated Returns the date updated.
 */
-(void) mistManager: (MSTCentralManager *) manager didUpdateMap: (MSTMap *) map at: (NSDate *) dateUpdated;

/**
 *  Called when a map is being detected and fetched from the DR. This function will not be called when bluetooth is not turned on, hence it is for indoor purposes
 *
 *  @param manager     Returns the caller
 *  @param map         Returns the new map information
 *  @param dateUpdated Returns the date updated.
 */
-(void) mistManager: (MSTCentralManager *) manager didUpdateDRMap: (MSTMap *) map at: (NSDate *) dateUpdated;

/**
 * Provides the maps dictionary key by mapId
 *  @param manager     Returns the caller
 *  @param maps        Returns the the maps for all sites.
 *  @param dateUpdated Returns the date updated.
 */
-(void) mistManager: (MSTCentralManager *) manager didReceivedAllMaps: (NSDictionary *) maps at: (NSDate *) dateUpdated;

-(void) mistManager:(MSTCentralManager *)manager didUpdateLocationDate: (NSString *) locationUpdateDate;

#pragma mark - Setting Callbacks

// Settings callback

/**
 *  Called when setting type has changed
 *
 *  @param manager   Returns the caller
 *  @param isEnabled Returns the updated status.
 *  @param type      Returns the type of setting in MSTCentralManagerSettingType.
 */
-(void)mistManager:(MSTCentralManager *)manager didUpdateStatus:(MSTCentralManagerSettingStatus)isEnabled ofSetting:(MSTCentralManagerSettingType)type;

-(void)mistManager:(MSTCentralManager *)manager beaconsSent:(NSMutableArray *)beacons;

-(void)mistManager:(MSTCentralManager *)manager time:(double)time sinceSentForCounter:(NSString *)index;

-(void)mistManager:(MSTCentralManager *)manager restartScan:(NSString *)message;

-(void)mistManager:(MSTCentralManager *)manager didReceiveNotificationMessage:(NSDictionary *)payload;

-(void)mistManager:(MSTCentralManager *)manager didUpdateProximityToMinor: (int) minor;

-(void)mistManager:(MSTCentralManager *)manager :(NSString *)message __deprecated;

#pragma mark data in/out for Bob

-(void)mistManager:(MSTCentralManager *)manager requestOutTimeInt:(NSTimeInterval)interval;
-(void)mistManager:(MSTCentralManager *)manager requestInTimeInts:(NSArray *)timeInts;
-(void)mistManager:(MSTCentralManager *)manager requestInTimeIntsHistoric:(NSDictionary *)timeIntsHistoric;
-(void)mistManager:(MSTCentralManager *)manager overallOutstandingRequestsCount:(long) unansweredRequestsCount;

/**
 * Returns the number of timeout requests
 */
-(void)mistManager:(MSTCentralManager *)manager timedOutRequestsCount: (long) timedOutRequestCount;

#pragma mark location rx / tx
-(void) mistManager: (MSTCentralManager *)manager didUpdateTotalRequests:(long)totalRequests andTotalResponses: (long)totalResponses atDate: (NSDate *) date;

#pragma mark location RF Recording
-(void) mistManager: (MSTCentralManager *)manager onStartRFRecordingResponse:(NSString *)recordingId withIsSuccess:(BOOL)isSuccess andMessage:(NSDictionary *) message;

-(void) mistManager: (MSTCentralManager *)manager onStopRFRecordingResponse:(BOOL)isSuccess withMessage:(NSDictionary *) message;

#pragma mark
-(void) mistManager:(MSTCentralManager *)manager alert: (NSString *) message;

#pragma mark Stats
-(void)mistManager:(MSTCentralManager *)manager didUpdateLatencyStats: (double) deviceLatency andBackendRtt: (double) backendRtt;
-(void)mistManager:(MSTCentralManager*)manager didUpdateNetworkLatency: (double) networkLatency;

@end
