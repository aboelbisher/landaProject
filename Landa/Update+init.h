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
                      title:(NSString*)title
                       date:(NSDate*)date
                     postId:(NSString *)postId
                hasBeenRead:(NSString *)hasBeenRead
     inManagedObjectContext:(NSManagedObjectContext*)context;

@end
