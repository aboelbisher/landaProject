//
//  Update.h
//  Landa
//
//  Created by muhammad abed el razek on 5/29/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Update : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * title;

@end
