//
//  ViewController.m
//  SampleBlueDotWithIndoorLocation
//
//  Created by Akhil Rana on 24/11/23.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (strong, nonatomic) UIView *blueDot;

@property (strong, nonatomic) MistService *mistService;

@property CGFloat scaleX;
@property CGFloat scaleY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [_mistService start];
 }

- (void)setup {
    _blueDot = [self createBlueDot];
    self.mistService = [[MistService alloc] initWithToken: SDK_TOKEN];
    self.mistService.delegate = self;
 }

- (void)didUpdateLocation:(CGPoint)location {
    CGFloat scaledX = location.x * _scaleX;
    CGFloat scaledY = location.y * _scaleY;
    CGPoint relativeLocation = CGPointMake(scaledX, scaledY);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.blueDot.center = relativeLocation;
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

@end
