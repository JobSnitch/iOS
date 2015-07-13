//
//  EmployerFirstParent.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmployerFirstParent <NSObject>
-(void) delegateHasCanceled;
-(void) delegateHasSaved;
- (void)delegateAddJobType:(id)sender;
- (void)delegateAddIndustry:(id)sender;

@end
