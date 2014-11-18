//
//  TeacherId+init.m
//  Landa
//
//  Created by muhammad abed el razek on 5/23/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherId+init.h"

@implementation TeacherId (init)

+(TeacherId *) initWithId:(NSString*)id
beginTime:(NSString*)beginTime
endTime:(NSString*)endTime
day:(NSString*)day
place:(NSString*)place
notify:(NSString*)notify
inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    TeacherId* teacher = nil;
    //    NSEntityDescription *teacherIdEntityDisc = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    [request setEntity:teacherIdEntityDisc];
    //    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@ AND beginTime = %@ AND day = %@)", id , beginTime , day];
    //    [request setPredicate:pred];
    NSError *error;
    //    NSArray *objects = [context executeFetchRequest:request error:&error];
    //
    //    if([objects count] == 0)
    //    {
    teacher = [NSEntityDescription insertNewObjectForEntityForName:@"TeacherId" inManagedObjectContext:context];
    teacher.id = id;
    teacher.beginTime = beginTime;
    teacher.endTime = endTime;
    teacher.day = day;
    teacher.notify = notify;
    teacher.place = place;
    [context save:&error];
    
    //}
    return teacher;
}

+(NSArray *)getTeacherIdWithId:(NSString*)id beginTime:(NSString*)beginTime day:(NSString*)day inManagedObjecContext:(NSManagedObjectContext*)context
{
    NSError * error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@ AND beginTime = %@ AND day = %@" , id , beginTime , day];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
    
    return teachersArray;
}

+(NSArray*)getAllTeachersIdInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    NSEntityDescription *teacherIdEntity = [NSEntityDescription entityForName:@"TeacherId" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherIdEntity];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];

    return objects;
}


+(void) deleteAllTeachersIdInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    NSArray * allTeachersId = [TeacherId getAllTeachersIdInManagedObjectContext:context];
    
    for(TeacherId * teacherId in allTeachersId)
    {
        [context deleteObject:teacherId];
        [context save:&error];
    }
}







@end
