//
//  WSHelper.h
//  MistSDK
//
//  Created by Rajesh Vishwakarma on 25/08/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSHelper : NSObject

+ (NSData *)requestWith:(NSString*)subject version:(char)version handle:(char)handle sla:(char)sla data:(id)data;
+ (NSDictionary *)parseResponseWith:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
