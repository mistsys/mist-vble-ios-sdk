//
//  MistService.h
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
//

@import Foundation;
@import UIKit;

@class MistMap;
@protocol MistServiceDelegate;

typedef void (^ImageDownloadCompletion)(UIImage * _Nullable image, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN
@protocol MistServiceDelegate <NSObject>

- (void)didUpdateMap:(NSURL *)mapURL;
- (void)didUpdateLocation:(CGPoint)location;
- (void)didFailWithError:(NSString *)error;

@end

@interface MistService : NSObject

@property (nonatomic, assign) id<MistServiceDelegate> delegate;
@property (nonatomic, assign) BOOL isMistSDKStarted;
@property (nonatomic, strong, readonly, nullable) MistMap *currentMap;

- (instancetype)initWithToken:(NSString *)token orgId:(NSString *)orgId;
- (void)start;
- (void)stop;
- (void)downloadImageWithURL:(NSURL *)url completion:(ImageDownloadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
