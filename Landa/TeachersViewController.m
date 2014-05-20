//
//  TeachersViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeachersViewController.h"
#import "TeacherCollectionViewCell.h"
#import "TeachersDetailsViewController.h"
#import "Teacher.h"
#import "Teacher+init.h"
#import "LandaAppDelegate.h"

static NSString* TEACHERS_URL = @"http://nlanda.technion.ac.il/LandaSystem/tutors.aspx";

@interface TeachersViewController () <UICollectionViewDataSource , UICollectionViewDelegate ,NSURLSessionDelegate, NSURLSessionDownloadDelegate>
{
    NSURLSession* _session;
}

//@property(nonatomic , strong) NSArray * teachersPic;
@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
@property(nonatomic , strong) NSMutableArray * teachers; // of Teacher(s)
@property (nonatomic , strong) NSMutableArray * searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
//@property (strong , nonatomic) NSManagedObjectContext * context;

@end

@implementation TeachersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.teachersCollectionView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    [self.teachersCollectionView setContentOffset:CGPointMake(0, 44) animated:YES];
    
    
    self.teachers = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
//    
//    [context reset];
//    [context save:&error];
//
//
//    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:teacherEntityDisc];
//    NSPredicate *pred =nil;
//    [request setPredicate:pred];
//    NSArray *objects = [context executeFetchRequest:request
//                                              error:&error];
        

    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]))
    {
        [self initTeachersWithContext:context];
    }

    
    
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    
    
    
    self.teachers = [NSMutableArray arrayWithArray:objects];
    self.searchResults = [NSMutableArray arrayWithArray:self.teachers];
    
    

}

- (NSURLSession *)session
{
    if (!_session)
    {
        // Create Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Create Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"did finish Writing");
    NSData *data = [NSData dataWithContentsOfURL:location];
//    NSLog(@"data = %@" , data);
    
    NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@" , jsonString);
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
//                       [self.cancelButton setHidden:YES];
//                       [self.progressView setHidden:YES];
//                       [self.imageView setImage:[UIImage imageWithData:data]];
                   });
    
    // Invalidate Session
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"did resume");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}



//-(NSMutableArray*) searchResults
//{
//    if(!_searchResults)
//    {
//        _searchResults = [[NSMutableArray alloc] init];
//    }
//    return _searchResults;
//}


- (void)filterContentForSearchText:(NSString*)searchText
{
    [self.searchResults removeAllObjects];
    
    for(Teacher * teacher in self.teachers)
    {
        NSRange rangeValue = [teacher.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(rangeValue.length > 0)
        {
            [self.searchResults addObject:teacher];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        self.searchResults = [NSMutableArray arrayWithArray:self.teachers];
    }
    else
    {
        [self filterContentForSearchText:searchText];
    }
    [self.teachersCollectionView reloadData];
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
    [self.searcBar resignFirstResponder];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.teachersCollectionView dequeueReusableCellWithReuseIdentifier:@"Teacher Pic" forIndexPath:indexPath];
    
    if([cell isKindOfClass:[TeacherCollectionViewCell class]])
    {
        
        TeacherCollectionViewCell* teacher = (TeacherCollectionViewCell*) cell;
        Teacher* tmpTeacher = [self.searchResults objectAtIndex:indexPath.item];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",tmpTeacher.id]];
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        teacher.teacherImage.image = image;
        teacher.teacherNameLabel.text = tmpTeacher.name;
        teacher.teacher = [self.searchResults objectAtIndex:indexPath.item];
        
        teacher.teacherNameLabel.backgroundColor = [UIColor colorWithRed:236/255.0f green:153/255.0f blue:0/255.0f alpha:0.3f];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.searcBar resignFirstResponder];
    if ([segue.identifier isEqualToString:@"show teacher details"])
    {
        if ([segue.destinationViewController isKindOfClass:[TeachersDetailsViewController class]])
        {
            if([sender isKindOfClass:[TeacherCollectionViewCell class]])
            {
                TeacherCollectionViewCell* sourceController = (TeacherCollectionViewCell*) sender;
                TeachersDetailsViewController *tsvc = (TeachersDetailsViewController *)segue.destinationViewController;
                
                tsvc.localFilePath = sourceController.teacher.localImageFilePath;
                tsvc.teacher = sourceController.teacher;
            }
        }
    }
}



-(void)initTeachersWithContext:(NSManagedObjectContext*)context
{
    NSURL *url = [NSURL URLWithString:@"http://nlanda.technion.ac.il/LandaSystem/tutors.aspx"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSString *webString =[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"new string ==    %@" , webString);
    NSString* jsonString = [self makeJsonFromString:webString];
    
    NSError * error;
    
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    
    NSArray * array = [JSON objectForKey:@"users"];
    
    
    for(id tut in array)
    {
        NSString * id = [tut objectForKey:@"id"];
        NSString * faculty = [tut objectForKey:@"faculty"];
        NSString * firstName = [tut objectForKey:@"fname"];
        NSString * lastName = [tut objectForKey:@"lname"];
        NSString * email = [tut objectForKey:@"email"];
        
        firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
        lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * name = [firstName stringByAppendingString:@" "];
        name = [name stringByAppendingString:lastName];
        
        NSString * urlString = [NSString stringWithFormat:@"http://nlanda.technion.ac.il/LandaSystem/pics/"];
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.jpg" , id]];

        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",id]];
        [data writeToFile:localFilePath atomically:YES];
        
        [Teacher initWithName:name mail:email imageName:[NSString stringWithFormat:@"%@.jpg" , id] id:id faculty:faculty localImageFilePath:localFilePath inManagedObjectContext:context];

    }
}

-(NSString*) makeJsonFromString:(NSString*)string
{
    int first = 0;
    int last = 0;
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
