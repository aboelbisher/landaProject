//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"



//static CGFloat expandedHeight = 200;
//static CGFloat contractedHeight = 74.0;
//static CGRect extendedRect = { 82 , 0 , 184 , 200};
//static CGRect normalRect = { 82 , 0 , 184 , 74 };


@interface UpdatesViewController () <UITableViewDataSource , UITableViewDelegate>

@property(nonatomic ,strong) NSMutableArray * updates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

//@property (nonatomic) int currentSelectedRow;
//@property (nonatomic) int previousSelectedRow;
//@property (nonatomic) int howManyTaps;
//@property (nonatomic) BOOL thereIsAnOpenedCell;

@end

@implementation UpdatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0f green:254/255.0f blue:255/255.0f alpha:1.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    NSDate * now = [NSDate date];
    
    //[Update initWithContent:@"teeeeeez" date:now postId:@"823" inManagedObjectContext:context];

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
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 4;
//}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.updates count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.

    return YES;
}

// Override to support editing the table view.
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
        
        [self.updates removeObjectAtIndex:index];
        [self.tableView reloadData];

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
    NSLog(@"backGrounf teze");
    completionHandler(UIBackgroundFetchResultNewData);

}

-(void)refreshData
{

}

@end
