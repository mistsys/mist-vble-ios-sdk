//
//  Node.h
//  MistSDK
//
//  Created by edelacruz on 2/16/22.
//  Copyright © 2022 Mist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"

@interface Node : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Position *position;

@end

