//
//  ViewController.m
//  SampleAppWakeUp
//
//  Created by Akhil Rana on 24/11/23.
//

#import "ViewController.h"
#import "Constants.h"
#import "Notification.h"
#import "MistService.h"
#import "WakeupService.h"

@interface ViewController () <MistServiceDelegate, WakeUpServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *wakeUpButton;

@property (strong, nonatomic) MistService *mistService;
@property (strong, nonatomic) WakeupService *wakeupService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
 }

- (void)setup {
    self.mistService = [[MistService alloc] initWithToken: SDK_TOKEN];
    self.mistService.delegate = self;
    self.wakeupService = [[WakeupService alloc] init];
    self.wakeupService.delegate = self;
    _statusLabel.text = notMonitoringMessage;
}

- (IBAction)toggleWakeUpStatus:(id)sender {
    if (_wakeupService.isWakeUpRunning) {
        [_wakeUpButton setTitle:@"Start WakeUp Service" forState: UIControlStateNormal];
        _statusLabel.text = notMonitoringMessage;
        [_wakeupService stop];
    } else {
        [_wakeUpButton setTitle:@"Stop WakeUp Service" forState: UIControlStateNormal];
        _statusLabel.text = monitoringMessage;
        [_wakeupService start];
    }
    _wakeupService.isWakeUpRunning = !_wakeupService.isWakeUpRunning;
}

- (void) didEnterRegion:(NSString *)region {
    [self startMistServiceWithNotification:region];
}

- (void) didExitRegion:(NSString *)region {
    [Notification scheduleLocalNotificationWithTitle:@"Thankyou!!!" subTitle:region body:@"Welcome again!"];
 }

- (void) startMistServiceWithNotification: (NSString *)region {
    NSLog(@">>> didEnterRegion Beacon = %@", region);
    
    [Notification scheduleLocalNotificationWithTitle:@"Hello!!!" subTitle:region body:@"Welcome!! You have entered the Beacon range"];
    
    if (_mistService.isMistRunning == NO) {
        // Start Mist SDK
        [_mistService start];
        
        [Notification scheduleLocalNotificationWithTitle:@"Mist Service Started!" subTitle:@"" body: @"Mist Location Tracking Running..."];
    }
}

@end
