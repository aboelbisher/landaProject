//
//  FullContentViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 6/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update.h"

@interface FullContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(weak , nonatomic) Update * update;

@end
