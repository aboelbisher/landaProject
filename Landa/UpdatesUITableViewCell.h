//
//  UpdatesUITableViewCell.h
//  Landa
//
//  Created by muhammad abed el razek on 6/5/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "SWTableViewCell.h"
#import "Update.h"
#import "HelpFunc.h"

@interface UpdatesUITableViewCell : SWTableViewCell

@property (weak , nonatomic) Update* update;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hasBeenReadImage;
@property (weak, nonatomic) IBOutlet UIImageView *flaggedImage;

@end
