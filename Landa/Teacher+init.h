//
//  Teacher+init.h
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Teacher.h"
#import "HelpFunc.h"

@interface Teacher (init)

+(Teacher *) initWithName:(NSString*)name
                     mail:(NSString*)mail
                imageName:(NSString*)imageName
                       id:(NSString*)id
faculty:(NSString*)faculty
localImageFilePath:(NSString*)localImageFilePath
position:(NSString*)position
inManagedObjectContext:(NSManagedObjectContext*)context;


+(NSArray*)getAllTeachersInManagedObjectContext:(NSManagedObjectContext*)context;

+(NSArray*)getTeacherWithId:(NSString*)id inManagedObjectContext:(NSManagedObjectContext*)context;

+(void) deleteAllTeachersInManagedObjectoContext:(NSManagedObjectContext*)context;

+(NSArray*)getTeachersWithPosition:(NSString*)position inManagedObjectContext:(NSManagedObjectContext*)context;

+(NSArray*)getAllInManagedObjectContext:(NSManagedObjectContext*)context;

//
//-(instancetype) initTeacherWithName:(NSString *)name id:(NSString*)id imageName:(NSString*)imageName localImageFilePath:(NSString*)localImageFilePath mail:(NSString*)mail faculty:(NSString*)faculty position:(NSString*)position;




@end
