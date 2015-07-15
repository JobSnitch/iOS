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
    self.employeeHeaderView.oNameLabel.text = self.currentEmployee.name;
}

#pragma mark - CLLocationManagerDelegate
- (void) initLocation {
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

static int countUpdates = 0;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.myLocation = nil;
    if (locations && locations.count) {
        self.myLocation = [locations[0] copy];
        [self.locationManager stopUpdatingLocation];
        if (!countUpdates) {
            countUpdates = 1;
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

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
