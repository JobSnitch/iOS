//
//  EmployerThirdViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployerThirdViewController.h"
#import "CreateEmployerController.h"

@interface EmployerThirdViewController () <EmployerProfileContainerDelegate>
@property (nonatomic, strong) CreateEmployerController *employerSettingsController;
@end

@implementation EmployerThirdViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createChildController];
}

-(void) createChildController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.employerSettingsController = (CreateEmployerController *) [storyboard instantiateViewControllerWithIdentifier:@"CreateEmployerController"];
    [self.employerSettingsController setupEmployer:self];
    [self addChildViewController:self.employerSettingsController];
    [self.employerSettingsController didMoveToParentViewController:self];
    self.employerSettingsController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -49);
    [self.view addSubview:self.employerSettingsController.view];
    [self.employerSettingsController customizeSettings];
    
    self.employerSettingsController.delegate = self;
}

#pragma mark - EmployerProfileContainerDelegate
-(void) hasFinishedProfile {
    [self.employerSettingsController willMoveToParentViewController:nil];
    [self.employerSettingsController.view removeFromSuperview];
    [self.employerSettingsController removeFromParentViewController];
    self.employerSettingsController  =nil;
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
