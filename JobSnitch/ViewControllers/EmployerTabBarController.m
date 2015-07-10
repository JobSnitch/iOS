//
//  EmployerTabBarController.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployerTabBarController.h"

@interface EmployerTabBarController ()

@end

@implementation EmployerTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIViewController *page in self.viewControllers) {                  // customize text
        
        switch (page.tabBarItem.tag) {                  // customize unselected images: yes do not use the @2x suffix!
            case 200:
                page.tabBarItem.image = [[UIImage imageNamed:@"emp_bar_1.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"emp_bar_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            case 201:
                page.tabBarItem.image = [[UIImage imageNamed:@"emp_bar_2.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"emp_bar_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            case 202:
                page.tabBarItem.image = [[UIImage imageNamed:@"emp_bar_3.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
                page.tabBarItem.selectedImage = [[UIImage imageNamed:@"emp_bar_3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                page.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
