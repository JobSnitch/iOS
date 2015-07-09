//
//  NewInfoPopupParent.h
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewInfoPopupParent <NSObject>
-(void) delegateHasCanceled;
-(void) delegateHasSaved;

@end
