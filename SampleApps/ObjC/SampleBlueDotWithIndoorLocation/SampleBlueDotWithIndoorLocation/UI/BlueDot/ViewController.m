//
//  ViewController.m
//  SampleBlueDotWithIndoorLocation
//
//  Created by Gurunarayanan Muthurakku on 24/11/23.
//

#import "ViewController.h"
#import "Constants.h"
#import "Notification.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *wakeUpSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mistSdkSwitch;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) UIView *blueDot;

@property (strong, nonatomic) MistService *mistService;
@property (strong, nonatomic) WakeupService *wakeupService;

@property CGFloat scaleX;
@property CGFloat scaleY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
 }

- (void)setup {
    _blueDot = [self createBlueDot];
    self.mistService = [[MistService alloc] initWithToken: SDK_TOKEN];
    self.mistService.delegate = self;
    self.wakeupService = [[WakeupService alloc] init];
    self.wakeupService.delegate = self;
 }

- (IBAction)enableMistSDKService:(id)sender {
    _mistSdkSwitch.isOn ? [_mistService start] : [_mistService stop];
 }

- (IBAction)enableAppWakeUpService:(id)sender {
    _wakeUpSwitch.isOn ? [_wakeupService start] : [_wakeupService stop];
 }

- (void)didUpdateLocation:(CGPoint)location {
    CGFloat scaledX = location.x * _scaleX;
    CGFloat scaledY = location.y * _scaleY;
    CGPoint relativeLocation = CGPointMake(scaledX, scaledY);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.blueDot.center = relativeLocation;
        [self updateStatusWithLocation:location];
    });
 }

- (void) didUpdateMap:(NSURL *)mapURL {
    
    [_mistService downloadImageWithURL:mapURL completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error downloading image: %@", error.localizedDescription);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupMapViewWithImage:image];
            });
        }
    }];
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
        [_mistSdkSwitch setOn:YES];
        
        [Notification scheduleLocalNotificationWithTitle:@"Mist Service Started!" subTitle:@"" body: @"Mist Location Tracking Running..."];
    }
}

- (UIView *)createBlueDot {
    if (!_blueDot) {
        _blueDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _blueDot.translatesAutoresizingMaskIntoConstraints = NO;
        _blueDot.layer.cornerRadius = 5;
        _blueDot.backgroundColor = [UIColor colorWithRed:0.072 green:0.593 blue:0.997 alpha:1.0];
    }
    return _blueDot;
}

- (void)setupMapViewWithImage:(UIImage *)image {
    UIView *floorMapView = [[UIView alloc] initWithFrame:self.view.bounds];
    floorMapView.translatesAutoresizingMaskIntoConstraints = NO;
    floorMapView.backgroundColor = UIColor.whiteColor;
    [self.mapContainer addSubview:floorMapView];

    UIImageView *floorImageView = [[UIImageView alloc] initWithImage:image];
    floorImageView.contentMode = UIViewContentModeScaleAspectFit;
    floorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [floorMapView addSubview:floorImageView];

    [floorMapView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [floorMapView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [floorMapView layoutIfNeeded];

    CGFloat floorViewRatio = self.mapContainer.bounds.size.width / self.mapContainer.bounds.size.height;
    CGFloat imageRatio = image.size.width / image.size.height;

    if (imageRatio >= floorViewRatio) {
        [floorMapView.widthAnchor constraintEqualToAnchor:self.mapContainer.widthAnchor constant:0].active = YES;
        [floorMapView.heightAnchor constraintEqualToAnchor:self.mapContainer.widthAnchor multiplier:image.size.height / image.size.width constant:0].active = YES;
    } else {
        [floorMapView.widthAnchor constraintEqualToConstant:self.mapContainer.bounds.size.height].active = YES;
        [floorMapView.heightAnchor constraintEqualToAnchor:self.mapContainer.widthAnchor multiplier:image.size.width / image.size.height constant:0].active = YES;
    }

    [floorMapView layoutIfNeeded];

    [floorMapView addSubview:self.blueDot];
    [floorMapView bringSubviewToFront:self.blueDot];

    [NSLayoutConstraint activateConstraints:@[
        [floorImageView.topAnchor constraintEqualToAnchor:floorMapView.topAnchor],
        [floorImageView.leadingAnchor constraintEqualToAnchor:floorMapView.leadingAnchor],
        [floorImageView.trailingAnchor constraintEqualToAnchor:floorMapView.trailingAnchor],
        [floorImageView.bottomAnchor constraintEqualToAnchor:floorMapView.bottomAnchor],

        [self.blueDot.widthAnchor constraintEqualToConstant:10.0],
        [self.blueDot.heightAnchor constraintEqualToConstant:10.0]
    ]];

    [self.mapContainer layoutIfNeeded];

    // Calculate the Scale Factor
    _scaleX = floorMapView.bounds.size.width / image.size.width;
    _scaleY = floorMapView.bounds.size.height / image.size.height;
}

- (void)updateStatusWithLocation:(CGPoint)location {
    CGFloat ppm = self.mistService.currentMap.ppm ?: 1;
    CGPoint clientLocation = CGPointMake(location.x / ppm, location.y / ppm);
    self.statusLabel.text = [NSString stringWithFormat:@"BlueDot Location on Map X= %.1f, Y= %.1f", clientLocation.x, clientLocation.y];
}
@end
