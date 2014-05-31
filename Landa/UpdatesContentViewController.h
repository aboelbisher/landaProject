//
//  UpdatesContentViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 5/11/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update.h"
#import "LandaAppDelegate.h"

@interface UpdatesContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak , nonatomic) Update * update;
@property(strong , nonatomic) NSString* updateContentText;
@end
