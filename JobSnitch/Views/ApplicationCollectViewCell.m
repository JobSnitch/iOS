//
//  ApplicationCollectViewCell.m
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "ApplicationCollectViewCell.h"

@implementation ApplicationCollectViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ApplicationCollectViewCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (IBAction)actionLeft:(id)sender {
    [self.delegate delegateLeft];
}

- (IBAction)actionRight:(id)sender {
    [self.delegate delegateRight];
}

- (IBAction)actionText:(id)sender {
    [self.delegate delegateText];
}

- (IBAction)actionVideo:(id)sender {
    [self.delegate delegateVideo];
}

- (IBAction)actionAudio:(id)sender {
    [self.delegate delegateAudio];
}

- (IBAction)actionDelete:(id)sender {
    [self.delegate delegateDelete];
}

- (IBAction)actionFolder:(id)sender {
    [self.delegate delegateFolder];
}

- (IBAction)actionCheck:(id)sender {
    [self.delegate delegateCheck];
}


@end
