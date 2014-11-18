//
//  TeacherIdLocal.h
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseLocal.h"

@interface TeacherIdLocal : NSObject

@property (nonatomic, strong) NSString * beginTime;
@property (nonatomic, strong) NSString * day;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * notify;
@property (nonatomic , strong) NSString * place;
//@property (nonatomic, strong) CourseLocal *course;

-(instancetype)initTeacherIdLocalWithBeginTime:(NSString*)beginTime day:(NSString*)day endTime:(NSString*)endTime id:(NSString*)id place:(NSString*)place notify:(NSString*)notify;

-(BOOL)isEqual:(id)object;

@end
