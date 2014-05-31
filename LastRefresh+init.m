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
    
    NSEntityDescription *lastRefresh = [NSEntityDescription entityForName:@"LastRefresh" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:lastRefresh];
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
    }
    return lastReftesh;
}

@end
