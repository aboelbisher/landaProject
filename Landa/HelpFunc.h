//
//  HelpFunc.h
//  Landa
//
//  Created by muhammad abed el razek on 6/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpFunc : NSObject

+(NSString*) makeJsonFromString:(NSString*)string;

+(UIImage *)getImageFromFileWithId:(NSString*)id;

+(NSString*) writeImageToFileWithId:(NSString*)id data:(NSData*)data;

@end
