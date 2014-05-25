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
{
    BOOL _makeCheckMark;
}

//@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
//@property (strong , nonatomic) NSManagedObjectContext * context;
@property (strong , nonatomic) NSMutableArray * teachers; // of Teacher
@property (strong , nonatomic) NSMutableArray * teacherIdArray; // of TeacherId
@property (weak, nonatomic) IBOutlet UITableView *teachersTableView;


@end

@implementation CoursesDetailsCollectionView

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
    
    
    _makeCheckMark = NO;
    
    self.teachersTableView.backgroundColor = [UIColor clearColor];
    self.courseImage.image = [UIImage imageNamed:self.course.imageName];
    self.courseName.text = self.course.name;
    self.teachers = [[NSMutableArray alloc] init];
    self.teacherIdArray = [[NSMutableArray alloc] init];
    

    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    [self initCoursesDEtailsWithManagedObjectContext:context];
    


//
//    for(Teacher* teacher in objects)
//    {
//        [self.course addTeachersObject:teacher];
//    }
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
        
        Teacher * teacher = [self.teachers objectAtIndex:indexPath.item];
        TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];
        
        if([teacherId.notify isEqualToString:@"YES"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
                        
        
        CoursesTableViewCell * course = (CoursesTableViewCell*) cell;
        
        NSString * teacherName = teacher.name;
        NSString * day = teacherId.day;
        NSString * time = @"start : ";
        time = [time stringByAppendingString:teacherId.beginTime];
        time = [time stringByAppendingString:[NSString stringWithFormat:@" end: %@", teacherId.endTime ] ];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",teacherId.id]];
        UIImage* image = [UIImage imageWithContentsOfFile:path];
       
        
        //course.teacherName = [NSString stringWithString:teacherName];
        course.nameLabel.text = teacherName;
        course.dayLabel.text = day;
        course.timeLabel.text = time;
        course.image.image = image;
        
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];

    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@ AND beginTime = %@ AND day = %@" , teacherId.id , teacherId.beginTime , teacherId.day];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
    TeacherId * teacherIdCoreData = [teachersArray firstObject];
    
    if([teacherIdCoreData.notify isEqualToString:@"YES"])
    {
        teacherId.notify = @"NO";
        teacherIdCoreData.notify = @"NO";
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString* id = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"teacherId"]];
            NSString* day = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"day"]];
            NSString* beginTime = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"beginTime"]];

            
            if ([id isEqualToString:teacherId.id] && [day isEqualToString:teacherId.day] && [beginTime isEqualToString:teacherId.beginTime])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else
    {
        teacherId.notify = @"YES";
        teacherIdCoreData.notify = @"YES";
        
        NSDate *now = [NSDate date];
//        // Specify which units we would like to use
//        unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *components = [calendar components:units fromDate:now];
        int day = [self getIntWeekDayFromStringDay:teacherId.day];
        int hour = [self getHourFromString:teacherId.beginTime];
        int minute = [self getMinuteFromString:teacherId.endTime];
        
        NSString * message = [NSString stringWithFormat:@"you have %@ course" , self.course.name];
        
        [self weekEndNotificationOnWeekday:day hour:hour minute:minute message:message teacherId:teacherId startDate:now];
        
//        NSInteger year = [components year];
//        NSInteger month = [components month];
//        NSInteger day = [components day];
//        
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        [comps setDay:25];
//        [comps setMonth:5];
//        [comps setYear:2014];
//        [comps setHour:2];
//        [comps setMinute:17];
//        // [comps setSecond:10];
//        
//        
        //UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertBody = @"Reminddddddddddddddd!!!!!!!!!!";
//        
//        localNotification.fireDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        
        
    }
    
    [context save:&error];

    
    teacherEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    pred = [NSPredicate predicateWithFormat:@"name = %@" , self.course.name];
    [request setPredicate:pred];
    NSArray * courses = [context executeFetchRequest:request error:&error];
    
    self.course = [courses firstObject];
    [self.teacherIdArray removeAllObjects];
    [self.teachers removeAllObjects];
    [self initCoursesDEtailsWithManagedObjectContext:context];
      NSMutableArray * paths = [[NSMutableArray alloc] init];
    [paths addObject:indexPath];
    [tableView reloadData];
}

-(void) weekEndNotificationOnWeekday:(int)weekday hour:(int)hour minute:(int)minute message:(NSString*)message teacherId:(TeacherId*)teacherId  startDate:(NSDate*) alramDate
{
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: alramDate];
    [componentsForFireDate setWeekday: weekday]; //for fixing Sunday
    [componentsForFireDate setHour:hour];
    [componentsForFireDate setMinute:minute];
    notification.repeatInterval = NSWeekCalendarUnit;
    notification.fireDate=[calendar dateFromComponents:componentsForFireDate];
    notification.alertBody = message;
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:teacherId.id, @"teacherId", teacherId.day , @"day", teacherId.beginTime ,@"beginTime" , nil];
    
    notification.userInfo = dict;

    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

-(int)getIntWeekDayFromStringDay:(NSString*)day
{
    day = [day stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([day isEqualToString:@"ראשון"])
    {
        return 1;
    }
    if([day isEqualToString:@"שני"])
    {
        return 2;
    }
    if([day isEqualToString:@"שלישי"])
    {
        return 3;
    }
    if([day isEqualToString:@"רביעי"])
    {
        return 4;
    }
    if([day isEqualToString:@"חמישי"])
    {
        return 5;
    }
    
    NSLog(@"invalid day!!!");
    return -1;
}

-(int)getHourFromString:(NSString*)string
{
    NSArray * array = [string componentsSeparatedByString:@":"];
    
    NSString * hour = [array firstObject];
    
    return [hour intValue];
}

-(int)getMinuteFromString:(NSString*)string
{
    NSArray * array = [string componentsSeparatedByString:@":"];
    
    NSString * minute = [array lastObject];
    
    return [minute intValue];
}



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
