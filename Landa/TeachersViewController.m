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


//static CGRect FRAME = {{100 , 0} , {50 ,100}};
static int PICKERWIDTH = 200;
static int PICKERHEIGHT = 200;



@interface TeachersViewController () <UICollectionViewDataSource , UICollectionViewDelegate , UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *filterButtonOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
@property(nonatomic , strong) NSMutableArray * teachers; // of Teacher(s)
@property (nonatomic , strong) NSMutableArray * searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;
@property (weak, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong , nonatomic) NSArray* dataSource;
@property(strong , nonatomic) UIPickerView* pickerView;

//@property(strong , nonatomic) NSArray* jobsTitles; // for index list
//@property(strong , nonatomic) NSDictionary* teachersSectionsDic;
//
//@property(strong , nonatomic) NSArray* tmpTestArray;

@end

#pragma mark init

@implementation TeachersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //customize
    self.teachersCollectionView.backgroundColor = [UIColor whiteColor];
    self.spinner.color = [UIColor blackColor];
    self.spinner.hidden = YES;
    
    self.filterButtonOutlet.tintColor = [UIColor whiteColor];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor myGreenColor]];
    [self.searcBar setBarTintColor:[UIColor myGreenColor]];
    
    self.teachers = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDelegate:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightDelegate:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];

    


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
            [self initTeachersWithContext:context];
        }
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
        
        if([HelpFunc checkForInternet])
        {
            [self checkForNewUpdates];
        }
    }
    
    
    [self initUIPickerView];

    

    
}

-(void)checkForNewUpdates
{
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = [NSURL URLWithString:TEACHERS_URL];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
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
           NSArray* allTeachers = [Teacher getAllTeachersInManagedObjectContext:context];
           NSMutableArray * oldIds = [[NSMutableArray alloc] init];
           for(Teacher *teacher in allTeachers)
           {
               [oldIds addObject:teacher.id];
           }
           NSMutableArray * newIds = [[NSMutableArray alloc] init];
           NSMutableArray * newTeachers = [[NSMutableArray alloc] init];
           
           NSArray * array = [JSON objectForKey:@"users"];
        //   BOOL theresAChange = NO;

           
           for(id tut in array)
           {
               NSString * id = [tut objectForKey:@"id"];
               NSString * faculty = [tut objectForKey:@"faculty"];
               NSString * firstName = [tut objectForKey:@"fname"];
               NSString * lastName = [tut objectForKey:@"lname"];
               NSString * email = [tut objectForKey:@"email"];
               NSInteger positionNum  = [[tut objectForKey:@"position"] integerValue];
               NSString * position = nil;
               
               switch (positionNum)
               {
                   case 1:
                       position = @"חונך אכדמי";
                       break;
                   case 3:
                       position = @"רכז/ת פרויקט";
                       break;
                   case 4:
                       position = @"רכז/ת חברתי/ת";
                       break;
                   default:
                       break;
               }
               firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
               lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
               NSString * name = [firstName stringByAppendingString:@" "];
               name = [name stringByAppendingString:lastName];
               
               NSString * urlString = PIC_URL;
               urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.png" , id]];
               
               NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
               NSString * localFilePath = [HelpFunc writeImageToFileWithId:id data:data];

               TeacherLocal * localTeacher = [[TeacherLocal alloc] initTeacherWithName:name faculty:faculty id:id
                                                                            imageName:[NSString stringWithFormat:@"%@.png" , id]
                                                                    localImageFilePath:localFilePath
                                                                                  mail:email
                                                                              position:position];
               
               [newIds addObject:id];
               [newTeachers addObject:localTeacher];
               
           }
           if(![newIds isEqualToArray:oldIds])
           {
               [Teacher deleteAllTeachersInManagedObjectoContext:context];
               for(TeacherLocal * teacher in newTeachers)
               {
                   [Teacher initWithName:teacher.name mail:teacher.mail imageName:teacher.imageName id:teacher.id faculty:teacher.faculty localImageFilePath:teacher.localImageFilePath position:teacher.position inManagedObjectContext:context];
               }
               NSArray * newTeachers = [Teacher getAllTeachersInManagedObjectContext:context];
               
               dispatch_async(dispatch_get_main_queue(), ^
               {
                   self.teachers = nil;
                   self.searchResults = nil;
                   self.teachers = [NSMutableArray arrayWithArray:newTeachers];
                   self.searchResults = [NSMutableArray arrayWithArray:self.teachers];
                   
                   [self.teachersCollectionView reloadData];
               });
           }
       }
   }];
    [task resume];
    [session finishTasksAndInvalidate];

}

- (IBAction)swipeRightDelegate:(id)sender
{
    NSInteger destIndex = 2;
    // Get views. controllerIndex is passed in as the controller we want to go to.
    UIView * fromView = self.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:destIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished)
     {
         if (finished)
         {
             self.tabBarController.selectedIndex = destIndex;
         }
     }];

}



