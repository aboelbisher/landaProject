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

@property (strong , nonatomic) NSMutableArray * teachers; // of Teacher
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
    self.teachers = [[NSMutableArray alloc] init];
    self.teacherIdArray = [[NSMutableArray alloc] init];
    [self.teachersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    [self initCoursesDEtailsWithManagedObjectContext:context];
    
    [self.navigationItem setTitle:self.course.name];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCoursesDEtailsWithManagedObjectContext:(NSManagedObjectContext*)context
{
    for(TeacherId * teacherId in self.course.teachers)
    {
        NSArray *teachersArray = [Teacher getTeacherWithId:teacherId.id inManagedObjectContext:context];
        
        Teacher * teacher = [teachersArray firstObject];
        if(teacher)
        {
            [self.teachers addObject:teacher];
            [self.teacherIdArray addObject:teacherId];
        }
        
    }
}


#pragma mark UITableView functions


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teachers count];
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
        
        Teacher * teacher = [self.teachers objectAtIndex:indexPath.item];
        TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];
        
        CoursesTableViewCell * courseCell = (CoursesTableViewCell*) cell;
        
        if([teacherId.notify isEqualToString:@"YES"])
        {
            courseCell.switcherOutlet.on = YES;
            cell.backgroundColor = [UIColor colorWithWhite:0.18f alpha:1.0f];
        }
        else
        {
            courseCell.switcherOutlet.on = NO;
        }
        
        courseCell.teacherId = teacherId;
        
        NSString * teacherName = teacher.name;
        NSString * day = teacherId.day;
        NSString * time = @"";
        time = [time stringByAppendingString:teacherId.beginTime];
        time = [time stringByAppendingString:[NSString stringWithFormat:@" - %@", teacherId.endTime ] ];
        
        UIImage* image = [HelpFunc getImageFromFileWithId:teacherId.id];
       
        courseCell.teacherName = [NSString stringWithString:teacherName];
        courseCell.nameLabel.text = teacherName;
        courseCell.dayLabel.text = day;
        courseCell.timeLabel.text = time;
        courseCell.image.image = image;
        courseCell.courseName = self.course.name;
        
        courseCell.nameLabel.textColor = [UIColor GREENCOLOR];
        courseCell.dayLabel.textColor = [UIColor GREENCOLOR];
        courseCell.timeLabel.textColor = [UIColor GREENCOLOR];
        //courseCell..text = self.course.place;
        //courseCell.placeButton.titleLabel.text = self.course.place;
        [courseCell.placeButton setTitle:self.course.place forState:UIControlStateNormal]; // To set the title

    }
    return cell;
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"navigate"])
    {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]])
        {
            //NSLog(@"Mystery object is a %@", NSStringFromClass([sender class]));

                UIButton* sourceController = (UIButton*) sender;
                
                MapViewController *tsvc = (MapViewController *)segue.destinationViewController;
                tsvc.place = sourceController.titleLabel.text;
                //tsvc.teacher = sourceController.teacher;
        }
    }
}











@end
