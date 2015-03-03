//
//  CoreDataComponents.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataComponents : NSObject
@property NSManagedObjectContext *managedObjectContext;
@property NSPersistentStoreCoordinator *persistenStoreCoordinator;

@property NSString *testingString;

@end
