//
//  CoursesViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/6/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CoursesViewController.h"

static NSString* COURSES_URL = @"http://nlanda.technion.ac.il/LandaSystem/courses.aspx";


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

#pragma mark init

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coursesCollectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.searchBar.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    
    
    self.spinner.color = [UIColor whiteColor];
    self.spinner.hidden = YES;
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;

    [context save:&error];
    
    
    
    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]))
    {
        [LastRefresh initWithDate:[NSDate date] id:@"12345" inManagedObjectContext:context];

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
        NSArray* objects = [Course getAllCoursesInManagedObjectContext:context];
        if ([objects count] == 0)
        {
            [self initCoursesWithContext:context];
        }
        self.courses = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.courses];
        
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.coursesCollectionView reloadData];
        });
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


#pragma mark UISearchBar

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



#pragma mark UICollectionView functions


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.coursesCollectionView dequeueReusableCellWithReuseIdentifier:@"Course Picture" forIndexPath:indexPath];
    
    if([cell isKindOfClass:[CoursesCollectionViewCell class]])
    {
        CoursesCollectionViewCell* course = (CoursesCollectionViewCell*) cell;
        
        cell.backgroundColor = [UIColor clearColor];
        
        Course * tmpCourse = [self.searchResults objectAtIndex:indexPath.item];
        
        UIImage* image = [HelpFunc getImageFromFileWithId:tmpCourse.subjectId];
        if(!image)
        {
            course.courseImage.image = [UIImage imageNamed:@"landaIcon.png"];
        }
        else
        {
            course.courseImage.image = image;
        }
        
        course.courseName.text = [NSString stringWithFormat:@"%@" , tmpCourse.name];
        course.courseName.textColor = [UIColor whiteColor];
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
    
    NSURL *url = [NSURL URLWithString:COURSES_URL];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
    {
        if(!error)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^
           {
               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
               
           });
            
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            NSString *webString =[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSString* jsonString = [HelpFunc makeJsonFromString:webString];
            
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
                NSString * id = [course objectForKey:@"id"];
                NSString * subjectid = [course objectForKey:@"subject_id"];
                
                
                NSString * urlString = [NSString stringWithFormat:@"http://nlanda.technion.ac.il/LandaSystem/pics/"];
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.png" , subjectid]];
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                [HelpFunc writeImageToFileWithId:subjectid data:data];

                Course * course = [Course initWithName:name id:id subjectId:subjectid imageName:[NSString stringWithFormat:@"%@.png" , subjectid] place:place beginTime:beginTime endTime:endTime inManagedObjectContext:context];
                [context save:&error];
                TeacherId * teacherId = [TeacherId initWithId:tutorId beginTime:beginTime endTime:endTime day:day notify:dontNotifyMe inManagedObjectContext:context];
                [context save:&error];
                
                if(!course)
                {
                    NSArray* courses = [Course getCoursesWithName:name inManagedObjectContext:context];
                    course = [courses firstObject];
                }
                
                if(teacherId)
                {
                    [course addTeachersObject:teacherId];
                    [context save:&error];
                }
            }

        }
        NSArray* objects = [Course getAllCoursesInManagedObjectContext:context];
        
        self.courses = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.courses];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
             self.spinner.hidden = YES;
            [self.coursesCollectionView reloadData];});

    }];
    [task resume];
}


- (IBAction)showInfo:(id)sender
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"About"];
    [self presentViewController:vc animated:YES completion:nil];

}

    




@end
