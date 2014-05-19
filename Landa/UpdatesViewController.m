//
//  UpdatesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "UpdatesViewController.h"
#import "UpdatesTableViewCell.h"
#import "TeachersDetailsViewController.h"
#import "UpdatesContentViewController.h"
#import "Update.h"
#import "Update+init.h"
#import "LandaAppDelegate.h"

//static CGFloat expandedHeight = 200;
//static CGFloat contractedHeight = 74.0;
//static CGRect extendedRect = { 82 , 0 , 184 , 200};
//static CGRect normalRect = { 82 , 0 , 184 , 74 };


@interface UpdatesViewController () <UITableViewDataSource , UITableViewDelegate>

@property(nonatomic ,strong) NSMutableArray * updates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic) int currentSelectedRow;
//@property (nonatomic) int previousSelectedRow;
//@property (nonatomic) int howManyTaps;
//@property (nonatomic) BOOL thereIsAnOpenedCell;

@end

@implementation UpdatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.previousSelectedRow = -1;
//    self.currentSelectedRow = -1;
//    self.howManyTaps = 0;
//    self.thereIsAnOpenedCell = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0f green:254/255.0f blue:255/255.0f alpha:1.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    
//    [context reset];
//    [context save:&error];
    
    
    NSEntityDescription *updateEntityDisc = [NSEntityDescription entityForName:@"Update" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:updateEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    
    
    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]))
    {
        [self initUpdatesWithContext:context];
    }
    
    
    
    self.updates = [NSMutableArray arrayWithArray:objects];

    
    [self fireAlarms];
}


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
        int index = indexPath.item;
        Update * update = [self.updates objectAtIndex:index];
        LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Update" inManagedObjectContext:context]];
        
       // [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %@ AND page_id == %@ AND book_id == %@", contentVal, pageVal, bookVal]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %@" , update.content]];
        NSError* error = nil;
        NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
        NSManagedObject* object = [results firstObject];
        [context deleteObject:object];
        [context save:&error];
        
        [self.updates removeObjectAtIndex:index];
        [self.tableView reloadData];



        //add code here for when you hit delete
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
        
//        NSRange textRange = NSMakeRange(0, update.textView.text.length);
//        [update.textView.textStorage addAttributes:@{ NSStrokeWidthAttributeName : @3,
//                                                      NSStrokeColorAttributeName : [UIColor blueColor] } range:textRange];

//        if(self.thereIsAnOpenedCell)
//        {
//            update.textView.frame = extendedRect;
//            //update.textView.text = [self.updates objectAtIndex:indexPath.item];
//            update.expandImage.image = [UIImage imageNamed:@"expandR.png"];
//         //   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }
//        else
//        {
//            update.textView.frame = normalRect;
//            update.textView.text = [self.updates objectAtIndex:indexPath.item];
//            update.expandImage.image = [UIImage imageNamed:@"expand.png"];
//        }
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

-(void) initUpdatesWithContext:(NSManagedObjectContext*)context
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:8];
    [comps setMonth:5];
    [comps setYear:2014];
    
    // [comps setSecond:10];
    
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [Update initWithContent:@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" date:date inManagedObjectContext:context];
    [Update initWithContent:@"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" date:date inManagedObjectContext:context];
    [Update initWithContent:@"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc" date:date inManagedObjectContext:context];
}

-(void) fireAlarms
{
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if ([tableView indexPathsForSelectedRows].count )
//    {
//        if(self.currentSelectedRow == (int)indexPath.item)
//        {
//            if(self.currentSelectedRow == self.previousSelectedRow)
//            {
//                if(self.howManyTaps %2 == 1)
//                {
//                    self.thereIsAnOpenedCell = NO;
//                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//                    return contractedHeight;
//                }
//                
//                self.thereIsAnOpenedCell = YES;
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//                return expandedHeight;
//            }
//            self.thereIsAnOpenedCell = YES;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//        }
//		if ([[tableView indexPathsForSelectedRows] indexOfObject:indexPath] != NSNotFound)
//        {
//           // [self.tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//			return expandedHeight; // Expanded height
//		}
//        return contractedHeight; // Normal height
//	}
//    return contractedHeight; // Normal height
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(self.currentSelectedRow == -1)
//    {
//        self.currentSelectedRow = (int) indexPath.item;
//    }
//    else
//    {
//        self.previousSelectedRow = self.currentSelectedRow;
//        self.currentSelectedRow = (int)indexPath.item;
//    }
//    if(self.currentSelectedRow == self.previousSelectedRow)
//    {
//        self.howManyTaps++;
//    }
//    else
//    {
//        self.howManyTaps = 0;
//    }
//    
//   // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self updateTableView];
//    
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self updateTableView];
//}
//
//- (void)updateTableView
//{
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//}


@end
