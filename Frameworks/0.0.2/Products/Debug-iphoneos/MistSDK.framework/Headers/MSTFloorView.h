//
//  MSTFloorView.h
//  MistSDK
//
//  Created by Cuong Ta on 7/7/15.
//  Copyright (c) 2015 Mist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTMap.h"
#import "MSTPoint.h"
#import "MSTLocationView.h"

@protocol MSTFloorViewDelegate;

@interface MSTFloorView : UIView

@property (nonatomic) bool showLabel;
@property (nonatomic) unsigned int maxBreadcrumb;
@property (nonatomic) double ppm;
@property (nonatomic) double scaleX;
@property (nonatomic) double scaleY;
@property (nonatomic, strong) UIImageView *floorImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *breadcrumbs;
@property (nonatomic) id <MSTFloorViewDelegate> delegate;
@property (nonatomic, strong) MSTMap *map;

-(id)initWithFrame:(CGRect)frame;

-(void)start;

-(void)drawHeading:(CLHeading *)headingInfo forIndex:(NSUInteger)index;
    
-(void)drawDotViewAtPoint:(MSTPoint *)point forIndex:(NSUInteger)index;

+(double)scalePointFromOriginToMetersWithPoint:(double)point andScale:(double)scale andOrigin:(double)origin andFlipped:(bool)flipped;
-(CGPoint)getFloorviewPointFromPoint:(CGPoint)point;

@end

@protocol MSTFloorViewDelegate <NSObject>

@required
-(NSUInteger)numberOfDotsInFloorView:(MSTFloorView *)floorView;
-(MSTLocationView *)dotViewForFloorView:(MSTFloorView *)floorView forIndex:(NSUInteger)index;
-(UIColor *)colorForFloorView:(MSTFloorView *)floorView forIndex:(NSUInteger)index;
-(bool)canShowFloorView:(MSTFloorView *)floorView forIndex:(NSUInteger)index;

@end