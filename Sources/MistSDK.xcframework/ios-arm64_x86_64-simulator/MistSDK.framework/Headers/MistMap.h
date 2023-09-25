//
//  MistMap.h
//  MistSDK
//
//  Created by Dinkar Kumar on 01/04/22.
//  Copyright © 2022 Mist. All rights reserved.
//


#import <Foundation/Foundation.h>

@class MistMap;
@class NodePosition;
@class LatLong;
@class MistPath;
@class PathNode;
@class Wayfinding;
@class Jibestream;
@class Micello;
@class TransformParams;


@interface MistMap : NSObject
@property (nonatomic, assign) double widthM;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) Wayfinding *wayfinding;
@property (nonatomic, strong) MistPath *wayfindingPath;
@property (nonatomic, assign) double heightM;
@property (nonatomic, assign) double ppm;
@property (nonatomic, assign) long height;
@property (nonatomic, assign) long width;
@property (nonatomic, copy)   NSArray<MistPath *> *sitesurveyPath;
@property (nonatomic, strong) MistPath *wallPath;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) long occupancyLimit;
@property (nonatomic, assign) long orientation;
@property (nonatomic, copy)   NSArray *intendedCoverageAreas;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, copy)   NSString *mapID;
@property (nonatomic, copy)   NSString *siteID;
@property (nonatomic, copy)   NSString *orgID;
@property (nonatomic, assign) long createdTime;
@property (nonatomic, assign) long modifiedTime;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *thumbnailURL;
@property (nonatomic, strong) LatLong *latLongBR;
@property (nonatomic, strong) LatLong *latLongTL;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface LatLong : NSObject
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface MistPath : NSObject
@property (nonatomic, copy) NSString *coordinate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<PathNode *> *nodes;
@property (nonatomic, copy) NSString *pathID;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface PathNode : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) NodePosition *position;
@property (nonatomic, copy)   NSDictionary<NSString *, NSString *> *edges;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end


@interface NodePosition : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface Wayfinding : NSObject
@property (nonatomic, copy)   NSString *wayfindingDefault;
@property (nonatomic, strong) Jibestream *jibestream;
@property (nonatomic, strong) Micello *micello;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface Jibestream : NSObject
@property (nonatomic, copy) NSString *venueID;
@property (nonatomic, copy) NSString *mapID;
@property (nonatomic, copy) NSString *ppm;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *endpointURL;
@property (nonatomic, copy) NSString *mmpp;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface Micello : NSObject
@property (nonatomic, copy)           NSString *accountKey;
@property (nonatomic, copy)           NSString *mapID;
@property (nonatomic, assign)         double scaleRatio;
@property (nonatomic, copy)           NSString *drawingID;
@property (nonatomic, nullable, copy) id geoID;
@property (nonatomic, copy)           NSString *defaultLevelID;
@property (nonatomic, copy)           NSString *cid;
@property (nonatomic, copy)           NSString *did;
@property (nonatomic, copy)           NSString *lid;
@property (nonatomic, copy)           NSString *imageURL;
@property (nonatomic, nullable, copy) id zoomLevel;
@property (nonatomic, nullable, copy) id enablePOI;
@property (nonatomic, strong)         TransformParams *transformParams;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

@interface TransformParams : NSObject
@property (nonatomic, assign) long lid;
@property (nonatomic, copy)   NSArray<NSNumber *> *transform;
@property (nonatomic, assign) long did;
@property (nonatomic, copy)   NSArray<NSNumber *> *mercToNat;
@property (nonatomic, assign) long cid;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
