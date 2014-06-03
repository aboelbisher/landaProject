//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"


static NSString * urlDownload = @"http://wabbass.byethost9.com/wordpress/?json=10";


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
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    
    [LastRefresh initWithDate:[NSDate date] id:@"12345" inManagedObjectContext:context];

    
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
    NSArray *sortedArray;
    sortedArray = [self.updates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Update*)a date];
        NSDate *second = [(Update*)b date];
        return [second compare:first];
    }];
    
    self.updates = nil;
    self.updates = [NSMutableArray arrayWithArray:sortedArray];    
    
    // for application badge and UITabBar Red colors
    updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    pred =[NSPredicate predicateWithFormat:@"(hasBeenRead = %@)", @"NO"];
    [request setPredicate:pred];
    NSArray * unreadUpdates = [context executeFetchRequest:request
                                                     error:&error];
    if([unreadUpdates count] > 0)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[unreadUpdates count]];
        [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    }
    else
    {
        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    }

}

-(void) viewDidAppear:(BOOL)animated
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(hasBeenRead = %@)", @"NO"];
    [request setPredicate:pred];
    NSArray * unreadUpdates = [context executeFetchRequest:request
                                                                error:&error];
  //  UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:2];

    if([unreadUpdates count] > 0)
    {
        [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    }
    else
    {
        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    }
    

    
    updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    self.updates = [NSMutableArray arrayWithArray:objects];
    
    NSArray *sortedArray;
    sortedArray = [self.updates sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
    {
        NSDate *first = [(Update*)a date];
        NSDate *second = [(Update*)b date];
        return [second compare:first];
    }];
    
    self.updates = nil;
    self.updates = [NSMutableArray arrayWithArray:sortedArray];
    
    
    [self.tableView reloadData];

}


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
        

        NSError * error = nil;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Update" inManagedObjectContext:context]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %@" , update.content]];
        NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
        NSManagedObject* object = [results firstObject];
        [context deleteObject:object];
        [context save:&error];
        
        NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
        [indexPaths addObject:indexPath];
        

        
        [self.updates removeObjectAtIndex:index];
        
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:updateEntityDisc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(hasBeenRead = %@)", @"NO"];
        [request setPredicate:pred];
        NSArray * unreadUpdates = [context executeFetchRequest:request
                                                         error:&error];
        //  UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:2];
        
        if([unreadUpdates count] > 0)
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[unreadUpdates count]];
            [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
        }
        else
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

            [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        }

    }
}




-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"show update"];
    
    if([cell isKindOfClass:[UpdatesTableViewCell class]])
    {
        
        cell.backgroundColor = [UIColor clearColor];
        
        int cellHeigh = cell.bounds.size.height;
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeigh, 320, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];// you can also put image here !!!!!
        [cell.contentView addSubview:separatorLineView];

        
        Update * tmpUpdate = [self.updates objectAtIndex:indexPath.item];
        
        UpdatesTableViewCell * update = (UpdatesTableViewCell*) cell;
        //update.text.text = [NSString stringWithFormat:@"%@" , tmpUpdate.content];
        update.update = tmpUpdate;
        update.title.text = [NSString stringWithFormat:@"%@" , tmpUpdate.title];
        NSDate * date = tmpUpdate.date;
        //update.dateLabel.text = [[NSString stringWithFormat:@"%@" , [tmpUpdate.date ]
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
   
        update.dateLabel.text = stringFromDate;
        
