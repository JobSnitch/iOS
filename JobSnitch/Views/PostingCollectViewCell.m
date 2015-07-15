//
//  PostingCollectViewCell.m
//  JobSnitch
//
//  Created by Andrei Sava on 15/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingCollectViewCell.h"

@implementation PostingCollectViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PostingCollectViewCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        [self layoutFields];
    }
    return self;
}

-(void) layoutFields {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat _screenHeight = screenRect.size.height;
    [self bringSubviewToFront:self.oIntermView];
    [self bringSubviewToFront:self.oLeftButton];
    [self bringSubviewToFront:self.oRightButton];
    
    if (_screenHeight < 481.0) {
        self.oImgVertConstraint.constant = 24.0;
        self.oBusinessVertConstraint.constant = 120.0;
        self.oNameVertConstraint.constant = 190.0;
        self.oLowerVwVertConstraint.constant = 80.0;
    }
}


- (IBAction)actionLeft:(id)sender {
    [self.delegate delegateLeft];
}

- (IBAction)actionRight:(id)sender {
    [self.delegate delegateRight];
}

- (IBAction)actionText:(id)sender {
    [self.delegate delegateText:self];
}

- (IBAction)actionVideo:(id)sender {
    [self.delegate delegateVideo];
}

- (IBAction)actionAudio:(id)sender {
    [self.delegate delegateAudio];
}

@end
