//
//  TeacherCollectionViewCell.m
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherCollectionViewCell.h"

@implementation UIColor (MyProject)

+(UIColor *) GREENCOLOR { return [UIColor colorWithRed:0 green:0.702 blue:0.494 alpha:1]; }

@end

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
//        self.teacherNameLabel.backgroundColor = [UIColor clearColor];
//        self.teacherNameLabel.textColor = [UIColor blackColor];
    //    self.teacherImage.transform = CGAffineTransformMakeRotation(M_PI/2);
        
    }
    return self;
}


@end
