//
//  ViewController.m
//  SampleIndoorLocationReporting
//
//  Created by Gurunarayanan Muthurakku on 06/11/23.
//

#import "ViewController.h"
#import "Constants.h"
#import "SampleIndoorLocationReporting-Swift.h"

@interface ViewController () <MistSDKManagerDelegate>
@property (nonatomic, strong) MistSDKManager *mistManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMistIndoorLocation];
    [self startMistIndoorLocationService];
}

- (void)setupMistIndoorLocation {
    self.mistManager = [[MistSDKManager alloc] initWithToken:SDK_TOKEN orgId:ORG_ID];
    self.mistManager.delegate = self;
}

- (void)startMistIndoorLocationService {
    [self.mistManager start];
}

- (void)stopMistIndoorLocationService {
    [self.mistManager stop];
}

- (void)didUpdateMap:(NSURL *)mapURL {
    NSLog(@">>> didUpdateMap: %@", mapURL.absoluteString);
}

- (void)didUpdateLocation:(CGPoint)location {
    NSLog(@">>> didUpdateLocation: x = %f, y = %f", location.x, location.y);
}

- (void)didFailWithError:(NSString *)error {
    NSLog(@">>> didFailWithError: %@", error);
}

- (void)didUpdateVirtualBeaconList:(NSArray<NSString *> *)beacons {
    NSLog(@">>> didUpdateVirtualBeaconList: %@", beacons);
}

- (void)didEnterZone:(NSString *)zoneName {
    NSLog(@">>> didEnterZone: %@", zoneName);
}

- (void)didExitZone:(NSString *)zoneName {
    NSLog(@">>> didExitZone: %@", zoneName);
}

- (void)didRangeVirtualBeacon:(NSString *)beaconName {
    NSLog(@">>> didRangeVirtualBeacon: %@", beaconName);
}

- (void)didReceiveClientInfo:(NSString *)clientName {
    NSLog(@">>> didReceiveClientInfo: %@", clientName);
}

@end
