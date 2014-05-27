//
//  CoursesDetailsCollectionView.h
//  Landa
//
//  Created by muhammad abed el razek on 4/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "TeacherCollectionViewCell.h"
#import "TeachersDetailsViewController.h"
#import "Teacher+init.h"
#import "LandaAppDelegate.h"
#import "TeacherId.h"
#import "CoursesTableViewCell.h"

@interface CoursesDetailsCollectionView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (strong , nonatomic) Course * course;


@end
