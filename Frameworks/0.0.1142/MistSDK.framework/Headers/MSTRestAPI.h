//
//  MSTRestAPI.h
//  MistSDK
//
//  Created by Cuong Ta on 5/20/16.
//  Copyright © 2016 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTRestAPI : NSObject

@property (nonatomic, readonly) bool isLoggedIn;

/**
 *  Get an instance of the REST API
 *
 *  @return MSTRestAPI instance
 */
+(instancetype)sharedInstance;

/**
 *  Get an instance of the REST API with a custom env
 *
 *  @param env S, P
 *
 *  @return MSTRestAPI instance
 */

-(void)setEnv:(NSString *)env;

-(void)login:(NSString *)email andPassword:(NSString *)pw onComplete:(void(^)(bool isSuccess, NSString *message))cb;

-(void)logout;

-(void)getSDKClientsForSiteId:(NSString *)siteId onComplete:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))callback;

-(void)getDeviceInfoFromAP:(NSString *)domain onComplete:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))callback;

+(NSString *)getHostENV:(NSString *)env;

@end
