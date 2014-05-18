//
//  TeacherCollectionViewCell.h
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"


@interface TeacherCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak , nonatomic) Teacher* teacher;
@end
