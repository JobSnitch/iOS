//
//  EmployeeTabBarController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeTabBarController.h"
#import "EmployeeTabBarDelegate.h"
#import "EmployeeLandingViewController.h"
#import "EmployeePostingViewController.h"
#import "EmployeeOptionsViewController.h"

@interface EmployeeTabBarController () <EmployeeTabBarDelegate>

@end

@implementation EmployeeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupItems];
}

-(void) setupItems {
    for (UIViewController *page in self.viewControllers) {                  // customize text
        
        switch (page.tabBarItem.tag) {                  // customize unselected images: yes do not use the @2x suffix!
            case 400:
                page.tabBarItem.image = [[UIImage imageNamed:@"home_tab_item"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tab_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            case 401:
                page.tabBarItem.image = [[UIImage imageNamed:@"search_red"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"search_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            case 402:
                page.tabBarItem.image = [[UIImage imageNamed:@"eye_red"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"eye_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                ((EmployeeOptionsViewController *) page).parent = self;
                break;
            case 403:
                page.tabBarItem.image = [[UIImage imageNamed:@"emp_bar_3"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"emp_bar_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            case 404:
                page.tabBarItem.image = [[UIImage imageNamed:@"emp_bar_1"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"emp_bar_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            default:
                break;
        }
    }
}

#pragma mark - EmployeeTabBarDelegate
-(void) parentReplaceFirst: (int) newOption {
    NSMutableArray *myVCs = (NSMutableArray *) self.viewControllers;
    UIViewController *oldVC = myVCs[0];
    UIStoryboard *reflectionStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmployeeLandingViewController *mapVC = nil;
    EmployeePostingViewController *postVC= nil;
    switch (newOption) {
        case 0:
            if ([oldVC isKindOfClass:[EmployeeLandingViewController class]]) {
                return;
            }
            [myVCs removeObjectAtIndex:0];
            oldVC = nil;
            mapVC = [reflectionStoryboard instantiateViewControllerWithIdentifier:@"EmployeeLandingViewController"];
            [myVCs insertObject:mapVC atIndex:0];
            break;
//        case 1:                                                                                   NOT YET IMPL
//            if ([oldVC isKindOfClass:[EmployeeLandingViewController class]]) {
//                return;
//            }
//            [myVCs removeObjectAtIndex:0];
//            oldVC = nil;
//            mapVC = [reflectionStoryboard instantiateViewControllerWithIdentifier:@"EmployeeLandingViewController"];
//            [myVCs insertObject:mapVC atIndex:0];
//            break;
        case 2:
            if ([oldVC isKindOfClass:[EmployeePostingViewController class]]) {
                return;
            }
            [myVCs removeObjectAtIndex:0];
            oldVC = nil;
            postVC = [reflectionStoryboard instantiateViewControllerWithIdentifier:@"EmployeePostingViewController"];
            [myVCs insertObject:postVC atIndex:0];
            break;
        default:
            break;
    }
    [self setViewControllers: myVCs];
    ((UIViewController *)self.viewControllers[0]).tabBarItem.tag = 400;
    [self setupItems];
    self.selectedIndex = 0;
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
