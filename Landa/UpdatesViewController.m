//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"


static NSString * urlDownload = @"http://wabbass.byethost9.com/wordpress/?json=get_posts&count=20";


@interface UpdatesViewController () <UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate , UIActionSheetDelegate , SWTableViewCellDelegate>
{
    BOOL _thersTappedCell;
    NSInteger _tappedCell;
}

@property(nonatomic ,strong) NSMutableArray * updates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation UpdatesViewController

#pragma mark init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [LastRefresh initWithDate:[NSDate date] id:@"12345" inManagedObjectContext:context];

    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];

    self.updates = [NSMutableArray arrayWithArray:objects];
    
    [self sortTableViewArrayWithDates];
    [self sortTableViewArrayWithPinned];
    
    // for application badge and UITabBar Red colors
    NSArray* unreadUpdates = [Update getHasntBeenReadUpdatesInManagedObjectContext:context];
    if([unreadUpdates count] > 0)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[unreadUpdates count]];
        [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    }
    else
    {
        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    }
    
    _thersTappedCell = NO;
    _tappedCell = -1;
}

-(void) viewDidAppear:(BOOL)animated
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray* unreadUpdates = [Update getHasntBeenReadUpdatesInManagedObjectContext:context];

    if([unreadUpdates count] > 0)
    {
        [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    }
    else
    {
        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    }
    
    NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];
    self.updates = [NSMutableArray arrayWithArray:objects];

    [self sortTableViewArrayWithDates];
    [self sortTableViewArrayWithPinned];
    
    [self.tableView reloadData];
}



#pragma mark UItableView



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.updates count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"show update content" sender:[tableView cellForRowAtIndexPath:indexPath]];
}






-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"show update"];
    
    if([cell isKindOfClass:[UpdatesUITableViewCell class]])
    {
        cell.backgroundColor = [UIColor clearColor];
        
        int cellHeigh = cell.bounds.size.height;
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeigh, 320, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];// you can also put image here !!!!!
        [cell.contentView addSubview:separatorLineView];

        Update * tmpUpdate = [self.updates objectAtIndex:indexPath.item];
        
        UpdatesUITableViewCell * updateCell = (UpdatesUITableViewCell*) cell;
        updateCell.update = tmpUpdate;
        updateCell.title.text = [NSString stringWithFormat:@"%@" , tmpUpdate.title];
        NSDate * date = tmpUpdate.date;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        updateCell.dateLabel.text = stringFromDate;
        
        if([tmpUpdate.flagged isEqualToString:@"YES"])
        {
            updateCell.flaggedImage.hidden = NO;
        }
        else
        {
            updateCell.flaggedImage.hidden = YES;
        }
        
        if([tmpUpdate.hasBeenRead isEqualToString:@"NO"])
        {
            updateCell.hasBeenReadImage.hidden = NO;
        }
        else
        {
            updateCell.hasBeenReadImage.hidden = YES;
        }
        
        [formatter setDateFormat:@"HH:mm"];
        NSString* stringFromTime = [formatter stringFromDate:date];
        updateCell.timeLabel.text = stringFromTime;
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//        NSMutableArray *leftUtilityButtons = [NSMutableArray new];


        //swipeRight
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"More"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"Delete"];
        
//        [leftUtilityButtons sw_addUtilityButtonWithColor:
//         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                    title:@"Delete"];
        
//        updateCell.leftUtilityButtons = leftUtilityButtons;
        updateCell.rightUtilityButtons = rightUtilityButtons;
        updateCell.delegate = self;
    }
    return cell;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if(cellIndexPath)
    {
        _tappedCell = cellIndexPath.row;
        
        switch (index)
        {
            case 0:
            {
                NSString* flagString = nil;
                
                Update* updateCell = [self.updates objectAtIndex:_tappedCell];
                
                if(updateCell)
                {
                    if([updateCell.flagged isEqualToString:@"YES"])
                    {
                        flagString =@"mark as unflagged";
                    }
                    else
                    {
                        flagString = @"mark as flagged";
                    }
                }
                
                // More button is pressed
                UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: flagString , nil];
                [shareActionSheet showInView:self.view];
                break;
            }
            case 1:
            {
                // Delete button is pressed
                [self deleteCellAtIndexPath:cellIndexPath];
                break;
            }
            default:
                break;
        }
    }

}


