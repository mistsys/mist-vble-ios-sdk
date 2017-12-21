//
//  MistQRCodeScanner.h
//  MistSDK
//
//  Created by Nirmala Jayaraman on 1/29/16.
//  Copyright © 2016 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSTOrgCredentialsManagerDelegate;

/**
 *  A helper method to retrieve the org credential
 */
static NSString *orgId;

@interface MSTOrgCredentialsManager : NSObject

@property (nonatomic, weak) id<MSTOrgCredentialsManagerDelegate> delegate;

- (void) getTokenInformationForInvite: (NSString *) invite; // deprecate

/**
 *  This method will enroll the device using the invite code provided, and returns the token and secret in the callback.
 *
 *  @param sdkToken the hash key that begins with D,S or P.
 *  @param callback  the callback with the response
 */
+(void)enrollDeviceWithToken:(NSString *)sdkToken onComplete:(void(^)(NSDictionary *response, NSError *error))callback;

/**
 *  This method will enroll the device using the invite code provided, and returns the token and secret in the callback.
 *
 *  @param tokenLink the decoded QR code or very link
 *  @param callback  the callback with the response
 */
+(void)enrollDeviceWithLink:(NSString *)tokenLink onComplete:(void(^)(NSDictionary *response, NSError *error))callback;

/**
 * This method will get the organization ID for the invite code provided
 */

+(NSString *)getOrgId;

@end

@protocol MSTOrgCredentialsManagerDelegate <NSObject>

@required
- (void)manager: (MSTOrgCredentialsManager *) manager didReceiveSecretInformation: (NSDictionary *) secretInformation;

@end
