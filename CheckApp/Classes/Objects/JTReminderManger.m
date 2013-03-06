//
//  JTReminderManger.m
//  CheckApp
//
//  Created by Joy Tao on 3/4/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTReminderManger.h"

static JTReminderManger * sharedManager = nil;

@implementation JTReminderManger
@synthesize store = _store;

+ (JTReminderManger*) sharedManager
{
    @synchronized(self){
        if (sharedManager == nil)
            sharedManager = [[super allocWithZone:NULL] init];
    }
    return sharedManager;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (EKEventStore*) store
{
    if (_store == nil)
    {
        _store = [[EKEventStore alloc]init];
        
        [_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            
            if (!granted)
                NSLog(@"Access to store not granted");
        }];
    }
    
    return _store;
}

@end
