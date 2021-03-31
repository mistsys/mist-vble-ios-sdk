//
//  MistIDGenerator.h
//  MistLocation
//
//  Created by Nirmala Jayaraman on 1/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

/*
MistIDGenerator is used to generate, and persist Mist SDK ID, get the Advertising ID and the Wifi IP address (if connected to Wifi.

Methods:
 Get Mist SDK ID in UUID format
 */

#import <Foundation/Foundation.h>

@interface MistIDGenerator : NSObject

/*!
 *
 * @discussion Returns the Mist UUID
 * @return NSUUID - Mist UUID
 */
+(NSUUID *)getMistUUID;

/*!
 *
 * Clears the Mist UUID
 */
+(void)clearMistUUID;

@end
