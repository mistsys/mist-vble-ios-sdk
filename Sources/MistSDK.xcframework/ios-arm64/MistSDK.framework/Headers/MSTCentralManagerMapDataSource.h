//
//  MSTCentralManagerMapDataSource.h
//  MistSDK
//
//  Created by Cuong Ta on 12/12/17.
//  Copyright © 2017 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Defines the map downloading scheme
 * MSTCentralManagerMapDataSourceOptionDownload - Use this option if the app wants the SDK to download the most updated map image from Mist.
 * MSTCentralManagerMapDataSourceOptionDoNotDownload - Use this option if the app will provide a map image and does not want the SDK to download at all.
 */
typedef NS_ENUM(NSUInteger, MSTCentralManagerMapDataSourceOption) {
    MSTCentralManagerMapDataSourceOptionDownload,
    MSTCentralManagerMapDataSourceOptionDoNotDownload
};

@class MSTCentralManager;

@protocol MSTCentralManagerMapDataSource <NSObject>

-(MSTCentralManagerMapDataSourceOption)shouldDownloadMap:(nonnull MSTCentralManager *)manager;

-(nullable UIImage *)mapForMapId:(nonnull NSString *)mapId;

@optional

-(void)mistCentralManager:(nonnull MSTCentralManager *)mistManager downloadMapWithInfo:(nonnull NSString *)info;

@end
