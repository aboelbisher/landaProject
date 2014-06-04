//
//  TeachersViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 4/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "TeachersViewController.h"


static NSString* TEACHERS_URL = @"http://nlanda.technion.ac.il/LandaSystem/tutors.aspx";
static NSString* PIC_URL = @"http://nlanda.technion.ac.il/LandaSystem/pics/";


@interface TeachersViewController () <UICollectionViewDataSource , UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
@property(nonatomic , strong) NSMutableArray * teachers; // of Teacher(s)
@property (nonatomic , strong) NSMutableArray * searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

#pragma mark init

@implementation TeachersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //customize
    self.teachersCollectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.spinner.color = [UIColor whiteColor];
    self.spinner.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    [self.searcBar setBarTintColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
    
    self.teachers = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    

    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]))
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

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
        [self initTeachersWithContext:context];
    }
    else
    {
        NSArray * objects = [Teacher getAllTeachersInManagedObjectContext:context];
        if ([objects count] == 0)
        {
            [self initTeachersWithContext:context];
        }
        self.teachers = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.teachers];
    }
}


#pragma mark UISearchBar

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
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}





#pragma mark UICollectionView


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
        
        UIImage * image = [HelpFunc getImageFromFileWithId:tmpTeacher.id];
        
        // rand for rotating pics
        int rotate = arc4random() % 5;
        int RightOrLeft = arc4random()% 2;
        if(RightOrLeft == 1)
        {
            rotate += 30;
        }
        else
        {
            rotate = -rotate;
            rotate += -30;
        }
        
        if(!image)
        {
            teacher.teacherImage.image = [UIImage imageNamed:@"noContact.png"];
        }
        else
        {
            teacher.teacherImage.image = image;
        }
        
        //rotate and shadow
        teacher.teacherImage.layer.shadowColor = [UIColor blackColor].CGColor;
        teacher.teacherImage.layer.shadowOffset = CGSizeMake(0, 5);
        teacher.teacherImage.layer.shadowOpacity = 1;
        teacher.teacherImage.layer.shadowRadius = 5.0;
        teacher.teacherImage.transform = CGAffineTransformMakeRotation(M_PI/rotate);
        [teacher.teacherImage.layer setBounds:CGRectMake(15, 0, 100, 100)];
        [teacher.teacherImage.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
        [teacher.teacherImage.layer setBorderWidth:2.0];
    
        teacher.teacherNameLabel.text = tmpTeacher.name;
        teacher.teacher = [self.searchResults objectAtIndex:indexPath.item];
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
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURL *url = [NSURL URLWithString:TEACHERS_URL];
   
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
            
            NSArray * array = [JSON objectForKey:@"users"];
            
            for(id tut in array)
            {
                NSString * id = [tut objectForKey:@"id"];
                NSString * faculty = [tut objectForKey:@"faculty"];
                NSString * firstName = [tut objectForKey:@"fname"];
                NSString * lastName = [tut objectForKey:@"lname"];
                NSString * email = [tut objectForKey:@"email"];
                NSString * postion = @"חונך אכדמי";
                firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
                lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * name = [firstName stringByAppendingString:@" "];
                name = [name stringByAppendingString:lastName];
                
                NSString * urlString = PIC_URL;
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.png" , id]];
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                NSString * localFilePath = [HelpFunc writeImageToFileWithId:id data:data];
                
                [Teacher initWithName:name mail:email imageName:[NSString stringWithFormat:@"%@.png" , id] id:id faculty:faculty localImageFilePath:localFilePath position:postion inManagedObjectContext:context];
                
            }
        }
        NSArray* objects = [Teacher getAllTeachersInManagedObjectContext:context];
        
        self.teachers = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.teachers];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
            [self.teachersCollectionView reloadData];});
    }];
    [task resume];
    

}



@end
