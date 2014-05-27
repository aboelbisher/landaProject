//
//  TeachersDetailsViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 4/8/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"
#import <MessageUI/MessageUI.h>


@interface TeachersDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
//@property (weak , nonatomic) NSString* teacherImageName;
@property (weak , nonatomic) NSString* localFilePath;
@property (weak , nonatomic) Teacher * teacher;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;

@end
