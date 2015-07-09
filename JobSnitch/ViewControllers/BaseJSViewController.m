//
//  BaseJSViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "JSCustomUnwindSegue.h"

@interface BaseJSViewController ()

@end

@implementation BaseJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) initBackground {
    self.backgroundGradient = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundGradient setImage:[UIImage imageNamed:@"gradient_red_back_sq.png"]];
    [self.view addSubview:self.backgroundGradient];
    [self.view sendSubviewToBack:self.backgroundGradient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - unwind segue
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}

// We need to over-ride this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier {
    
    JSCustomUnwindSegue *segue = [[JSCustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    
    return segue;
}


@end
