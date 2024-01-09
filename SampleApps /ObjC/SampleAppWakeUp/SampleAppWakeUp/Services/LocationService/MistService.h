//
//  MistService.h
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
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

@end


NS_ASSUME_NONNULL_END

