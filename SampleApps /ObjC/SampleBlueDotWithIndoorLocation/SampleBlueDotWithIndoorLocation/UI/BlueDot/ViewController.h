//
//  ViewController.h
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
//

@import UIKit;
#import "MistService.h"
#import "WakeupService.h"

@interface ViewController : UIViewController<MistServiceDelegate, WakeUpServiceDelegate>

@end

