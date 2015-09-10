//
//  TextApplPopupView.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextApplPopupView : UIView
@property (weak, nonatomic) IBOutlet UIWebView *oWebView;
@property (nonatomic, strong)   NSString *message;
-(void) setupContent;
@end
