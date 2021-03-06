//
//  JTObjectManager.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTObject.h"
#import "JTCategory.h"

@interface JTObjectManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(JTObjectManager*) sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
