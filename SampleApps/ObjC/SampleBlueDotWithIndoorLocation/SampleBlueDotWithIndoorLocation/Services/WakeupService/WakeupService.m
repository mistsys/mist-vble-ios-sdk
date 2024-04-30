//
//  WakeupService.m
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
//

#import "WakeupService.h"
#import "Constants.h"

@interface WakeupService ()
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation WakeupService

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpLocationManager];
    }
    return self;
}

- (BOOL)isWakeUpEnabled {
    return _locationManager.monitoredRegions.count > 0;
}

- (void)setUpLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    _orgId = ORG_ID;
}

- (void)startMonitoringBeaconRegion {
    NSUUID *orgUUID = [[NSUUID alloc] initWithUUIDString:_orgId];
    if (!orgUUID) {
        NSLog(@">> Please enter a valid org_id");
        return;
    }
    
    NSMutableArray *beaconUUIDs = [NSMutableArray array];
    
    // Org Beacon
    [beaconUUIDs addObject:[orgUUID UUIDString]];
    
    // Org Cyclical Beacon
    NSString *shortUUID =  [self shortOrgUUIDString: [orgUUID UUIDString]];
    NSArray *beaconHexValues = @[@"a", @"b", @"c", @"d", @"e", @"f"];
    NSInteger numOfCyclicalBeacons = 16;
    
    for (NSInteger i = 0; i < numOfCyclicalBeacons; i++) {
        NSString *beaconUUID;
        if (i < 10) {
            beaconUUID = [NSString stringWithFormat:@"%@%ld", shortUUID, (long)i];
        } else if (i < 16) {
            beaconUUID = [NSString stringWithFormat:@"%@%@", shortUUID, beaconHexValues[i - 10]];
        } else {
            beaconUUID = [NSString stringWithFormat:@"%@%ld", shortUUID, (long)(i - 6)];
        }
        [beaconUUIDs addObject:beaconUUID];
    }
    
    for (NSInteger index = 0; index < beaconUUIDs.count; index++) {
        NSString *beaconUUIDString = beaconUUIDs[index];
        NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:beaconUUIDString];
        if (!beaconUUID) {
            return;
        }
        NSString *beaconName = [NSString stringWithFormat:@"Juniper_Mist_AP_Beacon_%ld", (long)index];
        CLBeaconRegion *beaconRegion = [self createBeaconRegionWithName:beaconName uuid:beaconUUID];
        [self.locationManager startMonitoringForRegion:beaconRegion];
        
        NSLog(@">> Start Monitoring Beacon = %@, proximityUUID = %@, major = %@ minor = %@", beaconRegion.identifier, beaconRegion.UUID.UUIDString, beaconRegion.major, beaconRegion.minor);
    }
    
}

- (void)stopMonitoringBeaconRegion {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
            [self.locationManager stopMonitoringForRegion:beaconRegion];
                        
            NSLog(@">> Stop Monitoring Beacon = %@, proximityUUID = %@, major = %@ minor = %@", beaconRegion.identifier, beaconRegion.UUID.UUIDString, beaconRegion.major, beaconRegion.minor);
        }
    }
}

- (CLBeaconRegion *)createBeaconRegionWithName:(NSString *)name uuid:(NSUUID *)uuid {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithUUID:uuid identifier:name];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    return beaconRegion;
}

- (void)start {
    [self startMonitoringBeaconRegion];
}

- (void)stop {
    [self stopMonitoringBeaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.delegate didEnterRegion:region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.delegate didExitRegion:region.identifier];
}

- (CLBeaconRegion *)createWithBeaconName:(NSString *)name uuid:(NSUUID *)uuid {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithUUID:uuid identifier:name];
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    beaconRegion.notifyEntryStateOnDisplay = YES;
    return beaconRegion;
}

- (NSString *)shortOrgUUIDString:(NSString *)originalString {
    NSString *shortOrgId = [originalString substringToIndex:[originalString length] - 2];
    NSString *orgUUIDString = [NSString stringWithFormat:@"%@%@", shortOrgId, @"0"];
    return orgUUIDString;
}

@end
