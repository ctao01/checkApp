//
//  NSString+JTAdditions.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "NSString+JTAdditions.h"

@implementation NSString (JTAdditions)

+(NSString*) imagePathWithItemName:(NSString*)itemName
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsPath = [paths objectAtIndex:0];
    
    NSDateFormatter * f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyyMMddhhmmss"];
    NSString * string = [f stringFromDate:[NSDate date]];
    
    NSString * filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",string]];
    return filePath;
}

+ (NSString*) dateFormatterShortStyle:(NSDate*) date
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString * string = [df stringFromDate:date];
    
    return string;
}

+ (NSString*) dateFormatterMediumStyleWithoutTime:(NSDate*) date
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    NSString * string = [df stringFromDate:date];
    
    return string;
}

+ (NSString*) dateFormatterLongStyle:(NSDate*) date
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setTimeStyle:NSDateFormatterLongStyle];
    
    NSString * string = [df stringFromDate:date];
    
    return string;
}

@end
