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
#import "TeacherId+init.h"
#import "TeacherId.h"
#import "Reachability.h"

static NSString* notifyMe = @"YES";
static NSString* dontNotifyMe = @"NO";

@interface CoursesViewController () <UICollectionViewDataSource , UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *coursesCollectionView;

@property (nonatomic , strong) NSMutableArray * coursesPics;
@property (nonatomic , strong) NSMutableArray * coursesNames;
@property (nonatomic , strong) NSMutableArray * courses; // of Course(s)
@property (nonatomic , strong) NSMutableArray * searchResults; // of Course(s)
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coursesCollectionView.backgroundColor = [UIColor clearColor];
    self.spinner.color = [UIColor blackColor];
    self.spinner.hidden = YES;
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
//    
//    [context reset];
    [context save:&error];
    
    
    
    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]))
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(@"There IS NO internet connection");
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"there's no internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        else
        {
            NSLog(@"There IS internet connection");
        }

        [self initCoursesWithContext:context];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:courseEntityDisc];
        NSPredicate *pred =nil;
        [request setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        self.courses = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.courses];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.spinner stopAnimating];
            // self.spinner.hidden = YES;
            [self.coursesCollectionView reloadData];});
    }

 
    
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



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
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
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"http://nlanda.technion.ac.il/LandaSystem/courses.aspx"];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
    {
        if(!error)
        {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:8];
            [comps setMonth:5];
            [comps setYear:2014];
            [comps setHour:18];
            [comps setMinute:22];
            // [comps setSecond:10];
            
            NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
            
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            NSString *webString =[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSString* jsonString = [self makeJsonFromString:webString];
            
            NSError * error;
            NSDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &error];
            
            NSArray * array = [JSON objectForKey:@"courses"];
            
            for(id course in array)
            {
                NSString * place = [course objectForKey:@"place"];
                NSString * tutorId = [course objectForKey:@"tutor_id"];
                NSString * beginTime = [course objectForKey:@"time_from"];
                NSString * endTime = [course objectForKey:@"time_to"];
                NSString * day = [course objectForKey:@"day"];
                NSString * name = [course objectForKey:@"subject_name"];
                
                Course * course = [Course initWithName:name imageName:@"technion.jpg" date:date place:place beginTime:beginTime endTime:endTime inManagedObjectContext:context];
                [context save:&error];
                TeacherId * teacherId = [TeacherId initWithId:tutorId beginTime:beginTime endTime:endTime day:day notify:dontNotifyMe inManagedObjectContext:context];
                [context save:&error];
                
                if(!course)
                {
                    NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:courseEntityDisc];
                    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", name];
                    [request setPredicate:pred];
                    NSError *error;
                    NSArray *courses = [context executeFetchRequest:request error:&error];
                    course = [courses firstObject];
                }
                
                if(teacherId)
                {
                    [course addTeachersObject:teacherId];
                    [context save:&error];
                }
            }

        }
        
        
        NSEntityDescription *courseEntityDisc = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:courseEntityDisc];
        NSPredicate *pred =nil;
        [request setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        self.courses = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.courses];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
             self.spinner.hidden = YES;
            [self.coursesCollectionView reloadData];});

    }];
    [task resume];
    
    
}



-(NSString*) makeJsonFromString:(NSString*)string
{
    NSInteger first = 0;
    NSInteger last = 0;
    // int length = 0;
    int count = 0;
    
    for (NSInteger charIdx = 0; charIdx < string.length ; charIdx++)
    {
        if([string characterAtIndex:charIdx] == '{')
        {
            first = charIdx;
            break;
        }
    }
    
    
    for (NSInteger charIdx = 0; charIdx < string.length ; charIdx++)
    {
        if([string characterAtIndex:charIdx] == '}')
        {
            count-- ;
            if (count == 0)
            {
                last = charIdx;
                break;
            }
        }
        if([string characterAtIndex:charIdx] == '{')
        {
            count++;
        }
        
    }
    NSRange range = NSMakeRange(first, last - first + 1);
    NSString * newString = [string substringWithRange:range];
    return newString;
}

    
    




@end
