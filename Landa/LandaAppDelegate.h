//
//  LandaAppDelegate.h
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "Update.h"
#import "Update+init.h"
#import "UpdatesViewController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "HelpFunc.h"
#import "TeachersViewController.h"


@interface LandaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end




