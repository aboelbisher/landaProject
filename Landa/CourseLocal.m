//
//  CourseLocal.m
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CourseLocal.h"

@implementation CourseLocal

-(NSMutableSet*)teachers
{
    if(!_teachers)
    {
        _teachers = [[NSMutableSet alloc] init];
    }
    
    return _teachers;
}

-(BOOL)isEqual:(CourseLocal*)object
{
    if([_id isEqual:[object id]])
    {
        if([_teachers isEqual:[object teachers]])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

- (void)addTeachersObject:(TeacherIdLocal *)value
{
    [self.teachers addObject:value];
}
- (void)removeTeachersObject:(TeacherIdLocal *)value
{
    [self.teachers removeObject:value];
}


-(instancetype)initCorseLocalWithBeginTime:(NSString*)beginTime  endTime:(NSString*)endTime id:(NSString*)id imageName:(NSString*)imageName name:(NSString*)name place:(NSString*)place subjectId:(NSString*)subjectId
{
    CourseLocal * course = [[CourseLocal alloc]init];
    
    course.beginTime = beginTime;
    course.endTime = endTime;
    course.id = id;
    course.imageName = imageName;
    course.name = name;
    course.place = place;
    course.subjectId = subjectId;
    
    return course;
}

@end
