//
//  Course+init.h
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Course.h"

@interface Course (init)

+(Course*) initWithName:(NSString*)name imageName:(NSString*)imageName date:(NSDate*)date inManagedObjectContext:context;
@end
