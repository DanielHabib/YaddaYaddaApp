//
//  CoreDataDI.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "CoreDataComponents.h"
@interface CoreDataAssembly : TyphoonAssembly





@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;





-(NSString *) getString;
- (NSURL *)applicationDocumentsDirectory;
//-(CoreDataComponents *)grabCoreDataComponents;
//-(NSManagedObjectContext *)grabManagedObjectContext;


+(id)sharedManager;
@end
