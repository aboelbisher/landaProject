//
//  CoursesDetailsCollectionView.m
//  Landa
//
//  Created by muhammad abed el razek on 4/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "CoursesDetailsCollectionView.h"
#import "TeacherCollectionViewCell.h"
#import "TeachersDetailsViewController.h"
#import "Teacher+init.h"
#import "LandaAppDelegate.h"

@interface CoursesDetailsCollectionView () <UICollectionViewDelegate , UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
//@property (strong , nonatomic) NSManagedObjectContext * context;
@property (weak , nonatomic) NSArray * teachers;

@end

@implementation CoursesDetailsCollectionView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.teachersCollectionView.backgroundColor = [UIColor clearColor];
    self.courseImage.image = [UIImage imageNamed:self.course.imageName];
    self.courseName.text = self.course.name;

    LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError * error;
    
    NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teacherEntityDisc];
    NSPredicate *pred =nil;
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    for(Teacher* teacher in objects)
    {
        [self.course addTeachersObject:teacher];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.course.teachers count];
}






-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.teachersCollectionView dequeueReusableCellWithReuseIdentifier:@"Teacher Pic" forIndexPath:indexPath];
    
    if([cell isKindOfClass:[TeacherCollectionViewCell class]])
    {
        TeacherCollectionViewCell* teacher = (TeacherCollectionViewCell*) cell;
        Teacher* tmpTeacher = [[self.course.teachers allObjects] objectAtIndex:indexPath.item];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",tmpTeacher.id]];
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        
        teacher.teacherImage.image = image;
        teacher.teacherNameLabel.text = tmpTeacher.name;
        teacher.teacherNameLabel.backgroundColor = [UIColor colorWithRed:236/255.0f green:153/255.0f blue:0/255.0f alpha:0.3f];
        teacher.teacher = tmpTeacher;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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






@end
