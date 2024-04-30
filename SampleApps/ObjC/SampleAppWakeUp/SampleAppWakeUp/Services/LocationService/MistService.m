//
//  MistService.m
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
//

#import "MistService.h"

@interface MistService ()

@property (nonatomic, weak) IndoorLocationManager *mistManager;

@end

@implementation MistService

- (instancetype)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        _mistManager = [IndoorLocationManager sharedInstance:token];
    }
    return self;
}

- (void)start {
    [self.mistManager startWithIndoorLocationDelegate: self];
    self.isMistRunning = YES;
}

- (void)stop {
    [self.mistManager stop];
    self.isMistRunning = NO;
}

- (void)didUpdateRelativeLocation:(MistPoint *)relativeLocation {
    if (!self.currentMap) {
        return;
    }
    NSLog(@">>> didUpdateRelativeLocation Original x = %f y = %f", relativeLocation.x, relativeLocation.y);
    NSLog(@">>> didUpdateRelativeLocation PPM Value = %f", self.currentMap.ppm);
    CGPoint location = CGPointMake(relativeLocation.x * self.currentMap.ppm, relativeLocation.y * self.currentMap.ppm);
    NSLog(@">>> didUpdateRelativeLocation with PPM x = %f y = %f", location.x, location.y);
    [self.delegate didUpdateLocation:location];
}

- (void)didUpdateMap:(MistMap *)map {
    self.currentMap = map;
    NSString *mapPath = map.url;
    NSURL *mapURL = [NSURL URLWithString:mapPath];
    if (!mapURL) {
        return;
    }
    [self.delegate didUpdateMap:mapURL];
    NSLog(@">>> didUpdate MistMap mapName=%@", map.name.description);
}


//  Old SDK  <= 2.0.8
//- (void)didErrorOccurWithErrorType:(ErrorType)errorType andMessage:(NSString *)errorMessage {
//    NSLog(@">>> didErrorOccur errorType = %ld errorMessage = %@", (long)errorType, errorMessage.description);
//}

// New SDK >= 3.0.0
- (void)didErrorOccurWithType:(NSError*)errorType andMessage:(NSString*)errorMessage {
    NSLog(@">>> didErrorOccur errorType = %@ errorMessage = %@", errorType, errorMessage.description);
}

@end

