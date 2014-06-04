//
//  TeachersDetailsViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/8/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeachersDetailsViewController.h"

@interface TeachersDetailsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation TeachersDetailsViewController

#pragma mark init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage * image = [HelpFunc getImageFromFileWithId:self.teacher.id];
    
    //customize
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.teacherImage.image = image;
    self.teacherImage.layer.cornerRadius = self.teacherImage.frame.size.width / 2;
    self.teacherImage.clipsToBounds = YES;
    
    self.nameLabel.text = self.teacher.name;
    self.mailLabel.text = self.teacher.mail;
    self.facultyLabel.text = self.teacher.faculty;
    self.roleLabel.text = self.teacher.position;
    
}

- (IBAction)sendMail:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.teacher.mail];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail])
    {
        // Create and show composer
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [[[UIAlertView alloc] initWithTitle:@"Mail" message:@"your mail has been sent"
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            NSString * errorMessage = [NSString stringWithFormat:@"Mail sent failure: %@", error];
            [[[UIAlertView alloc] initWithTitle:@"Mail" message:errorMessage
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}





@end
