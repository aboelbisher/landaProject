//
//  CourseLocal.h
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeacherIdLocal.h"

@class TeacherIdLocal;

@interface CourseLocal : NSObject


@property (nonatomic, strong) NSString * beginTime;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * place;
@property (nonatomic, strong) NSString * subjectId;
@property (nonatomic, strong) NSMutableArray *teachers;

-(instancetype)initCorseLocalWithBeginTime:(NSString*)beginTime  endTime:(NSString*)endTime id:(NSString*)id imageName:(NSString*)imageName name:(NSString*)name place:(NSString*)place subjectId:(NSString*)subjectId;

- (void)addTeachersObject:(TeacherIdLocal *)value;
- (void)removeTeachersObject:(TeacherIdLocal *)value;

-(BOOL)isEqual:(CourseLocal*)object;



@end
