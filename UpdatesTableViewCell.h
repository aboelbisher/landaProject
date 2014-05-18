//
//  UpdatesTableViewCell.h
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update.h"

@interface UpdatesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak , nonatomic) Update* update;

//@property (weak, nonatomic) IBOutlet UIImageView *expandImage;
//@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (nonatomic) BOOL ifSelected;
@end
