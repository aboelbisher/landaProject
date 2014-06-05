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
                      title:(NSString*)title
                       date:(NSDate*)date
                     postId:(NSString *)postId
                hasBeenRead:(NSString *)hasBeenRead
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
        update.title = title;
        update.hasBeenRead = hasBeenRead;
        update.flagged = @"NO";
        [context save:&error];
        
        
    }
    return update;
}

+(NSArray *) getHasntBeenReadUpdatesInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(hasBeenRead = %@)", @"NO"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    return objects;
    
}

+(NSArray *) getAllUpdatesInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSError * error = nil;
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    return objects;
}

+(NSArray *)getUpdatesWithContent:(NSString*)content inManagedObjecContext:(NSManagedObjectContext*)context
{
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Update" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %@" , content]];
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    return results;
}





@end
