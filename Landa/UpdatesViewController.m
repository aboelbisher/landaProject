//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"


static NSString * urlDownload = @"http://wabbass.byethost9.com/wordpress/?json=get_recent_posts";


@interface UpdatesViewController () <UITableViewDataSource , UITableViewDelegate>

@property(nonatomic ,strong) NSMutableArray * updates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation UpdatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0f green:254/255.0f blue:255/255.0f alpha:1.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];

    self.updates = [NSMutableArray arrayWithArray:objects];

}

-(void) viewDidAppear:(BOOL)animated
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    self.updates = [NSMutableArray arrayWithArray:objects];
    [self.tableView reloadData];

}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return (CGFloat)150;
//}




-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.updates count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger index = indexPath.item;
        Update * update = [self.updates objectAtIndex:index];
        LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Update" inManagedObjectContext:context]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %@" , update.content]];
        NSError* error = nil;
        NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
        NSManagedObject* object = [results firstObject];
        [context deleteObject:object];
        [context save:&error];
        
        NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
        [indexPaths addObject:indexPath];
        

        
        [self.updates removeObjectAtIndex:index];
        
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];


    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"show update"];
    
    if([cell isKindOfClass:[UpdatesTableViewCell class]])
    {
        
        cell.backgroundColor = [UIColor clearColor];
        
        Update * tmpUpdate = [self.updates objectAtIndex:indexPath.item];
        
        UpdatesTableViewCell * update = (UpdatesTableViewCell*) cell;
        update.text.text = [NSString stringWithFormat:@"%@" , tmpUpdate.content];
        update.update = tmpUpdate;
        update.title.text = [NSString stringWithFormat:@"%@" , tmpUpdate.title];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show update content"])
    {
        if ([segue.destinationViewController isKindOfClass:[UpdatesContentViewController class]])
        {
            if([sender isKindOfClass:[UpdatesTableViewCell class]])
            {
                UpdatesTableViewCell* sourceController = (UpdatesTableViewCell*) sender;
                
                UpdatesContentViewController *tsvc = (UpdatesContentViewController *)segue.destinationViewController;
                
                NSString* updateContentText = sourceController.text.text;

                
                tsvc.updateContentText = updateContentText;
                tsvc.update = sourceController.update;
            }
            
        }
    }
}

-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self refreshData];
    completionHandler(UIBackgroundFetchResultNewData);

}

-(void)refreshData
{

    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    NSURL *url = [NSURL URLWithString:urlDownload];
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError * error;
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    
    
    NSArray * posts = [JSON objectForKey:@"posts"];
    
    //    NSMutableArray * updates = [[NSMutableArray alloc] init];
    
    for(id post in posts)
    {
        NSString * title = [post objectForKey:@"title"];
        NSString * content = [post objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        NSString * postDate = [post objectForKey:@"date"];
        NSString * postId = [[post objectForKey:@"id"] stringValue];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:postDate];
        
        [Update initWithContent:content title:title date:date postId:postId inManagedObjectContext:context];
    }


}

-(void) refreshTableView
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSURL *url = [NSURL URLWithString:urlDownload];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
   {
       if(!error)
       {
           NSData *urlData = [NSData dataWithContentsOfURL:url];
           NSString *jsonString =[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
           
           NSError * error;
           NSDictionary *JSON =
           [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: &error];
           
           NSArray * posts = [JSON objectForKey:@"posts"];
           
           //    NSMutableArray * updates = [[NSMutableArray alloc] init];
           
           for(id post in posts)
           {
               NSString * title = [post objectForKey:@"title"];
               NSString * content = [post objectForKey:@"content"];
               content = [content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
               content = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
               NSString * postDate = [post objectForKey:@"date"];
               NSString * postId = [[post objectForKey:@"id"] stringValue];
               
               NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [formatter dateFromString:postDate];
               
               [Update initWithContent:content title:title date:date postId:postId inManagedObjectContext:context];
           }
       }
       
       NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
       NSFetchRequest *request = [[NSFetchRequest alloc] init];
       [request setEntity:updateEntityDisc];
       NSPredicate *pred =nil;
       [request setPredicate:pred];
       NSArray *objects = [context executeFetchRequest:request error:&error];
       
       self.updates = nil;
       
       self.updates = [NSMutableArray arrayWithArray:objects];
       
       dispatch_async(dispatch_get_main_queue(), ^
       {
           [self.refreshControl endRefreshing];
           [self.tableView reloadData];
       });
   }];
    [task resume];
    

    
}

@end
