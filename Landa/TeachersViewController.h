//
//  TeachersViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TeacherCollectionViewCell.h"
#import "TeachersDetailsViewController.h"
#import "Teacher.h"
#import "Teacher+init.h"
#import "LandaAppDelegate.h"
#import "Reachability.h"
#import "Update+init.h"
#import "LastRefresh.h"
#import "LastRefresh+init.h"
#import "AboutViewController.h"
#import "CoursesViewController.h"
#import "TeacherLocal.h"

@implementation UIColor (MyProject)

+(UIColor *) GREENCOLOR { return [UIColor colorWithRed:0 green:0.702 blue:0.494 alpha:1]; }

@end


@interface TeachersViewController : UIViewController
- (IBAction)showInfo:(id)sender;
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
