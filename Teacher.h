//
//  Teacher.h
//  Landa
//
//  Created by muhammad abed el razek on 5/25/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Teacher : NSManagedObject

@property (nonatomic, retain) NSString * faculty;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * localImageFilePath;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * position;

@end
