//
//  LandaAppDelegate.m
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "LandaAppDelegate.h"

@class UpdatesViewController;





#import <Parse/Parse.h>


static NSString* notifactionsWebStart = @"http://wabbass.byethost9.com/wordpress/?p=";
static NSString* notifcationsWebEnd = @"&json=1";

@interface LandaAppDelegate()



@end


@implementation LandaAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark background fetch

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSDate *fetchStart = [NSDate date];
    
    //UpdatesViewController *viewController = (UpdatesViewController *)self.window.rootViewController;
    UpdatesViewController * updatesViewController = [[UpdatesViewController alloc] init];
    
    [updatesViewController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result)
    {
         completionHandler(result);
     }];
    
    TeachersViewController * teachersViewController = [[TeachersViewController alloc] init];
    
    [teachersViewController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result)
     {
         completionHandler(result);

         
     }];
    
    
    NSDate *fetchEnd = [NSDate date];
    NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
    NSLog(@"Background Fetch Duration: %f seconds", timeElapsed);
    
    
}


#pragma mark - Core Data stack


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}



- (void)application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    int badgeNum = (int)[[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum + 1];
        
    NSString * urlString = notifactionsWebStart;
    NSString*  postId = [[userInfo valueForKey:@"post_id"] stringValue];
    if(!postId) // got notification from the wrong place :D
    {
        return;
    }
    
    urlString = [urlString stringByAppendingString:postId];
    urlString = [urlString stringByAppendingString:notifcationsWebEnd];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if(!urlData)
    {
        return;
    }
    NSString *webString =[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSString* jsonString = [HelpFunc makeJsonFromString:webString];
    
    NSError * error;
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];

    NSDictionary * post = [JSON objectForKey:@"post"];
    
    NSString * dateString = [post valueForKey:@"date"];
    NSString * content = [post valueForKey:@"content"];
    NSString * postUrl = [post objectForKey:@"url"];
    HTMLParser * parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode * node = parser.body;
    NSString * tmpContent = [NSString stringWithFormat:@"%@" , node.allContents];
    
    NSString * title = [post objectForKey:@"title"];
    
    HTMLParser * titleParser = [[HTMLParser alloc] initWithString:title error:&error];
    HTMLNode * titleNode = titleParser.body;
    NSString * tmpTitle = [NSString stringWithFormat:@"%@" , titleNode.allContents];

    content = [content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    
    [Update initWithContent:tmpContent title:tmpTitle date:date postId:postId hasBeenRead:@"NO" htmlContent:content url:postUrl inManagedObjectContext:self.managedObjectContext ];
    [self.managedObjectContext save:&error];
    [PFPush handlePush:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    UpdatesViewController * updatesViewController = [[UpdatesViewController alloc] init];
    
    [updatesViewController refreshTableView];
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor myGreenColor]];
    
    NSArray * objects = [Update getHasntBeenReadUpdatesInManagedObjectContext:self.managedObjectContext];
    
    if([objects count] > 0)
    {
        [[UITabBar appearance] setTintColor:[UIColor redColor]];
    }
        [Parse setApplicationId:@"lyULxHfJJVm7xq7Q9PBAKzEzUAbrRHFWxGjnPDjW"
                  clientKey:@"OtBV7Pi2miRuYBKHri3eYEfeOZeqYVOPLFBXqfp9"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    UpdatesViewController * updatesViewController = [[UpdatesViewController alloc] init];
//    
//    [updatesViewController refreshTableView];

    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
