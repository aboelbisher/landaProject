//
//  CoursesTableViewCell.h
//  Landa
//
//  Created by muhammad abed el razek on 5/23/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherId.h"
#import "LandaAppDelegate.h"

@interface CoursesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak , nonatomic) NSString* teacherName;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak ,nonatomic) TeacherId * teacherId;
@property (weak , nonatomic) NSString * courseName;
@property (weak, nonatomic) IBOutlet UISwitch *switcherOutlet;

- (IBAction)switcher:(id)sender;


@end
