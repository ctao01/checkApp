//
//  JTCategory.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTCategory.h"
#import "JTObject.h"

@implementation JTCategory

@dynamic period;
@dynamic title;
@dynamic objects;

- (void)addObject:(JTObject *)object {
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&object count:1];
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"objects"] addObject:object];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeObject:(JTObject *)object {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&object count:1];
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"objects"] removeObject:object];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}

- (void)addObjects:(NSSet *)objects {
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:objects];
    [[self primitiveValueForKey:@"objects"] unionSet:objects];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:objects];
}

- (void)removeObjects:(NSSet *)objects {
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:objects];
    [[self primitiveValueForKey:@"objects"] minusSet:objects];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:objects];
}

@end
