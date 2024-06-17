//
//  ViewController.m
//  SampleIndoorLocationReporting
//
//  Created by Gurunarayanan Muthurakku on 06/11/23.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController () <IndoorLocationDelegate, VirtualBeaconsDelegate, ZonesDelegate, ClientInformationDelegate, MapsListDelegate>
@property (nonatomic, weak) IndoorLocationManager *mistManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMistIndoorLocation];
    [self startMistIndoorLocationService];
}

- (void) setupMistIndoorLocation {
    self.mistManager = [IndoorLocationManager sharedInstance: SDK_TOKEN];
    self.mistManager.virtualBeaconsDelegate = self;
    self.mistManager.zonesDelegate = self;
    self.mistManager.mapsListDelegate = self;
    self.mistManager.clientInformationDelegate = self;
}

/// Start mist indoor location service
- (void) startMistIndoorLocationService {
    [self.mistManager startWithIndoorLocationDelegate:self];
}

/// Stop mist indoor location service
- (void) stopMistIndoorLocationService {
    [self.mistManager stop];
}

//MARK: IndoorLocationDelegate

/// Gets called when any error occurs
// Old SDK  <= 2.0.8
//- (void)didErrorOccurWithErrorType:(ErrorType)errorType andMessage:(NSString *)errorMessage {
//    NSLog(@">>> didErrorOccur errorType = %ld errorMessage = %@", (long)errorType, errorMessage);
//}
// New SDK >= 3.0.0
- (void)didErrorOccurWithType:(NSError*)errorType andMessage:(NSString*)errorMessage {
    NSLog(@">>> didErrorOccur errorType = %@ errorMessage = %@", errorType, errorMessage.description);
}

/// Gets called when SDK is registered
- (void)didReceivedOrgInfoWithTokenName:(NSString *)tokenName andOrgID:(NSString *)orgID {
    NSLog(@">>> didReceivedOrgInfo tokenName = %@ orgID = %@", tokenName, orgID);
}

/// It fetchs the Map of the floor based on the current location.
- (void)didUpdateMap:(MistMap *)map {
    NSLog(@">>> didUpdate MistMap.name = %@", map.name);
}

/// To provide relativeLocation, gives detailed information of current location.
- (void)didUpdateRelativeLocation:(MistPoint *)relativeLocation {
    NSLog(@">>> didUpdateRelativeLocation MistPoint = x=%f y=%f", relativeLocation.x, relativeLocation.y);
}


//MARK: VirtualBeaconDelegate

/// It Gives current ranging beacon near by us.
- (void)didRangeVirtualBeacon:(MistVirtualBeacon *)mistVirtualBeacon {
    NSLog(@">>> didRangeVirtualBeacon MistVirtualBeacon.name = %@", mistVirtualBeacon.name);
}

/// It will return all the available virtual beacons placed on the floorplan
- (void)didUpdateVirtualBeaconList:(NSArray<MistVirtualBeacon *> *)mistVirtualBeacons {
    NSLog(@">>> didUpdateVirtualBeaconList mistVirtualBeacons = %lu", (unsigned long)mistVirtualBeacons.count);
}

//MARK: ZoneDelegate

/// Triggered when user Entered into defined Zone Region
- (void)didEnter:(MistZone *)mistZone {
    NSLog(@">>> didEnter MistZone name = %@ ID = %@", mistZone.name, mistZone.zoneId);
}

/// Triggered when user Exits Zone Region
- (void)didExitZone:(MistZone *)mistZone {
    NSLog(@">>> didExitZone MistZone name = %@ ID = %@", mistZone.name, mistZone.zoneId);
}

//MARK: MapListDelegate

/// Gets all the available Maps
- (void)didReceiveAllMaps:(NSArray<MistMap *> *)maps {
    NSLog(@">>> didReceiveAllMaps maps = %lu", (unsigned long)maps.count);
}

//MARK: ClientInformationDelegate

/// Gives the Error Information
- (void)onError:(NSError*)errorType andMessage:(NSString *)errorMessage {
    NSLog(@">>> ClientInformationDelegate errorMessage = %@", errorMessage);
}

/// Gets the Client name which is active on the floorplan
- (void)onSuccess:(NSString *)clientName {
    NSLog(@">>> ClientInformationDelegate onSuccess name = %@", clientName);
}


@end
