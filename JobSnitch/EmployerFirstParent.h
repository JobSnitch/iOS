//
//  EmployerFirstParent.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmployerFirstParent <NSObject>
-(void) delegateHasCanceled:(id)sender;
-(void) delegateHasSaved:(id)sender;
- (void)delegateAddJobType:(id)sender;
- (void)delegateAddIndustry:(id)sender;
- (void)delegateExpandPosting:(id)sender;

@end