- (IBAction)swipeLeftDelegate:(id)sender
{
    NSInteger destIndex = 1;
    // Get views. controllerIndex is passed in as the controller we want to go to.
    UIView * fromView = self.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:destIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished)
                    {
                        if (finished)
                        {
                            self.tabBarController.selectedIndex = destIndex;
                        }
                    }];
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
        [teacher.teacherImage.layer setBorderWidth:0.5];
    
        teacher.teacherNameLabel.text = tmpTeacher.name;
        teacher.teacherNameLabel.textColor = [UIColor myGreenColor];
        teacher.teacher = [self.searchResults objectAtIndex:indexPath.item];
    }
    
    return cell;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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


-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self refreshData];
    completionHandler(UIBackgroundFetchResultNewData);
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
                NSInteger positionNum  = [[tut objectForKey:@"position"] integerValue];
                NSString * position = nil;
                
                switch (positionNum)
                {
                    case 1:
                        position = HONE5;
                        break;
                    case 3:
                        position = RAKAZMAIN;
                        break;
                    case 4:
                        position = RAKAZ;
                        break;
                    default:
                        break;
                }
                firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
                lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * name = [firstName stringByAppendingString:@" "];
                name = [name stringByAppendingString:lastName];
                
                NSString * urlString = PIC_URL;
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.png" , id]];
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                NSString * localFilePath = [HelpFunc writeImageToFileWithId:id data:data];
                
                [Teacher initWithName:name mail:email imageName:[NSString stringWithFormat:@"%@.png" , id] id:id faculty:faculty localImageFilePath:localFilePath position:position inManagedObjectContext:context];
                
            }
        }
        NSArray* objects = [Teacher getAllTeachersInManagedObjectContext:context];
        
        self.teachers = [NSMutableArray arrayWithArray:objects];
        self.searchResults = [NSMutableArray arrayWithArray:self.teachers];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
            [self.teachersCollectionView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        });
    }];
    [task resume];
    [session finishTasksAndInvalidate];
    

}

-(void)refreshData
{
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error = nil;
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = [NSURL URLWithString:TEACHERS_URL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    
    NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
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
        NSInteger positionNum  = [[tut objectForKey:@"position"] integerValue];
        NSString * position = nil;
        
        switch (positionNum)
        {
            case 1:
                position = HONE5;
                break;
            case 3:
                position = RAKAZMAIN;
                break;
            case 4:
                position = RAKAZ;
                break;
            default:
                break;
        }
        firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
        lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * name = [firstName stringByAppendingString:@" "];
        name = [name stringByAppendingString:lastName];
        
        NSString * urlString = PIC_URL;
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@.png" , id]];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        NSString * localFilePath = [HelpFunc writeImageToFileWithId:id data:data];
        
        [Teacher initWithName:name mail:email imageName:[NSString stringWithFormat:@"%@.png" , id] id:id faculty:faculty localImageFilePath:localFilePath position:position inManagedObjectContext:context];
        
    }

}



- (IBAction)showInfo:(id)sender
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"About"];
    [self presentViewController:vc animated:YES completion:nil];
    
}


#pragma mark UIPicker functions

-(void) initUIPickerView
{
    int xCord = self.view.bounds.size.width/2 - PICKERWIDTH/2;
    int yCord = self.view.bounds.size.height/2 - PICKERHEIGHT/2;
    //for UIPickerView
    
    CGRect pickerFrame = {{xCord , yCord} , {PICKERWIDTH ,PICKERHEIGHT}};

    
    self.dataSource = @[EVERYONE , RAKAZMAIN , RAKAZ , HONE5];
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
   // self.pickerView.backgroundColor = [UIColor whiteColor];

    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.pickerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.pickerView.layer.shadowOpacity = 1;
    self.pickerView.layer.shadowRadius = 1.0;
    self.pickerView.clipsToBounds = NO;    //self.pickerView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource count];
}



- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [self.dataSource objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    
    return attString;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    [self.searchResults removeAllObjects];
    NSString* wantedPosition = [self.dataSource objectAtIndex:row];
    
    NSArray* tmpTeachersArray;
    
    if([wantedPosition isEqualToString:EVERYONE])
    {
        tmpTeachersArray = [Teacher getAllTeachersInManagedObjectContext:context];
    }
    else
    {
        tmpTeachersArray = [Teacher getTeachersWithPosition:wantedPosition inManagedObjectContext:context];

    }
    
    self.searchResults = [NSMutableArray arrayWithArray:tmpTeachersArray];
    [self.teachersCollectionView reloadData];
    [NSThread sleepForTimeInterval:0.5f];

    
    [self.pickerView removeFromSuperview];
}
- (IBAction)filter:(id)sender
{
    [self.view addSubview:self.pickerView];

}



@end
