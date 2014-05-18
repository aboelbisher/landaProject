//
//  Teacher+init.h
//  Landa
//
//  Created by muhammad abed el razek on 4/15/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Teacher.h"

@interface Teacher (init)

+(Teacher *) initWithName:(NSString*)name
                     mail:(NSString*)mail
                imageName:(NSString*)imageName
   inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
