//
//  Course+init.m
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Course+init.h"

@implementation Course (init)

+(Course*) initWithName:(NSString*)name
                     id:(NSString*) id
subjectId:(NSString*)subjectId
imageName:(NSString*)imageName
place:(NSString*)place
beginTime:(NSString*)beginTime
endTime:(NSString*) endTime
inManagedObjectContext:context
{
    Course* course = nil;
    
    
    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:courseEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", name];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if([objects count] == 0)
    {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        
        course.name = name;
        course.imageName = imageName;
        course.place = place;
        course.beginTime = beginTime;
        course.endTime = endTime;
        course.id = id;
        course.subjectId = subjectId;
        [context save:&error];
    }
    return course;
}

+(NSArray*)getAllCoursesInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:courseEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    return objects;
}

+(NSArray*)getCoursesWithName:(NSString*)name inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:courseEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", name];
    [request setPredicate:pred];
    NSError *error;
    NSArray *courses = [context executeFetchRequest:request error:&error];
    
    return courses;
}

@end
