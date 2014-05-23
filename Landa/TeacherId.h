//
//  TeacherId.h
//  Landa
//
//  Created by muhammad abed el razek on 5/23/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface TeacherId : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * beginTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) Course *course;

@end
