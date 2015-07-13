//
//  PostingAddView.m
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingAddView.h"

@implementation PostingAddView

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
    
    self.oBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    self.oBackImage.image = [UIImage imageNamed:@"post_expanded_back.png"];
    [self addSubview:self.oBackImage];
    
    [super layoutFields:realSize];
}

@end
