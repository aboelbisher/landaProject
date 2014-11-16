//
//  HelpFunc.h
//  Landa
//
//  Created by muhammad abed el razek on 6/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


static NSString* HONE5 = @"חונך אכדמי";
static NSString* RAKAZ = @"רכז/ת חברתי/ת";
static NSString* RAKAZMAIN = @"רכז/ת פרויקט";
static NSString* EVERYONE = @"הכל";

@implementation UIColor (MyProject)

+(UIColor *) myGreenColor { return [UIColor colorWithRed:0 green:0.702 blue:0.494 alpha:1]; }

@end


@interface HelpFunc : NSObject


+(NSString*) makeJsonFromString:(NSString*)string;

+(UIImage *)getImageFromFileWithId:(NSString*)id;

+(NSString*) writeImageToFileWithId:(NSString*)id data:(NSData*)data;

+(BOOL)checkForInternet;

@end
