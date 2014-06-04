//
//  HelpFunc.m
//  Landa
//
//  Created by muhammad abed el razek on 6/4/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "HelpFunc.h"

@implementation HelpFunc


+(NSString*) writeImageToFileWithId:(NSString*)id data:(NSData*)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",id]];
    [data writeToFile:localFilePath atomically:YES];
    
    return localFilePath;
}

+(UIImage *)getImageFromFileWithId:(NSString*)id
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",id]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;

}


+(NSString*) makeJsonFromString:(NSString*)string
{
    NSInteger first = 0;
    NSInteger last = 0;
    // int length = 0;
    int count = 0;
    
    
    for (NSInteger charIdx = 0; charIdx < string.length ; charIdx++)
    {
        if([string characterAtIndex:charIdx] == '{')
        {
            first = charIdx;
            break;
        }
    }
    
    
    for (NSInteger charIdx = 0; charIdx < string.length ; charIdx++)
    {
        if([string characterAtIndex:charIdx] == '}')
        {
            count-- ;
            if (count == 0)
            {
                last = charIdx;
                break;
            }
        }
        if([string characterAtIndex:charIdx] == '{')
        {
            count++;
        }
        
    }
    NSRange range = NSMakeRange(first, last - first + 1);
    NSString * newString = [string substringWithRange:range];
    return newString;
}

@end
