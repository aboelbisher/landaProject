//
//  LastRefresh.h
//  Landa
//
//  Created by muhammad abed el razek on 6/1/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastRefresh : NSManagedObject

@property (nonatomic, retain) NSDate * lastRefresh;
@property (nonatomic, retain) NSString * id;

@end
