//
//  MSTLocationView.h
//  MistSDK
//
//  Created by Cuong Ta on 8/6/15.
//  Copyright (c) 2015 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSTLocationView : UIView

@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *headingView;

-(void)start;
-(void)stop;

-(void)showMotion:(bool)show;

@end
