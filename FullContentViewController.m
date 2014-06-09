//
//  FullContentViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 6/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "FullContentViewController.h"

@interface FullContentViewController ()

@end

@implementation FullContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * html = @"<html> <body style=\"background:#ffffff; color:#000000;\"> ";
    
    html = [html stringByAppendingString:self.update.htmlUpdate];
    
    html = [html stringByAppendingString:@" </body> </html>"];
    
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:self.update.url]];
    
    self.webView.backgroundColor = [UIColor clearColor];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
