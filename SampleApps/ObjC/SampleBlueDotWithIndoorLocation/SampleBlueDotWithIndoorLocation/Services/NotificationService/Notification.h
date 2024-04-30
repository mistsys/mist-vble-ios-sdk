//
//  Notification.h
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 26/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notification : NSObject
+ (void)scheduleLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body;
@end

NS_ASSUME_NONNULL_END
