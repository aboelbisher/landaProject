//
//  TeacherLocal.h
//  Landa
//
//  Created by muhammad abed el razek on 6/13/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherLocal : NSObject


@property (nonatomic, retain) NSString * faculty;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * localImageFilePath;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * position;

-(instancetype)initTeacherWithName:(NSString*) name faculty:(NSString*)faculty id:(NSString*)id imageName:(NSString*)imageName localImageFilePath:(NSString*)localImageFilePath mail:(NSString*)mail position:(NSString*)position;

@end
