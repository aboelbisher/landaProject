//
//  TeacherCollectionViewCell.m
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherCollectionViewCell.h"

@implementation TeacherCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)encoder
{
    self = [super initWithCoder:encoder];
    if (self)
    {
        self.teacherNameLabel.backgroundColor = [UIColor clearColor];
        
        self.teacherImage.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    return self;
}


@end
