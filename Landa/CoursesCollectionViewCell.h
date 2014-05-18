//
//  CoursesCollectionViewCell.h
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CoursesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (nonatomic ,weak) Course * course;

@end
