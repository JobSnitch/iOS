//
//  HomeDelegate.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeDelegate <NSObject>
-(void) delegateForgotPassword;
-(void) delegateLoginFacebook;
-(void) delegateCreateJSeeker;
-(void) delegateCreateEmployer;
-(void) delegateShowAbout;
-(void) delegateShowContact;
-(void) delegateShowBugRep;

@end
