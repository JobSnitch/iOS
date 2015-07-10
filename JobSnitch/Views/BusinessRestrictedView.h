//
//  BusinessRestrictedView.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessRestrictedView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *oBusinessImage;
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oAddressLabel;

-(void) layoutFields: (CGSize) realSize;

@end
