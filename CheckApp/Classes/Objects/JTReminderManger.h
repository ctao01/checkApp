//
//  JTReminderManger.h
//  CheckApp
//
//  Created by Joy Tao on 3/4/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface JTReminderManger : NSObject

@property (nonatomic , retain) EKEventStore * store;

+ (JTReminderManger*) sharedManager;

@end
