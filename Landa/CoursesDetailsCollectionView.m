//
//  CoursesDetailsCollectionView.m
//  Landa
//
//  Created by muhammad abed el razek on 4/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CoursesDetailsCollectionView.h"
#import "TeacherCollectionViewCell.h"
#import "TeachersDetailsViewController.h"
#import "Teacher+init.h"
#import "LandaAppDelegate.h"
#import "TeacherId.h"
#import "CoursesTableViewCell.h"
#import "MapViewController.h"

@interface CoursesDetailsCollectionView () <UITableViewDataSource , UITableViewDelegate>

@property (strong , nonatomic) NSMutableArray * teacherIdArray; // of TeacherId
@property (weak, nonatomic) IBOutlet UITableView *teachersTableView;


@end

#pragma mark init

@implementation CoursesDetailsCollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* image = [HelpFunc getImageFromFileWithId:self.course.subjectId];
    if(!image)
    {
        self.courseImage.image = [UIImage imageNamed:@"landaIcon.png"];
    }
    else
    {
        self.courseImage.image = image;
    }
    
    
    self.teachersTableView.backgroundColor = [UIColor whiteColor];
    self.courseName.text = self.course.name;
    self.teacherIdArray = [[NSMutableArray alloc] init];
    [self.teachersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor whiteColor];
    self.courseName.textColor = [UIColor myGreenColor];
    
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    [self initCoursesDEtailsWithManagedObjectContext:context];
    
    [self.navigationItem setTitle:self.course.name];

}


-(void)initCoursesDEtailsWithManagedObjectContext:(NSManagedObjectContext*)context
{
    for(TeacherId * teacherId in self.course.teachers)
    {
        NSArray * tmpTeacherIdArray = [TeacherId getTeacherIdWithId:teacherId.id beginTime:teacherId.beginTime day:teacherId.day inManagedObjecContext:context];
        
        TeacherId * tmpTeacherId = [tmpTeacherIdArray firstObject];
        
            [self.teacherIdArray addObject:tmpTeacherId];
        
    }
}


#pragma mark UITableView functions


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teacherIdArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    UITableViewCell * cell = [self.teachersTableView dequeueReusableCellWithIdentifier:@"teacher details"];
    
    if([cell isKindOfClass:[CoursesTableViewCell class]])
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //add seperator line to the cell
        int cellHeigh = cell.bounds.size.height;
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeigh, 320, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];// you can also put image here !!!!!
        [cell.contentView addSubview:separatorLineView];
        
        TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];
        
        CoursesTableViewCell * courseCell = (CoursesTableViewCell*) cell;
        
        if([teacherId.notify isEqualToString:@"YES"])
        {
            courseCell.switcherOutlet.on = YES;
            cell.backgroundColor = [UIColor blackColor];
        }
        else
        {
            courseCell.switcherOutlet.on = NO;
        }
        
        courseCell.teacherId = teacherId;
        
        NSString * day = teacherId.day;
        NSString * time = @"";
        time = [time stringByAppendingString:teacherId.beginTime];
        time = [time stringByAppendingString:[NSString stringWithFormat:@" - %@", teacherId.endTime ] ];
        courseCell.dayLabel.text = day;
        courseCell.timeLabel.text = time;
        courseCell.courseName = self.course.name;
        
        courseCell.dayLabel.textColor = [UIColor myGreenColor];
        courseCell.timeLabel.textColor = [UIColor myGreenColor];
        [courseCell.placeButton setTitle:teacherId.place forState:UIControlStateNormal]; // To set the title

    }
    return cell;
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"navigate"])
    {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]])
        {
                UIButton* sourceController = (UIButton*) sender;
                
                MapViewController *tsvc = (MapViewController *)segue.destinationViewController;
                tsvc.place = sourceController.titleLabel.text;
        }
    }
}











@end