//        NSNumber * stam = tmpUpdate.hasBeenRead;
//        NSNumber * stam1 = [NSNumber numberWithBool:NO];
        
        if([tmpUpdate.hasBeenRead isEqualToString:@"NO"])
        {
            update.hasBeenReadImage.hidden = NO;
        }
        else
        {
            update.hasBeenReadImage.hidden = YES;
        }
        
        
        [formatter setDateFormat:@"HH:mm"];
        NSString* stringFromTime = [formatter stringFromDate:date];
        update.timeLabel.text = stringFromTime;
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
                
                if([sourceController.update.hasBeenRead isEqualToString:@"NO"])
                {
                    int badgeNum = (int)[[UIApplication sharedApplication] applicationIconBadgeNumber];
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum - 1];
                }
                
                UpdatesContentViewController *tsvc = (UpdatesContentViewController *)segue.destinationViewController;
                
                NSString* updateContentText = sourceController.update.content;

                
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
    NSError * error = nil;
    
    NSEntityDescription *lastRefreshEntity = [NSEntityDescription entityForName:@"LastRefresh" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:lastRefreshEntity];
    NSPredicate* pred =[NSPredicate predicateWithFormat:@"(id = %@)", @"12345"];
    [request setPredicate:pred];
    NSArray *lastRefreshArray = [context executeFetchRequest:request
                                                       error:&error];
    
    LastRefresh * lastRefresh = [lastRefreshArray firstObject];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSURL *url = [NSURL URLWithString:urlDownload];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
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
        content = [self decodeString:content];
        title = [self decodeString:title];
        NSString * postDate = [post objectForKey:@"date"];
        NSString * postId = [[post objectForKey:@"id"] stringValue];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:postDate];
        
        if ([date compare:lastRefresh.lastRefresh] == NSOrderedDescending)
        {
            NSLog(@"date is later than lastRefresh.lastRefresh");
            [Update initWithContent:content title:title date:date postId:postId hasBeenRead:@"NO" inManagedObjectContext:context];
            
        }
        
        //[context save:&error];

        
        //[Update initWithContent:content title:title date:date postId:postId inManagedObjectContext:context];
    }


}

-(void) refreshTableView
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error = nil;
    
    NSEntityDescription *lastRefreshEntity = [NSEntityDescription entityForName:@"LastRefresh" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:lastRefreshEntity];
    NSPredicate* pred =[NSPredicate predicateWithFormat:@"(id = %@)", @"12345"];
    [request setPredicate:pred];
    NSArray *lastRefreshArray = [context executeFetchRequest:request
                                                       error:&error];
    
    LastRefresh * lastRefresh = [lastRefreshArray firstObject];
    

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSURL *url = [NSURL URLWithString:urlDownload];
    
    NSURLRequest * downloadRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:downloadRequest completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
   {
       dispatch_async(dispatch_get_main_queue(), ^
      {
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          
      });
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
               content = [self decodeString:content];
               title = [self decodeString:title];
               NSString * postDate = [post objectForKey:@"date"];
               NSString * postId = [[post objectForKey:@"id"] stringValue];
               
               NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [formatter dateFromString:postDate];
               
               if ([date compare:lastRefresh.lastRefresh] == NSOrderedDescending)
               {
                   NSLog(@"date is later than lastRefresh.lastRefresh");
                   [Update initWithContent:content title:title date:date postId:postId hasBeenRead:@"NO" inManagedObjectContext:context];
               }
           }
       }
       //[context save:&error];
       
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
           NSError * error = nil;
           NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
           NSFetchRequest *request = [[NSFetchRequest alloc] init];
           [request setEntity:updateEntityDisc];
           NSPredicate *pred =[NSPredicate predicateWithFormat:@"(hasBeenRead = %@)", @"NO"];
           [request setPredicate:pred];
           NSArray * unreadUpdates = [context executeFetchRequest:request
                                                            error:&error];
           //  UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:2];
           
           if([unreadUpdates count] > 0)
           {
               [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[unreadUpdates count]];
               [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
           }
           else
           {
               [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
               [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
               
           }
           [self.refreshControl endRefreshing];

           NSArray *sortedArray;
           sortedArray = [self.updates sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
           {
               NSDate *first = [(Update*)a date];
               NSDate *second = [(Update*)b date];
               return [second compare:first];
           }];
           
           self.updates = nil;
           self.updates = [NSMutableArray arrayWithArray:sortedArray];
           
           [self.tableView reloadData];
       });
 
       lastRefresh.lastRefresh = [NSDate date];
   }];
    [task resume];
    
}


-(NSString *)decodeString:(NSString*)string
{
    NSString * newString = [string stringByReplacingOccurrencesOfString:@"&#8216;" withString:@"'"];
    newString = [newString stringByReplacingOccurrencesOfString:@"&#8221;" withString:@"\""];
    newString = [newString stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
    newString = [newString stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
    
    return newString;
}


@end
