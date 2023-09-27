//
//  IndoorLocationManager.h
//  MistSDK
//
//  Created by edelacruz on 11/4/21.
//  Copyright © 2021 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MistMap.h"
#import "Position.h"
#import "Node.h"
#import "MSTEnum.h"
#import "MistPoint.h"
#import "MistVirtualBeacon.h"
#import "MistZone.h"

@class MistMap;
@class MistPoint;
@class MistVirtualBeacon;
@class MistZone;
@protocol IndoorLocationDelegate;
@protocol VirtualBeaconsDelegate;
@protocol ZonesDelegate;
@protocol MapsListDelegate;
@protocol ClientInformationDelegate;

@interface IndoorLocationManager : NSObject

@property (nonatomic, weak) id<IndoorLocationDelegate> indoorLocationDelegate;
@property (nonatomic, weak) id<VirtualBeaconsDelegate> virtualBeaconsDelegate;
@property (nonatomic, weak) id<ZonesDelegate> zonesDelegate;
@property (nonatomic, weak) id<MapsListDelegate> mapsListDelegate;
@property (nonatomic, weak) id<ClientInformationDelegate> clientInformationDelegate;

@property (nonatomic, strong) NSString *sdkToken;


#pragma mark - INITIALIZATION
//Shared Instance to share amongst all the classes
//Shared Instance helps avoid the case of multiple instances as used by multiple classes
+ (instancetype)sharedInstance:(NSString*)token;

#pragma mark - Start / Stop
//Need to pass required delegate since it is minimum for SDK to run
- (void) startWithIndoorLocationDelegate: (id <IndoorLocationDelegate>) delegate;
- (void) stop;

/**
 * Wayfinding
 */
#pragma mark - Wayfinding
-(NSArray<Node*>*) getWayfindingPathTo:(Position*) destination;

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

-(void)saveClientInformation:(NSString *)clientName withDelegate:(id<ClientInformationDelegate>)clientInformationDelegate;

-(void)getClientInformationwithDelegate:(id<ClientInformationDelegate>)clientInformationDelegate;

@end

#pragma mark - Delegates

@protocol IndoorLocationDelegate <NSObject>
@required
/*
* Switched to a different map callback
* @param map        Returns the current map.
*/
- (void) didUpdateMap:(MistMap*)map;

/*
* Update for the current location MSTPoint on a specific MSTMap callback
* @param relativeLocation  Returns the current location.
* @param map Returns the current map.
*/
- (void) didUpdateRelativeLocation:(MistPoint*)relativeLocation;

@optional
/*
* An Error occured
* @param errorType  Error type .
* @param errorMessage Error message.
*/
- (void) didErrorOccurWithType:(ErrorType)errorType andMessage:(NSString*) errorMessage;
/*
* Successful registration of Organization using the secret key
* @param tokenName  Token name provided.
* @param orgID Org ID of the organization registered.
*/
- (void) didReceivedOrgInfoWithTokenName:(NSString*) tokenName andOrgID:(NSString*) orgID;

@end

@protocol VirtualBeaconsDelegate <NSObject>
@required
- (void) didRangeVirtualBeacon:(MistVirtualBeacon*) mistVirtualBeacon;

@optional
- (void) didUpdateVirtualBeaconList:(NSArray<MistVirtualBeacon*>*) mistVirtualBeacons;

@end

@protocol ZonesDelegate <NSObject>
@optional
- (void) didEnterZone:(MistZone*) mistZone;
- (void) didExitZone:(MistZone*) mistZone;
@end

@protocol MapsListDelegate <NSObject>

@required
/*
* Recieved a list of all maps for all sites / entire org.
* @param maps   Returns the the maps for all sites / entire org.
*/
- (void) didReceiveAllMaps:(NSArray<MistMap*>*) maps;
@optional

@end
@protocol ClientInformationDelegate <NSObject>
@required
- (void) onSuccess:(NSString*) clientName;
- (void) onError:(ErrorType )errorType andMessage:(NSString*) errorMessage;
@end