-(void) deleteCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger index = indexPath.item;
    Update * update = [self.updates objectAtIndex:index];
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error = nil;
    
    NSArray* results = [Update getUpdatesWithContent:update.content inManagedObjecContext:context];
    NSManagedObject* object = [results firstObject];
    [context deleteObject:object];
    [context save:&error];
    
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:indexPath];
    
    [self.updates removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    NSArray* unreadUpdates = [Update getHasntBeenReadUpdatesInManagedObjectContext:context];
    
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show update content"])
    {
        if ([segue.destinationViewController isKindOfClass:[UpdatesContentViewController class]])
        {
            if([sender isKindOfClass:[UpdatesUITableViewCell class]])
            {
                UpdatesUITableViewCell* sourceController = (UpdatesUITableViewCell*) sender;
                
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

#pragma mark background fetch and refresh


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
    
    NSArray* lastRefreshArray = [LastRefresh getTheLastRefreshInManagedObjectContext:context];
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
    
    for(id post in posts)
    {
        NSString * title = [post objectForKey:@"title"];
        NSString * content = [post objectForKey:@"content"];
        HTMLParser * parser = [[HTMLParser alloc] initWithString:content error:&error];
        HTMLNode * node = parser.body;
        NSString * tmpContent = [NSString stringWithFormat:@"%@" , node.allContents];
        
        NSString * postDate = [post objectForKey:@"date"];
        NSString * postId = [[post objectForKey:@"id"] stringValue];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:postDate];
        
        if ([date compare:lastRefresh.lastRefresh] == NSOrderedDescending)
        {
            NSLog(@"date is later than lastRefresh.lastRefresh");
            [Update initWithContent:tmpContent title:title date:date postId:postId hasBeenRead:@"NO" inManagedObjectContext:context];
        }
    }


}

-(void) refreshTableView
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray* lastRefreshArray = [LastRefresh getTheLastRefreshInManagedObjectContext:context];
    
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
           
           for(id post in posts)
           {
               NSString * title = [post objectForKey:@"title"];
               NSString * content = [post objectForKey:@"content"];
               
               HTMLParser * parser = [[HTMLParser alloc] initWithString:content error:&error];
               HTMLNode * node = parser.body;
               NSString * tmpContent = [NSString stringWithFormat:@"%@" , node.allContents];
               
               NSString * postDate = [post objectForKey:@"date"];
               NSString * postId = [[post objectForKey:@"id"] stringValue];
               
               NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [formatter dateFromString:postDate];

               NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
               NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
               [offsetComponents setMinute:-3]; // note that I'm setting it to -1
               NSDate *compDate = [gregorian dateByAddingComponents:offsetComponents toDate:lastRefresh.lastRefresh options:0];

               if ([date compare:compDate] == NSOrderedDescending)
               {
                   NSLog(@"date is later than lastRefresh.lastRefresh");
                   [Update initWithContent:tmpContent title:title date:date postId:postId hasBeenRead:@"NO" inManagedObjectContext:context];
               }
           }
       }
       NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];
       
       self.updates = nil;
       self.updates = [NSMutableArray arrayWithArray:objects];
       
       dispatch_async(dispatch_get_main_queue(), ^
       {
           NSArray* unreadUpdates = [Update getHasntBeenReadUpdatesInManagedObjectContext:context];

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

           [self sortTableViewArrayWithDates];
           [self sortTableViewArrayWithPinned];
           [self.tableView reloadData];
       });
 
       lastRefresh.lastRefresh = [NSDate date];
   }];
    [task resume];
    
}


#pragma mark UIActionSheet functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError * error = nil;
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if(buttonIndex == 0)
    {
        Update * update = [self.updates objectAtIndex:_tappedCell];
        Update * coreDataUpdate = nil;
        
        if(update)
        {
            NSArray* objects =  [Update getUpdatesWithContent:update.content inManagedObjecContext:context];
            if([objects count] == 1)
            {
                coreDataUpdate = [objects firstObject];
            }
        }
        
        
        
        
        if([coreDataUpdate.flagged isEqualToString:@"NO"])//mark as flagged
        {
            coreDataUpdate.flagged = @"YES";
        }
        else
        {
            coreDataUpdate.flagged = @"NO";
        }
        
        [context save:&error];
        
        
        NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];
        

        self.updates = [NSMutableArray arrayWithArray:objects];
        [self sortTableViewArrayWithDates];
        [self sortTableViewArrayWithPinned];
        [self.tableView reloadData];
    }
    

}


-(void) sortTableViewArrayWithDates
{
    NSArray *sortedArray;
    sortedArray = [self.updates sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
   {

           NSDate *first = [(Update*)a date];
           NSDate *second = [(Update*)b date];
           return [second compare:first];

   }];
    
    self.updates = nil;
    self.updates = [NSMutableArray arrayWithArray:sortedArray];
}

-(void) sortTableViewArrayWithPinned
{
    NSArray * sortedArray;
    sortedArray = [self.updates sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        NSString * obPinned1 = [(Update*)obj1 flagged];
        NSString * obPinned2 = [(Update*)obj2 flagged];
        
        return [obPinned2 compare:obPinned1];
    }];
    
    
    self.updates = nil;
    self.updates = [NSMutableArray arrayWithArray:sortedArray];
}



@end
