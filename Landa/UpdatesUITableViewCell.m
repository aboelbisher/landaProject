//
//  UpdatesUITableViewCell.m
//  Landa
//
//  Created by muhammad abed el razek on 6/5/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesUITableViewCell.h"

@implementation UpdatesUITableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.textColor = [UIColor myGreenColor];
        self.timeLabel.textColor = [UIColor myGreenColor];
        // Initialization code
    }
    return self;
}

@end
