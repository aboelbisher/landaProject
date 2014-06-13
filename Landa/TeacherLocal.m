//
//  TeacherLocal.m
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherLocal.h"

@implementation TeacherLocal



-(instancetype)initTeacherWithName:(NSString*) name faculty:(NSString*)faculty id:(NSString*)id imageName:(NSString*)imageName localImageFilePath:(NSString*)localImageFilePath mail:(NSString*)mail position:(NSString*)position
{
    TeacherLocal * newTeacher = [[TeacherLocal alloc] init];
    newTeacher.name = name;
    newTeacher.id = id;
    newTeacher.faculty = faculty;
    newTeacher.imageName = imageName;
    newTeacher.localImageFilePath = localImageFilePath;
    newTeacher.mail = mail;
    newTeacher.position = position;
    
    return newTeacher;
}

@end
