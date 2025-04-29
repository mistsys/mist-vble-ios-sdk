//
//  MistService.h
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
//

@import Foundation;
@import UIKit;

@protocol MistServiceDelegate;
@class MistMap;

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

@end

NS_ASSUME_NONNULL_END
