//
//  Notification.m
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 26/11/23.
//

#import "Notification.h"
@import UIKit;
@import UserNotifications;

@implementation Notification

+ (void)scheduleLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body {
    // Request permission to show notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // Permission granted, create and schedule the notification
            [self createAndScheduleNotificationWithTitle:title subTitle:subTitle body:body];
        } else {
            // Handle the case where the user denied permission
            NSLog(@"Permission denied for notifications");
        }
    }];
}

+ (void)createAndScheduleNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body {
    // Create notification content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];

    // Set up trigger for 10 seconds from now
    NSTimeInterval timeInterval = 1;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];

    // Create notification request
    NSString *identifier = [[NSUUID UUID] UUIDString];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];

    // Add the request to the notification center
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error scheduling notification: %@", error.localizedDescription);
        } else {
            NSLog(@"Notification scheduled successfully!");
        }
    }];
}

@end
