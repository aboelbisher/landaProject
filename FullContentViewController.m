//
//  FullContentViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 6/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "FullContentViewController.h"

@interface FullContentViewController ()<UIWebViewDelegate>

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
    //self.view.backgroundColor =
    
    NSString * html = @"<html> <body style=\"background:#FFFFFF; color:#000000;\"> ";
    
    html = [html stringByAppendingString:self.update.htmlUpdate];
    
    html = [html stringByAppendingString:@" </body> </html>"];
    
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:self.update.url]];
    
    //self.webView.backgroundColor = [UIColor greenColor];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    self.webView.delegate = self;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];


}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * NewHtml = @"javascript:(function() { document.getElementsByTagName('body')[0].style.color = '#000000';var ps= document.getElementsByTagName('p'); for(var i=0;i<ps.length;i++){ps[i].style.color = '#e0e0e0';}var spans=document.getElementsByTagName('span');for(var i=0;i<spans.length;i++){spans[i].style.color = '#000000';}document.getElementsByTagName('table')[0].style.color = '#000000';})();";
    [self.webView stringByEvaluatingJavaScriptFromString:NewHtml];
}



@end
