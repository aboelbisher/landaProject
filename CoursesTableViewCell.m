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


- (IBAction)switcher:(id)sender
{
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@ AND beginTime = %@ AND day = %@" , self.teacherId.id , self.teacherId.beginTime , self.teacherId.day];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
    TeacherId * teacherIdCoreData = [teachersArray firstObject];
    
    if([teacherIdCoreData.notify isEqualToString:@"YES"])
    {
        self.backgroundColor = [UIColor clearColor];

        self.teacherId.notify = @"NO";
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
            
            if ([id isEqualToString:self.teacherId.id] && [day isEqualToString:self.teacherId.day] && [beginTime isEqualToString:self.teacherId.beginTime])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else
    {
        self.backgroundColor = [UIColor colorWithWhite:0.18f alpha:1.0f];

        self.teacherId.notify = @"YES";
        teacherIdCoreData.notify = @"YES";
        
        NSDate *now = [NSDate date];
        int day = [self getIntWeekDayFromStringDay:self.teacherId.day];
        int hour = [self getHourFromString:self.teacherId.beginTime];
        int minute = [self getMinuteFromString:self.teacherId.endTime];
        NSString * message = [NSString stringWithFormat:@"you have %@ course" , self.courseName];
        
        [self weekEndNotificationOnWeekday:day hour:hour minute:minute message:message teacherId:self.teacherId startDate:now];
    }
   // [NSThread exit];
    [context save:&error];
    
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
    NSString * minute = [array lastObject];
    int retValue = [hour intValue];

    
    if([minute intValue] == 0 )
    {
        retValue -- ;
    }
    
    return retValue;
}

-(int)getMinuteFromString:(NSString*)string
{
    NSArray * array = [string componentsSeparatedByString:@":"];
    
    NSString * minute = [array lastObject];
    
    int retValue = [minute intValue];
    if([minute intValue] < 10 )
    {
        retValue +=50 ;
    }
    else
    {
        retValue -= 10;
    }
    
    return retValue;
}





@end
