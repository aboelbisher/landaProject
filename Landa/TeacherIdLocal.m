//
//  TeacherIdLocal.m
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherIdLocal.h"

@implementation TeacherIdLocal



-(instancetype)initTeacherIdLocalWithBeginTime:(NSString*)beginTime day:(NSString*)day endTime:(NSString*)endTime id:(NSString*)id notify:(NSString*)notify
{
    TeacherIdLocal * teacherId = [[TeacherIdLocal alloc] init];
    
    teacherId.beginTime = beginTime;
    teacherId.day = day;
    teacherId.endTime = endTime;
    teacherId.id = id;
    teacherId.notify = notify;
    
    return teacherId;
}

-(BOOL)isEqual:(TeacherIdLocal*)object
{
    return ([_id isEqual:[object id]] && [_day isEqual:[object day]] && [_beginTime isEqual:[object beginTime]]);
}

@end
