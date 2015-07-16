//
//  EmployeeSettingsViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeSettingsViewController.h"
#import "CreateJobseekerController.h"

@interface EmployeeSettingsViewController () <EmployeeProfileContainerDelegate>
@property (nonatomic, strong) CreateJobseekerController *employeeSettingsController;

@end

@implementation EmployeeSettingsViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createChildController];
}

-(void) createChildController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.employeeSettingsController = (CreateJobseekerController *) [storyboard instantiateViewControllerWithIdentifier:@"CreateJobseekerController"];
    [self addChildViewController:self.employeeSettingsController];
    [self.employeeSettingsController didMoveToParentViewController:self];
    self.employeeSettingsController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -49);
    [self.view addSubview:self.employeeSettingsController.view];
    [self.employeeSettingsController customizeSettings:self];
    
    self.employeeSettingsController.delegate = self;
}

#pragma mark - EmployerProfileContainerDelegate
-(void) hasFinishedProfile {
    [self.employeeSettingsController willMoveToParentViewController:nil];
    [self.employeeSettingsController.view removeFromSuperview];
    [self.employeeSettingsController removeFromParentViewController];
    self.employeeSettingsController  =nil;
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
