//
//  Teacher+init.m
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Teacher+init.h"

@implementation Teacher (init)


+(Teacher *) initWithName:(NSString*)name
                     mail:(NSString*)mail
                imageName:(NSString*)imageName
                       id:(NSString*)id
faculty:(NSString*)faculty
localImageFilePath:(NSString*)localImageFilePath
position:(NSString*)position
inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    Teacher* teacher = nil;
    
    
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)", id];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if([objects count] == 0) // if theres no teacher match
    {
        teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:context];
        teacher.name = name;
        teacher.mail = mail;
        teacher.imageName = imageName;
        teacher.id = id;
        teacher.faculty = faculty;
        teacher.localImageFilePath = localImageFilePath;
        teacher.position = position;
        [context save:&error];
        
        
    }    
    return teacher;
}


+(NSArray*)getAllTeachersInManagedObjectContext:(NSManagedObjectContext*)context
{
//    NSError * error = nil;
//    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:teacherEntityDisc];
//    NSPredicate *pred =nil;
//    [request setPredicate:pred];
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    
//    return objects;
    NSError* error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"position = %@ OR position = %@" , RAKAZ , RAKAZMAIN];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
    
    return teachersArray;

}

+(NSArray*)getTeacherWithId:(NSString*)id inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@" , id];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];
    
    return teachersArray;
}

+(void) deleteAllTeachersInManagedObjectoContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    NSArray * allTeachers = [Teacher getAllTeachersInManagedObjectContext:context];
    
    for(Teacher * teacher in allTeachers)
    {
        [context deleteObject:teacher];
        [context save:&error];
    }
}

+(NSArray*)getTeachersWithPosition:(NSString*)position inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    NSError* error;
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"position = %@" , position];
    [request setPredicate:pred];
    NSArray *teachersArray = [context executeFetchRequest:request error:&error];

    return teachersArray;
}
//-(instancetype) initTeacherWithName:(NSString *)name id:(NSString*)id imageName:(NSString*)imageName localImageFilePath:(NSString*)localImageFilePath mail:(NSString*)mail faculty:(NSString*)faculty position:(NSString*)position
//{
//    Teacher * newTeacher  = nil;
//    newTeacher.name = name;
//    newTeacher.id = id;
//    newTeacher.imageName = imageName;
//    newTeacher.localImageFilePath = localImageFilePath;
//    newTeacher.mail = mail;
//    newTeacher.faculty= faculty;
//    newTeacher.position = position;
//    
//    return newTeacher;
//}



@end
