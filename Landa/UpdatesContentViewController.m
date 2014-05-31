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
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(content = %@)", self.update.content];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    Update * update = [objects firstObject];
    update.hasBeenRead = @"YES";
    
    [context save:&error];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.textView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    [self.textView setTextColor:[UIColor whiteColor]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];

    //[dateFormatter setTwoDigitStartDate:self.update.date];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:self.update.date];


    
    
    self.dateText.text = [NSString stringWithFormat:@"%@" , stringFromDate];
    

}


@end
