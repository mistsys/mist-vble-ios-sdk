//
//  MistEnum.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/23/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTEnum : NSObject

/**
 *  MapType
 */
typedef NS_ENUM(NSInteger, MapType) {
    /**
     *  MapTypeGOOGLE
     */
    MapTypeGOOGLE,
    /**
     *  MapTypeIMAGE
     */
    MapTypeIMAGE,
};

/**
 *  SourceType
 */
typedef NS_ENUM(NSInteger, SourceType) {
    /**
     *  SourceTypeMIST
     */
    SourceTypeMIST,
    /**
     *  SourceTypeOS
     */
    SourceTypeOS,
    
    /**
     * SourceTypeMistDR
     */
    SourceTypeMistDR,
    
    /**
     * SourceTypeMistLastKnown
     */
    SourceTypeMistLastKnown,
    
    /**
     * SourceTypeMistLaggy
     */
    SourceTypeMISTLaggy,
    
    /**
     * SourceTypeMistUnknownLag
     */
    SourceTypeMISTUnknownLag,
};

/**
 *  AuthorizationType
 */
typedef NS_ENUM(NSInteger, AuthorizationType) {
    /**
     *  AuthorizationTypeALWAYS
     */
    AuthorizationTypeALWAYS,
    /**
     *  AuthorizationTypeUSE
     */
    AuthorizationTypeUSE,
};

/**
 *  ErrorType
 */
typedef NS_ENUM(NSInteger, ErrorType) {
    /**
     *  ErrorTypeNoResponse
     */
    ErrorTypeNoResponse,
    /**
     *  ErrorTypeResponseParseError
     */
    ErrorTypeResponseParseError,
    /**
     *  ErrorTypeNoBeaconsDetected
     */
    ErrorTypeNoBeaconsDetected,
    /**
     *  ErrorTypeNoConnectionToCloud
     */
    ErrorTypeNoConnectionToCloud,
    /**
     *  ErrorTypeNoDataConnection
     */
    ErrorTypeNoDataConnection,
};

/**
 *  MSTCentralManagerStatusCode - This helps the host app to understand and provide hooks in the application.
 */
typedef NS_ENUM(NSUInteger,MSTCentralManagerStatusCode) {
    /**
     *  MSTCentralManagerStatusCodeConnecting - Connection is connecting.
     */
    MSTCentralManagerStatusCodeConnecting,
    /**
     *  MSTCentralManagerStatusCodeReconnecting - Connection is reconnecting.
     */
    MSTCentralManagerStatusCodeReconnecting,
    /**
     *  MSTCentralManagerStatusCodeConnected - Connection is established.
     */
    MSTCentralManagerStatusCodeConnected,
    /**
     *  MSTCentralManagerStatusCodeDownloadingMetaData - Indicates that CM is downloading maps, virtual beacons and any meta data in order to render the map, location.
     */
    MSTCentralManagerStatusCodeDownloadingMetaData,
    /**
     *  MSTCentralManagerStatusCodeUnreachable - Network is not accessible.
     */
    MSTCentralManagerStatusCodeUnreachable,
    /**
     *  MSTCentralManagerStatusCodeDisconnected - Network is disconnected.
     */
    MSTCentralManagerStatusCodeDisconnected,
    /**
     *  MSTCentralManagerStatusCodeSentUrgentMsgToApp - Reserving a message code to send to the app for urgent matters
     */
    MSTCentralManagerStatusCodeSentUrgentMsgToApp,
    /**
     *  MSTCentralManagerStatusCodeSentJSON - CM has sent location information and is expecting location.
     */
    MSTCentralManagerStatusCodeSentJSON,
    /**
     *  MSTCentralManagerStatusCodeReceivedLE - CM has received location data.
     */
    MSTCentralManagerStatusCodeReceivedLE,
    /**
     *  MSTCentralManagerStatusCodeUploadingMetaData - Indicates that CM is uploading the meta data.
     */
    MSTCentralManagerStatusCodeUploadingMetaData
};

/**
 *  MSTCentralManagerHardwareType
 */
typedef NS_ENUM(NSUInteger, MSTCentralManagerSettingType) {
    /**
     *  MSTCentralManagerHardwareTypeLocation -
     */
    MSTCentralManagerSettingTypeLocation,
    /**
     *  MSTCentralManagerHardwareTypeBluetooth -
     */
    MSTCentralManagerSettingTypeBluetooth
};

typedef NS_ENUM(NSUInteger, MSTCentralManagerSettingStatus) {
    /**
     *  MSTCentralManagerSettingStatusUnknown
     */
    MSTCentralManagerSettingStatusUnknown,
    /**
     *  MSTCentralManagerSettingStatusOn -
     */
    MSTCentralManagerSettingStatusOn,
    /**
     *  MSTCentralManagerSettingStatusOff -
     */
    MSTCentralManagerSettingStatusOff
};

typedef NS_ENUM(NSUInteger, MSTRemoteLoggingLogLevel) {
    /**
     * Verbose logging. Everything will be logged
     */
    VERBOSE,
    /**
     * Debug logging. Debug information, warnings, errors will be logged
     */
    DEBUGGING,
    /**
     * Warn logging. Warnings and Errors will be logged. This is the default
     */
    WARNING,
    /**
     * Error logging. Only Errors will be logged
     */
    ERROR,
    /**
     * Logging is off. Not recommended
     */
    OFF
};

@end
