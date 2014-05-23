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
#import "TeacherId.h"
#import "CoursesTableViewCell.h"

@interface CoursesDetailsCollectionView () <UITableViewDataSource , UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *teachersCollectionView;
//@property (strong , nonatomic) NSManagedObjectContext * context;
@property (strong , nonatomic) NSMutableArray * teachers;
@property (strong , nonatomic) NSMutableArray * teacherIdArray;
@property (weak, nonatomic) IBOutlet UITableView *teachersTableView;

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
    
    self.teachersTableView.backgroundColor = [UIColor clearColor];
    self.courseImage.image = [UIImage imageNamed:self.course.imageName];
    self.courseName.text = self.course.name;
    self.teachers = [[NSMutableArray alloc] init];
    self.teacherIdArray = [[NSMutableArray alloc] init];
    
    for(TeacherId * teacherId in self.course.teachers)
    {
        LandaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError * error;
        
        NSEntityDescription *teacherEntityDisc = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:teacherEntityDisc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"id = %@" , teacherId.id];
        [request setPredicate:pred];
        NSArray *teachersArray = [context executeFetchRequest:request error:&error];
        Teacher * teacher = [teachersArray firstObject];
        if(teacher)
        {
            [self.teachers addObject:teacher];
            [self.teacherIdArray addObject:teacherId];
        }

    }

//
//    for(Teacher* teacher in objects)
//    {
//        [self.course addTeachersObject:teacher];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teachers count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    UITableViewCell * cell = [self.teachersTableView dequeueReusableCellWithIdentifier:@"teacher details"];
    
    if([cell isKindOfClass:[CoursesTableViewCell class]])
    {
        
        cell.backgroundColor = [UIColor clearColor];
        
        Teacher * teacher = [self.teachers objectAtIndex:indexPath.item];
        TeacherId * teacherId = [self.teacherIdArray objectAtIndex:indexPath.item];
                        
        
        CoursesTableViewCell * course = (CoursesTableViewCell*) cell;
        
        NSString * teacherName = teacher.name;
        NSString * day = teacherId.day;
        NSString * time = @"start : ";
        time = [time stringByAppendingString:teacherId.beginTime];
        time = [time stringByAppendingString:[NSString stringWithFormat:@" end: %@", teacherId.endTime ] ];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",teacherId.id]];
        UIImage* image = [UIImage imageWithContentsOfFile:path];
       
        
        //course.teacherName = [NSString stringWithString:teacherName];
        course.nameLabel.text = teacherName;
        course.dayLabel.text = day;
        course.timeLabel.text = time;
        course.image.image = image;
        
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
