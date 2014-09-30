//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"


static NSString * urlDownload = @"http://glanda.technion.ac.il/wordpress/?json=get_posts&count=20";


@interface UpdatesViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate , UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate , UIActionSheetDelegate , SWTableViewCellDelegate >
{
    BOOL _thersTappedCell;
    NSInteger _tappedCell;
}

@property(nonatomic ,strong) NSMutableArray * updates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (weak , nonatomic) NSURLSession * session;


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
    
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDelegate:)];
//    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipeLeft];
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightDelegate:)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRight];
    
    [HelpFunc checkForInternet];

}


//- (IBAction)swipeRightDelegate:(id)sender
//{
//    NSInteger destIndex = 1;
//    // Get views. controllerIndex is passed in as the controller we want to go to.
//    UIView * fromView = self.view;
//    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:destIndex] view];
//    
//    // Transition using a page curl.
//    [UIView transitionFromView:fromView
//                        toView:toView
//                      duration:0.5
//                       options:(UIViewAnimationOptionTransitionFlipFromLeft)
//                    completion:^(BOOL finished)
//     {
//         if (finished)
//         {
//             self.tabBarController.selectedIndex = destIndex;
//         }
//     }];
//    
//}
//
//
//
//- (IBAction)swipeLeftDelegate:(id)sender
//{
//    NSInteger destIndex = 0;
//    // Get views. controllerIndex is passed in as the controller we want to go to.
//    UIView * fromView = self.view;
//    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:destIndex] view];
//    
//    // Transition using a page curl.
//    [UIView transitionFromView:fromView
//                        toView:toView
//                      duration:0.5
//                       options:(UIViewAnimationOptionTransitionFlipFromRight)
//                    completion:^(BOOL finished)
//     {
//         if (finished)
//         {
//             self.tabBarController.selectedIndex = destIndex;
//         }
//     }];
//}


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


//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    //1. Setup the CATransform3D structure
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    
//    
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
//    
//}



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
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];


        //swipeRight

        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"מחק"];
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                   title:@"עוד"];
        updateCell.leftUtilityButtons = leftUtilityButtons;
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

                [self deleteCellAtIndexPath:cellIndexPath];
                break;
            }
            default:
                break;
        }
    }

}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if(cellIndexPath)
    {
        _tappedCell = cellIndexPath.row;
        Update * update = [self.updates objectAtIndex:_tappedCell];
        NSString * flagOrUnflag = nil;
        NSString * readOrUnread = nil;
        
        if([update.flagged isEqualToString:@"YES"])
        {
            flagOrUnflag = @"בטל סימון בדגל";
        }
        else
        {
            flagOrUnflag = @"סמן בדגל";
        }
        if([update.hasBeenRead isEqualToString:@"YES"])
        {
            readOrUnread = @"סמן כלא נקרא";
        }
        else
        {
            readOrUnread = @"סמן כנקרא";
        }

        
        if( index == 0)
        {
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"ביטול" destructiveButtonTitle:nil otherButtonTitles:
                                    flagOrUnflag,
                                    readOrUnread,
                                    nil];
            popup.tag = 1;
            [popup showInView:[UIApplication sharedApplication].keyWindow];

        }

    }
    
}

#pragma mark UIActionSheet functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError * error = nil;
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Update * update = [self.updates objectAtIndex:_tappedCell];
    Update * coreDataUpdate = nil;
    NSArray* objects =  [Update getUpdatesWithContent:update.content inManagedObjecContext:context];
    if([objects count] == 1)
    {
        coreDataUpdate = [objects firstObject];
    }
    
    if( update)
    {
        if(buttonIndex == 0) // flag or not Flagged
        {
            if([coreDataUpdate.flagged isEqualToString:@"NO"])//mark as flagged
            {
                coreDataUpdate.flagged = @"YES";
            }
            else
            {
                coreDataUpdate.flagged = @"NO";
            }
            
            [context save:&error];
            
        }
        
        if (buttonIndex == 1) // read or Unread
        {
            if([coreDataUpdate.hasBeenRead isEqualToString:@"YES"])
            {
                coreDataUpdate.hasBeenRead = @"NO";
            }
            else
            {
                coreDataUpdate.hasBeenRead = @"YES";
            }
        }
        
        
        NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];
        
        
        self.updates = [NSMutableArray arrayWithArray:objects];
        [self sortTableViewArrayWithDates];
        [self sortTableViewArrayWithPinned];
        [self.tableView reloadData];
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
        NSString * postUrl = [post objectForKey:@"url"];
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
            [Update initWithContent:tmpContent title:title date:date postId:postId hasBeenRead:@"NO" htmlContent:content url:postUrl inManagedObjectContext:context];
        }
        else
        {
            NSLog(@"NOOOOOOOOOOOO");
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
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

    });
    

}

