//
//  EmployeeLandingViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeLandingViewController.h"
#import "EmployeeRecord.h"
#import "EmployeeFirstView.h"

@import MapKit;

@interface EmployeeLandingViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *oMapView;

@property (nonatomic, strong)   EmployeeRecord *currentEmployee;
@property (nonatomic, strong)   EmployeeFirstView *mainView;
@property (nonatomic)       CLLocationCoordinate2D coords;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation * myLocation;

@end

@implementation EmployeeLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocation];
    [self setupEmployee];
    
    [self setupView];
}

-(void) viewDidLayoutSubviews {
    [self.mainView layoutFields:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.mainView setFrame:self.view.frame];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Data
-(void) setupEmployee {
    self.currentEmployee = [[EmployeeRecord alloc] init];
    self.currentEmployee.name = @"joe_blow";
    self.currentEmployee.imageName = @"small_add_photo.png";
    
}

#pragma mark - interface
-(void) setupView {
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeFirstView" owner:self options:nil] objectAtIndex:0];
    [self.mainView setFrame:self.view.frame];
    [self.view addSubview:self.mainView];
    
    [self setupHeader];
    [self.view bringSubviewToFront:self.oMapView];
}

-(void) setupShowMap {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ( self.coords, 10000, 10000);
    [self.oMapView setRegion:region animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.coords];
    [self.oMapView addAnnotation:annotation];
}

-(void) setupHeader {
    self.mainView.oTopImage.image = [UIImage imageNamed:self.currentEmployee.imageName];
    self.mainView.oNameLabel.text = self.currentEmployee.name;
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

-(void) locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
}


#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
