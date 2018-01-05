//
//  MSTProximity.h
//  MistSDK
//
//  Created by Cuong Ta on 2/1/16.
//  Copyright © 2016 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kMSTProximityUnknown;
extern NSString *const kMSTProximityImmediate;
extern NSString *const kMSTProximityNear;
extern NSString *const kMSTProximityFar;
extern NSString *const kMSTProximityRemote;

@protocol MSTProximityDelegate;

/*!
 *
 * @discussion The MSTProximity object that calculates the proximity of the current location to the provided beacons.
 * Usages:
 *
 * Independent: By providing the list of virtual beacons, you can range for the beacons by calling startProximityWithLocation.
 * via Mist SDK: By calling MSTCentralManager's startVirtualBeaconProximity and by becoming a delegate of MSTProximityDelegate.
 */
@interface MSTProximity : NSObject

@property (nonatomic, readonly) NSArray *beacons;
@property (nonatomic, weak) id <MSTProximityDelegate> delegate;

/*!
 *
 * @discussion Initialize the MSTProximity object with beacons to be used for proximity
 * @param beacons - the beacons to test its proximity
 * @return MSTProximity
 */
-(id)initWithBeacons:(NSArray *)beacons;

/*!
 *
 * @discussion Start the proximity calculation. Calls this function whenever the location changes.
 * @param currentLocation the current location.
 */
-(void)startProximityWithLocation:(CGPoint)currentLocation;

@end

/*!
 * MSTProximityDelegate
 * @discussion Start the proximity calculation. Calls this function whenever the location changes.
 */
@protocol MSTProximityDelegate <NSObject>

/*!
 *
 * @discussion Notifies the delegate that the list of beacons have been updated.
 * @param beacons - List of new beacons
 */
-(void)didUpdatedBeacons:(NSArray *)beacons;

/*!
 *
 * @discussion Returns individual the beacons proximity information based on the current location
 * @param proximityInformation - Proximity Information
 * @param currentLocation - Current location.
 */
-(void)didDiscoverBeaconProximityInformation:(NSDictionary *)proximityInformation forLocation:(CGPoint)currentLocation;

/*!
 *
 * @discussion Returns all the beacons proximity information based on the current location
 * @param proximityInformations - Proximity Information of each known beacon
 * @param currentLocation - Current location.
 */
-(void)didDiscoverBeaconsProximityInformation:(NSArray *)proximityInformations forLocation:(CGPoint)currentLocation;

@end
