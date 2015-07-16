//
//  HomeDelegate.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeDelegate <NSObject>
-(void) delegateShowAbout;
-(void) delegateShowContact;
-(void) delegateShowBugRep;
@optional
-(void) delegateForgotPassword;
-(void) delegateLoginFacebook;
-(void) delegateCreateJSeeker;
-(void) delegateCreateEmployer;
-(void) delegateConnectEmployer;
-(void) delegateConnectEmployee;

@end
