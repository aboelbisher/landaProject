//
//  Course.h
//  Landa
//
//  Created by muhammad abed el razek on 5/24/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TeacherId;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * beginTime;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSSet *teachers;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addTeachersObject:(TeacherId *)value;
- (void)removeTeachersObject:(TeacherId *)value;
- (void)addTeachers:(NSSet *)values;
- (void)removeTeachers:(NSSet *)values;

@end
