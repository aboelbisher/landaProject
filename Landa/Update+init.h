//
//  Update+init.h
//  Landa
//
//  Created by muhammad abed el razek on 5/18/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Update.h"

@interface Update (init)


+(Update *) initWithContent:(NSString*)content
                       date:(NSDate*)date
                     postId:(NSString *)postId
     inManagedObjectContext:(NSManagedObjectContext*)context;

@end
