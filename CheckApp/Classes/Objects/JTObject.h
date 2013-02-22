//
//  JTObject.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JTCategory;

@interface JTObject : NSManagedObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * buyInDate;
@property (nonatomic, retain) NSDate * expiredDate;
@property (nonatomic) BOOL expired;
@property (nonatomic) BOOL toBuy;
@property (nonatomic, retain) NSDate * toBuyDate;
@property (nonatomic, retain) JTCategory * category;

@end
