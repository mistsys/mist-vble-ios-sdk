//
//  MistService.m
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
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

// MARK: - IndoorLocationDelegate CallBack

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

// MARK: - Utility Method

- (void)downloadImageWithURL:(NSURL *)url completion:(ImageDownloadCompletion)completion {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: Unable to download map image with url %@", url.absoluteString);
            completion(nil, error);
            return;
        }
        
        if (!data) {
            NSLog(@"Error: Map image data is nil");
            NSError *unknownError = [NSError errorWithDomain:@"ImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Unknown image error"}];
            completion(nil, unknownError);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        completion(image, nil);
    }];
    
    [dataTask resume];
}

@end
