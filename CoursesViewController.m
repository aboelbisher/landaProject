//
//  CoursesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CoursesViewController.h"
#import "CoursesCollectionViewCell.h"
#import "Course.h"
#import "CoursesDetailsCollectionView.h"
#import "Course+init.h"
#import "LandaAppDelegate.h"

@interface CoursesViewController () <UICollectionViewDataSource , UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *coursesCollectionView;

@property (nonatomic , strong) NSMutableArray * coursesPics;
@property (nonatomic , strong) NSMutableArray * coursesNames;
@property (nonatomic , strong) NSMutableArray * courses; // of Course(s)
@property (nonatomic , strong) NSMutableArray * searchResults; // of Course(s)
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coursesCollectionView.backgroundColor = [UIColor colorWithRed:252/255.0f green:254/255.0f blue:212/255.0f alpha:1.0f];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
//    
//    [context reset];
//    [context save:&error];
    
    [self initCoursesWithContext:context];
    

    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:courseEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    self.courses = [NSMutableArray arrayWithArray:objects];
    
    self.searchResults = [NSMutableArray arrayWithArray:self.courses];
    
       
    
}


-(NSMutableArray*) searchResults
{
    if(!_searchResults)
    {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    [self.searchResults removeAllObjects];
    
    for(Course * course in self.courses)
    {
        NSRange rangeValue = [course.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(rangeValue.length > 0)
        {
            [self.searchResults addObject:course];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        self.searchResults = [NSMutableArray arrayWithArray:self.courses];
    }
    else
    {
        [self filterContentForSearchText:searchText];
    }
    [self.coursesCollectionView reloadData];
    //[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.searchResults count];
}





-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.coursesCollectionView dequeueReusableCellWithReuseIdentifier:@"Course Picture" forIndexPath:indexPath];
    
    if([cell isKindOfClass:[CoursesCollectionViewCell class]])
    {
        CoursesCollectionViewCell* course = (CoursesCollectionViewCell*) cell;
        
        cell.backgroundColor = [UIColor clearColor];
        
        Course * tmpCourse = [self.searchResults objectAtIndex:indexPath.item];
        
        
        course.courseImage.image = [UIImage imageNamed:tmpCourse.imageName];
        course.courseName.text = [NSString stringWithFormat:@"%@" , tmpCourse.name];
        course.courseName.textColor = [UIColor blueColor];
        course.course = tmpCourse;
        
        
         course.courseImage.layer.shadowColor = [UIColor blackColor].CGColor;
         course.courseImage.layer.shadowOffset = CGSizeMake(0, 1);
         course.courseImage.layer.shadowOpacity = 1;
         course.courseImage.layer.shadowRadius = 1.0;
         course.courseImage.clipsToBounds = NO;

    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.searchBar resignFirstResponder];
    if ([segue.identifier isEqualToString:@"show course details"])
    {
        if ([segue.destinationViewController isKindOfClass:[CoursesDetailsCollectionView class]])
        {
            
            if([sender isKindOfClass:[CoursesCollectionViewCell class]])
            {
                
                CoursesCollectionViewCell* sourceController = (CoursesCollectionViewCell*) sender;
                
                CoursesDetailsCollectionView *destinationViewController = (CoursesDetailsCollectionView *)segue.destinationViewController;
                
                destinationViewController.course = sourceController.course;
                
                
            }
            
            
        }
    }
}

-(void) initCoursesWithContext:(NSManagedObjectContext*)context
{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:8];
    [comps setMonth:5];
    [comps setYear:2014];
    [comps setHour:18];
    [comps setMinute:22];
    // [comps setSecond:10];

    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    [Course initWithName:@"algebra" imageName:@"algebra.jpg" date:date inManagedObjectContext:context];
    [Course initWithName:@"chimestry" imageName:@"chimestry.jpg" date:date  inManagedObjectContext:context];
    
    [Course initWithName:@"calculus" imageName:@"calculus.jpg" date:date inManagedObjectContext:context];
    [Course initWithName:@"c" imageName:@"c.png" date:date inManagedObjectContext:context];

}




@end
