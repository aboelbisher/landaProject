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

@interface CoursesDetailsCollectionView () <UITableViewDataSource , UITableViewDelegate>

@property (strong , nonatomic) NSMutableArray * teachers; // of Teacher
@property (strong , nonatomic) NSMutableArray * teacherIdArray; // of TeacherId
@property (weak, nonatomic) IBOutlet UITableView *teachersTableView;


@end

@implementation CoursesDetailsCollectionView

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.teachersTableView.backgroundColor = [UIColor clearColor];
    self.courseImage.image = [UIImage imageNamed:self.course.imageName];
    self.courseName.text = self.course.name;
    self.teachers = [[NSMutableArray alloc] init];
    self.teacherIdArray = [[NSMutableArray alloc] init];
    [self.teachersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    [self initCoursesDEtailsWithManagedObjectContext:context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
        
        CoursesTableViewCell * course = (CoursesTableViewCell*) cell;
        
        if([teacherId.notify isEqualToString:@"YES"])
        {
            course.switcherOutlet.on = YES;
        }
        else
        {
            course.switcherOutlet.on = NO;
        }
        
        course.teacherId = teacherId;
        
        NSString * teacherName = teacher.name;
        NSString * day = teacherId.day;
        NSString * time = @" מ: ";
        time = [time stringByAppendingString:teacherId.beginTime];
        time = [time stringByAppendingString:[NSString stringWithFormat:@" עד: %@", teacherId.endTime ] ];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",teacherId.id]];
        UIImage* image = [UIImage imageWithContentsOfFile:path];
       
        course.teacherName = [NSString stringWithString:teacherName];
        course.nameLabel.text = teacherName;
        course.dayLabel.text = day;
        course.timeLabel.text = time;
        course.image.image = image;
        course.courseName = self.course.name;
    }
    return cell;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];
//
//    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSError * error;
//    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:teacherEntityDisc];
//    NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@ AND beginTime = %@ AND day = %@" , teacherId.id , teacherId.beginTime , teacherId.day];
//    [request setPredicate:pred];
//    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
//    TeacherId * teacherIdCoreData = [teachersArray firstObject];
//    
//    if([teacherIdCoreData.notify isEqualToString:@"YES"])
//    {
//        teacherId.notify = @"NO";
//        teacherIdCoreData.notify = @"NO";
//        
//        UIApplication *app = [UIApplication sharedApplication];
//        NSArray *eventArray = [app scheduledLocalNotifications];
//        for (int i=0; i<[eventArray count]; i++)
//        {
//            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//            NSDictionary *userInfoCurrent = oneEvent.userInfo;
//            NSString* id = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"teacherId"]];
//            NSString* day = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"day"]];
//            NSString* beginTime = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"beginTime"]];
//
//            if ([id isEqualToString:teacherId.id] && [day isEqualToString:teacherId.day] && [beginTime isEqualToString:teacherId.beginTime])
//            {
//                //Cancelling local notification
//                [app cancelLocalNotification:oneEvent];
//                break;
//            }
//        }
//        
//    }
//    else
//    {
//        teacherId.notify = @"YES";
//        teacherIdCoreData.notify = @"YES";
//        
//        NSDate *now = [NSDate date];
//        int day = [self getIntWeekDayFromStringDay:teacherId.day];
//        int hour = [self getHourFromString:teacherId.beginTime];
//        int minute = [self getMinuteFromString:teacherId.endTime];
//        NSString * message = [NSString stringWithFormat:@"you have %@ course" , self.course.name];
//        
//        [self weekEndNotificationOnWeekday:day hour:hour minute:minute message:message teacherId:teacherId startDate:now];
//    }
//    
//    [context save:&error];
//
//    
//    teacherEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
//    request = [[NSFetchRequest alloc] init];
//    [request setEntity:teacherEntityDisc];
//    pred = [NSPredicate predicateWithFormat:@"name = %@" , self.course.name];
//    [request setPredicate:pred];
//    NSArray * courses = [context executeFetchRequest:request error:&error];
//    
//    self.course = [courses firstObject];
//    [self.teacherIdArray removeAllObjects];
//    [self.teachers removeAllObjects];
//    [self initCoursesDEtailsWithManagedObjectContext:context];
//      NSMutableArray * paths = [[NSMutableArray alloc] init];
//    [paths addObject:indexPath];
//    [tableView reloadData];
//}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show teacher details"])
    {
        if ([segue.destinationViewController isKindOfClass:[TeachersDetailsViewController class]])
        {
            if([sender isKindOfClass:[TeacherCollectionViewCell class]])
            {
                TeacherCollectionViewCell* sourceController = (TeacherCollectionViewCell*) sender;
                
                TeachersDetailsViewController *tsvc = (TeachersDetailsViewController *)segue.destinationViewController;
                tsvc.localFilePath = sourceController.teacher.localImageFilePath;
                tsvc.teacher = sourceController.teacher;
            }
        }
    }
}

-(void)initCoursesDEtailsWithManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    for(TeacherId * teacherId in self.course.teachers)
    {
        NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:teacherEntityDisc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@" , teacherId.id];
        [request setPredicate:pred];
        NSArray *teachersArray = [context executeFetchRequest:request error:&error];
        Teacher * teacher = [teachersArray firstObject];
        if(teacher)
        {
            [self.teachers addObject:teacher];
            [self.teacherIdArray addObject:teacherId];
        }
        
    }
}






@end
