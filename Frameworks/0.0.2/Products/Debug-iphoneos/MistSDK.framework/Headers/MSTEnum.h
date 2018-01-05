//
//  MistEnum.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTEnum : NSObject

typedef NS_ENUM(NSInteger, MapType) {
    MapTypeGOOGLE,
    MapTypeIMAGE,
};


typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeMIST,
    SourceTypeOS,
};

typedef NS_ENUM(NSInteger, AuthorizationType) {
    AuthorizationTypeALWAYS,
    AuthorizationTypeUSE,
};

typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeNoResponse,
    ErrorTypeResponseParseError,
    ErrorTypeNoBeaconsDetected,
    ErrorTypeNoConnectionToCloud,
    ErrorTypeNoDataConnection,
};

@end
