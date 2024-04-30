//
//  WakeupService.h
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
//

@import Foundation;
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

@protocol WakeUpServiceDelegate <NSObject>

- (void)didEnterRegion:(NSString *)region;
- (void)didExitRegion:(NSString *)region;

@end

@interface WakeupService : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id <WakeUpServiceDelegate> delegate;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, assign) BOOL isWakeUpRunning;
@property (nonatomic, assign, readonly) BOOL isWakeUpEnabled;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
