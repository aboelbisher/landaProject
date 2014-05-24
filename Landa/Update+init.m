//
//  Update+init.m
//  Landa
//
//  Created by muhammad abed el razek on 5/18/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "Update+init.h"

@implementation Update (init)

+(Update *) initWithContent:(NSString*)content
                     date:(NSDate*)date
                     postId:(NSString *)postId
   inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    Update* update = nil;
    
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(content = %@)", content];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if([objects count] == 0) // if theres no teacher match
    {
        update = [NSEntityDescription insertNewObjectForEntityForName:@"Update" inManagedObjectContext:context];
        update.content = content;
        update.date = date;
        update.postId = postId;
        [context save:&error];
        
        
    }
    return update;
}


@end
