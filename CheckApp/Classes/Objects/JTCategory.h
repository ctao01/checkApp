//
//  JTCategory.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JTObject;

@interface JTCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * period;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet * objects;

@end
