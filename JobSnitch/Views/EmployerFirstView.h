//
//  EmployerFirstView.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerFirstView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *oTopImage;
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;

-(void) layoutFields: (CGSize) realSize;
@end
