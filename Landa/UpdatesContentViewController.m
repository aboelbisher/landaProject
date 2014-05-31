//
//  UpdatesContentViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 5/11/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesContentViewController.h"

@interface UpdatesContentViewController ()

@end

@implementation UpdatesContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.contentInset = UIEdgeInsetsMake(-50,0.0,0,0.0);
    self.textView.text = self.updateContentText;
    self.titleLabel.text = self.update.title;
//    self.dateText.text = [NSString stringWithFormat:@"%@" , self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];

    //[dateFormatter setTwoDigitStartDate:self.update.date];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:self.update.date];


    
    
    self.dateText.text = [NSString stringWithFormat:@"%@" , stringFromDate];
    

}


@end
