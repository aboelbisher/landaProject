//
//  Teacher.h
//  Landa
//
//  Created by muhammad abed el razek on 5/20/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Teacher : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * faculty;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
