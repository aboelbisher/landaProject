//
//  TeachersDetailsViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/8/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeachersDetailsViewController.h"
#import <MessageUI/MessageUI.h>

@interface TeachersDetailsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation TeachersDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.teacherImage.image = [UIImage imageNamed:self.teacher.imageName];
    
    self.nameLabel.text = self.teacher.name;
    self.mailLabel.text = self.teacher.mail;
    
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
    if ([MFMailComposeViewController canSendMail]){
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
//            [[[UIAlertView alloc] initWithTitle:@"Mail" message:@"your mail has been canceled!"
//                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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