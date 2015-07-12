//
//  PostingExpandedView.m
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingExpandedView.h"

@implementation PostingExpandedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize siz = CGSizeMake(frame.size.width, frame.size.height);
        [self layoutFields:siz];
    }
    
    return self;
}


-(void) layoutFields: (CGSize) realSize{
    CGFloat originX = 14.0;
    CGFloat realWidth = realSize.width - originX;
    [self.oBackImage setFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    
    self.oBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    self.oBackImage.image = [UIImage imageNamed:@"post_expanded_back.png"];
    [self addSubview:self.oBackImage];
}

//- (IBAction)actionPlus:(id)sender {
//}
//
//- (IBAction)actionBin:(id)sender {
//}
//
//- (IBAction)actionJType:(id)sender {
//}
//
//- (IBAction)actionIndustry:(id)sender {
//}
//
//- (IBAction)actionMorningSw:(id)sender {
//}
//
//- (IBAction)actionAfternoonSw:(id)sender {
//}
//
//- (IBAction)actionEveningSw:(id)sender {
//}
//
//- (IBAction)actionNightSw:(id)sender {
//}

@end
