//
//  LastRefresh+init.m
//  Landa
//
//  Created by muhammad abed el razek on 6/1/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "LastRefresh+init.h"

@implementation LastRefresh (init)

+(LastRefresh *) initWithDate:(NSDate*)date
                           id:(NSString*)id
inManagedObjectContext:(NSManagedObjectContext*)context
{
    LastRefresh * lastReftesh = nil;
    
    NSEntityDescription *lastRefreshEntity = [NSEntityDescription entityForName:@"LastRefresh" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:lastRefreshEntity];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)", id];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if([objects count] == 0)
    {
        lastReftesh = [NSEntityDescription insertNewObjectForEntityForName:@"LastRefresh" inManagedObjectContext:context];
        NSDate * now = [NSDate date];
        lastReftesh.lastRefresh = now;
        lastReftesh.id = id;
        [context save:&error];
    }
    return lastReftesh;
}

+(NSArray*) getTheLastRefreshInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSError * error = nil;
    NSEntityDescription *lastRefreshEntity = [NSEntityDescription entityForName:@"LastRefresh" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:lastRefreshEntity];
    NSPredicate* pred =[NSPredicate predicateWithFormat:@"(id = %@)", @"12345"];
    [request setPredicate:pred];
    NSArray *lastRefreshArray = [context executeFetchRequest:request
                                                       error:&error];
    
    return lastRefreshArray;
}


@end
