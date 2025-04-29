//
//  MistService.m
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
//

@import Foundation;
@import MistSDK;
#import "MistService.h"
#import "SampleBlueDotWithIndoorLocation-Swift.h"

@interface MistService () <MistSDKManagerDelegate>
@property (nonatomic, strong, readwrite, nullable) MistMap *currentMap;
@property (nonatomic, strong) MistSDKManager *sdkManager;
@end

@implementation MistService

- (instancetype)initWithToken:(NSString *)token orgId:(NSString *)orgId {
    self = [super init];
    if (self) {
        _sdkManager = [[MistSDKManager alloc] initWithToken:token orgId:orgId];
        _sdkManager.delegate = self;
    }
    return self;
}

- (void)start {
    [self.sdkManager start];
    self.isMistSDKStarted = YES;
}

- (void)stop {
    [self.sdkManager stop];
    self.isMistSDKStarted = NO;
}

- (void)downloadImageWithURL:(NSURL *)url completion:(ImageDownloadCompletion)completion {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }

        if (!data) {
            NSError *unknownError = [NSError errorWithDomain:@"ImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Unknown image error"}];
            completion(nil, unknownError);
            return;
        }

        UIImage *image = [UIImage imageWithData:data];
        completion(image, nil);
    }];

    [dataTask resume];
}

// MARK: - MistSDKManagerDelegate

- (void)didUpdateMap:(MistMap *)map {
    self.currentMap = map;
    NSURL *url = [NSURL URLWithString:map.url];
    [self.delegate didUpdateMap:url];
}

- (void)didUpdateLocation:(CGPoint)location {
    if (self.currentMap) {
        CGFloat scaledX = location.x / self.currentMap.ppm;
        CGFloat scaledY = location.y / self.currentMap.ppm;
        CGPoint clientLocation = CGPointMake(scaledX, scaledY);
        [self.delegate didUpdateLocation:clientLocation];
    }
}

- (void)didFailWithError:(NSString *)error {
    [self.delegate didFailWithError:error];
}

@end
