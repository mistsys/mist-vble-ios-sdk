//
//  MistQRCodeScanner.h
//  MistSDK
//
//  Created by Nirmala Jayaraman on 1/29/16.
//  Copyright © 2016 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSTOrgCredentialsManagerDelegate;

@interface MSTOrgCredentialsManager : NSObject

@property (nonatomic, weak) id<MSTOrgCredentialsManagerDelegate> delegate;

- (void) getTokenInformationForInvite: (NSString *) invite;

/*!
 *
 * @discussion This method will enroll the device using the invite code provided, and returns the token and secret in the callback.
 * @param sdkInviteLink - The unwrapped invite link
 */
-(void)enrollDeviceForSDKToken:(NSString *)sdkInviteLink onComplete:(void(^)(NSDictionary *response, NSError *error))callback;

@end

@protocol MSTOrgCredentialsManagerDelegate <NSObject>

@required
- (void)manager: (MSTOrgCredentialsManager *) manager didReceiveSecretInformation: (NSDictionary *) secretInformation;

@end
