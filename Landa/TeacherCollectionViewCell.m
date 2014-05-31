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
//        self.teacherImage.image = [UIImage imageNamed:self.teacher.imageName];

        
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

//        
//        self.teacherImage.layer.shadowColor = [UIColor whiteColor].CGColor;
//        self.teacherImage.layer.shadowOffset = CGSizeMake(0, 1);
//        self.teacherImage.layer.shadowOpacity = 1;
//        self.teacherImage.layer.shadowRadius = 1.0;
//        self.teacherImage.clipsToBounds = NO;
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
