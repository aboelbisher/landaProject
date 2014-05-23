//
//  CoursesTableViewCell.m
//  Landa
//
//  Created by muhammad abed el razek on 5/23/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CoursesTableViewCell.h"

@implementation CoursesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
