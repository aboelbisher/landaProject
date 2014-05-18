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


@interface TeachersViewController () <UICollectionViewDataSource , UICollectionViewDelegate>

//@property(nonatomic , strong) NSArray * teachersPic;
@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
@property(nonatomic , strong) NSMutableArray * teachers; // of Teacher(s)
@property (nonatomic , strong) NSMutableArray * searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;
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
    
    
    [context reset];
    [context save:&error];

//    
//    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:teacherEntityDisc];
//    NSPredicate *pred =nil;
//    [request setPredicate:pred];
//    NSArray *objects = [context executeFetchRequest:request
//                                              error:&error];
    

    
        
    [self initTeachersWithContext:context];
    
    
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
        teacher.teacherImage.image = [UIImage imageNamed:tmpTeacher.imageName];
        
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
                
                
                tsvc.teacherImageName = sourceController.teacher.imageName;
                tsvc.teacher = sourceController.teacher;
            }
            
            
        }
    }
}

-(void)initTeachersWithContext:(NSManagedObjectContext*)context
{
        [Teacher initWithName:@"muhammad" mail:@"aboelbisher.176@gmail.com" imageName:@"muhammad.jpg" inManagedObjectContext:context];
    
    
    [Teacher initWithName:@"hasan" mail:@"hasan@gmail.com" imageName:@"hasan.jpg" inManagedObjectContext:context];

    
    [Teacher initWithName:@"7amed" mail:@"7amed@gmail.com" imageName:@"7amed.jpg" inManagedObjectContext:context];
    

    
    [Teacher initWithName:@"almothanna" mail:@"almothanna@gmail.com" imageName:@"mothana.jpg" inManagedObjectContext:context];
    

    
    [Teacher initWithName:@"aiman" mail:@"aiman@gmail.com" imageName:@"aiman.jpg" inManagedObjectContext:context];
    

    
    [Teacher initWithName:@"ward" mail:@"ward@gmail.com" imageName:@"ward.jpg" inManagedObjectContext:context];
    

    
    [Teacher initWithName:@"thrwat" mail:@"thrwat@gmail.com" imageName:@"thrwat.jpg"inManagedObjectContext:context];
    

}

@end
