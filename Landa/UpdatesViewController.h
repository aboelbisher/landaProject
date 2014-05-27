//
//  UpdatesViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdatesTableViewCell.h"
#import "TeachersDetailsViewController.h"
#import "UpdatesContentViewController.h"
#import "Update.h"
#import "Update+init.h"
#import "LandaAppDelegate.h"

@interface UpdatesViewController : UIViewController

-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;


@end