//- (NSURLSession *)backgroundSession
//{
//    /**
//     * Using dispatch_once here ensures that multiple background sessions with the same identifier are not
//     * created in this instance of the application. If you want to support multiple background sessions
//     * within a single process, you should create each session with its own identifier.
//     */
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"ch.icoretech.BackgroundTransferSession"];
//        [configuration set...];
//        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//    });
//    return session;
//}

-(void) refreshTableView
{
    [self.downloadTask cancel];
    

    if(![HelpFunc checkForInternet])
    {
        return;
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
//    self.downloadTask = Nil;
//    self.session = nil;
//    
//    
//    NSURL *url = [NSURL URLWithString:@"http://glanda.technion.ac.il/wordpress/?json=get_posts&count=20"];
//    NSURLRequest * downloadRequest = [NSURLRequest requestWithURL:url];
//    self.downloadTask = [self.session downloadTaskWithRequest:downloadRequest];
//    [self.downloadTask resume];
    

    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray* lastRefreshArray = [LastRefresh getTheLastRefreshInManagedObjectContext:context];
    
    LastRefresh * lastRefresh = [lastRefreshArray firstObject];
 
 
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
               NSString * postUrl = [post objectForKey:@"url"];
               
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
                   NSLog(@"date is later than lastRefresh.lastRefresh1");
                   [Update initWithContent:tmpContent title:title date:date postId:postId hasBeenRead:@"NO" htmlContent:content url:postUrl inManagedObjectContext:context];
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
           NSLog(@"Got here 2");
           [self.refreshControl endRefreshing];

           [self sortTableViewArrayWithDates];
           [self sortTableViewArrayWithPinned];
           [self.tableView reloadData];
       });
       
       NSLog(@"got Here!1");
 
       lastRefresh.lastRefresh = [NSDate date];
   }];
    [task resume];
    [session finishTasksAndInvalidate];
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

#pragma mark NSURLSession functions


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    NSData *urlData = [NSData dataWithContentsOfURL:location];

    dispatch_async(dispatch_get_main_queue(), ^
   {
       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
       if(![HelpFunc checkForInternet])
       {
           return ;
       }
           NSLog(@"finished");
           LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
           NSManagedObjectContext *context = [appDelegate managedObjectContext];
           NSArray* lastRefreshArray = [LastRefresh getTheLastRefreshInManagedObjectContext:context];
           
           LastRefresh * lastRefresh = [lastRefreshArray firstObject];

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
               NSString * postUrl = [post objectForKey:@"url"];
               
               HTMLParser * parser = [[HTMLParser alloc] initWithString:content error:&error];
               HTMLNode * node = parser.body;
               NSString * tmpContent = [NSString stringWithFormat:@"%@" , node.allContents];
               
               NSString * postDate = [post objectForKey:@"date"];
               NSString * postId = [[post objectForKey:@"id"] stringValue];
               
               NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [formatter dateFromString:postDate];
               
               //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
               NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
               [offsetComponents setMinute:-3]; // note that I'm setting it to -1
               //NSDate *compDate = [gregorian dateByAddingComponents:offsetComponents toDate:lastRefresh.lastRefresh options:0];
               
               // if ([date compare:compDate] == NSOrderedDescending)
               // {
               NSLog(@"date is later than lastRefresh.lastRefresh1");
               [Update initWithContent:tmpContent title:title date:date postId:postId hasBeenRead:@"NO" htmlContent:content url:postUrl inManagedObjectContext:context];
               //  }
           }
       
       NSArray* objects = [Update getAllUpdatesInManagedObjectContext:context];
       
       self.updates = nil;
       self.updates = [NSMutableArray arrayWithArray:objects];
       
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
       NSLog(@"Got here 2");
       [self.refreshControl endRefreshing];
       
       [self sortTableViewArrayWithDates];
       [self sortTableViewArrayWithPinned];
       [self.tableView reloadData];
       lastRefresh.lastRefresh = [NSDate date];
   });
    // Invalidate Session
    [session finishTasksAndInvalidate];
}

- (NSURLSession *)session
{
    if (!_session)
    {
        // Create Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // Create Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    return _session;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"progressssssss ==   %f" , progress);
}




- (IBAction)showInfo:(id)sender
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"About"];
    [self presentViewController:vc animated:YES completion:nil];

}


@end
