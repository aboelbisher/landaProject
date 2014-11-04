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
        self.title.textColor = [UIColor GREENCOLOR];
        self.timeLabel.textColor = [UIColor GREENCOLOR];
        // Initialization code
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
