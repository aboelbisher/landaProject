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
   inManagedObjectContext:(NSManagedObjectContext*)context;
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
        [context save:&error];


    }

    return teacher;

 
}


@end
