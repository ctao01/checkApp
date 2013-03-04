//
//  NSString+JTAdditions.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JTAdditions)

+ (NSString*) imagePathWithItemName:(NSString*)itemName;
+ (NSString*) dateFormatterShortStyle:(NSDate*) date;

@end
