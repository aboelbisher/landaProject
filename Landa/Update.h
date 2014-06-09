//
//  Update.h
//  Landa
//
//  Created by muhammad abed el razek on 6/10/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Update : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * flagged;
@property (nonatomic, retain) NSString * hasBeenRead;
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * htmlUpdate;
@property (nonatomic, retain) NSString * url;

@end
