//
//  MistService.h
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
//

@import Foundation;
@import MistSDK;

typedef void (^ImageDownloadCompletion)(UIImage * _Nullable image, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN
@protocol MistServiceDelegate <NSObject>

- (void)didUpdateMap:(NSURL *)mapURL;
- (void)didUpdateLocation:(CGPoint)location;

@end

@interface MistService: NSObject<IndoorLocationDelegate>
@property (nonatomic, weak) id <MistServiceDelegate> delegate;
@property (nonatomic, strong) MistMap *currentMap;
@property (nonatomic, assign) Boolean isMistRunning;

- (instancetype)initWithToken:(NSString *)token;
- (void)start;
- (void)stop;
- (void)downloadImageWithURL:(NSURL *)url completion:(ImageDownloadCompletion)completion;

@end



NS_ASSUME_NONNULL_END
