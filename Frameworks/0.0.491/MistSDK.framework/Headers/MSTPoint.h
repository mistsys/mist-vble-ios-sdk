//
//  MSPoint.h
//  iOS
//
//  Created by Nirmala Jayaraman on 6/22/15.
//  Copyright (c) 2015 Mist Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSTPoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) bool hasMotion;

-(id)initWithX:(double)x andY:(double)y;
-(id)initWithCGPoint:(CGPoint)point;
-(CGPoint)convertToCGPoint;

@end
