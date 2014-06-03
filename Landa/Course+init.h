//
//  Course+init.h
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Course.h"

@interface Course (init)

+(Course*) initWithName:(NSString*)name
                     id:(NSString*) id
              subjectId:(NSString*)subjectId
              imageName:(NSString*)imageName
                   date:(NSDate*)date
                  place:(NSString*)place
              beginTime:(NSString*)beginTime
                endTime:(NSString*) endTime
 inManagedObjectContext:context;
@end
