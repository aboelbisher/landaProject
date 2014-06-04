//
//  LastRefresh+init.h
//  Landa
//
//  Created by muhammad abed el razek on 6/1/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "LastRefresh.h"

@interface LastRefresh (init)

+(LastRefresh *) initWithDate:(NSDate*)date
                           id:(NSString*)id
inManagedObjectContext:(NSManagedObjectContext*)context;

+(NSArray*) getTheLastRefreshInManagedObjectContext:(NSManagedObjectContext *)context;

@end
