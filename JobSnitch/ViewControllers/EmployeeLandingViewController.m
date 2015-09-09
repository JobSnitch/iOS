//
//  EmployeeLandingViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeLandingViewController.h"
#import "EmployeeFirstView.h"

@import MapKit;

@interface EmployeeLandingViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *oMapView;

@property (nonatomic)       CLLocationCoordinate2D coords;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation * myLocation;
@property (nonatomic) int   countUpdates;

@end

@implementation EmployeeLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocation];
    [self setupEmployee];
    
    [self setupEmployeeView];
}

-(void) viewDidLayoutSubviews {
    [self.employeeHeaderView layoutFields:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.employeeHeaderView setFrame:self.view.frame];
    
    [self.view layoutIfNeeded];
}

-(void) setupEmployee {
    [super setupEmployee];
    if ([self.currentEmployee.name isEqualToString:@"jobseeker"]) {
        [self downloadUserInfo:testUserID2];
    }
}

#pragma mark - interface
-(void) setupEmployeeView {
    [super setupEmployeeView];
    
    [self setupHeader];
    [self.view bringSubviewToFront:self.oMapView];
    [self.oMapView setShowsUserLocation:YES];
    self.oMapView.delegate = self;
}

-(void) setupShowMap {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ( self.coords, 10000, 10000);
    [self.oMapView setRegion:region animated:NO];
}

-(void) setupHeader {
    self.employeeHeaderView.oTopImage.image = [UIImage imageNamed:self.currentEmployee.imageName];
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.employeeHeaderView.oTopImage.image = avatarImage;
    }
    self.employeeHeaderView.oNameLabel.text = self.currentEmployee.name;
}

#pragma mark - CLLocationManagerDelegate
- (void) initLocation {
    self.countUpdates = 0;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

// Failed to get current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to Get Your Location");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.myLocation = nil;
    if (locations && locations.count) {
        self.myLocation = [locations[0] copy];
        [self.locationManager stopUpdatingLocation];
        if (!self.countUpdates) {
            self.countUpdates = 1;
            self.coords = self.myLocation.coordinate;
            [self setupShowMap];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinUserLocView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinUserLocView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"pin_type1"];
            pinView.centerOffset = CGPointMake(0, -32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

#pragma mark - UserInfo callback
-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.FirstName) {                      // my interpretation
        self.currentEmployee.name = currUser.FirstName;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).currUserNick = currUser.FirstName;
        self.employeeHeaderView.oNameLabel.text = self.currentEmployee.name;
    }
    
    [self.view setNeedsDisplay];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
