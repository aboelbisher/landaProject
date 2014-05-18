//
//  TeachersNavigationController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/7/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeachersNavigationController.h"

@interface TeachersNavigationController ()

@end

@implementation TeachersNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.topItem.title = @"Teachers";
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation.jpg"]];
    
   // [self.navigationBar insertSubview:backgroundView atIndex:0];

  //  self.navigationBar.barStyle = UIBarStyleBlack;
//self.navigationBar.barTintColor = [UIColor blueColor];
   // self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navigation.jpg"];
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.navigationBar.barStyle = UIBarStyleDefault;
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
