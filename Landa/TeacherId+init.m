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
inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    
    TeacherId* teacher = nil;
    teacher = [NSEntityDescription insertNewObjectForEntityForName:@"TeacherId" inManagedObjectContext:context];
    teacher.id = id;
    teacher.beginTime = beginTime;
    teacher.endTime = endTime;
    
    [context save:&error];
    
    return teacher;
}


@end
