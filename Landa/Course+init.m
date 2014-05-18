//
//  Course+init.m
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Course+init.h"

@implementation Course (init)

+(Course*) initWithName:(NSString*)name imageName:(NSString*)imageName date:(NSDate*)date inManagedObjectContext:context
{
    Course* course = nil;
    
    
    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:courseEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", name];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];

    if([objects count] == 0)
    {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        
        course.name = name;
        course.imageName = imageName;
        course.date = date;
        [context save:&error];
    }
    return course;
}

@end
