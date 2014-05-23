//
//  TeacherId+init.h
//  Landa
//
//  Created by muhammad abed el razek on 5/23/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeacherId.h"

@interface TeacherId (init)

+(TeacherId *) initWithId:(NSString*)id
beginTime:(NSString*)beginTime
endTime:(NSString*)endTime
inManagedObjectContext:(NSManagedObjectContext*)context;

@end
