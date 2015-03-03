//
//  CoreDataAPI+Delete.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI+Delete.h"

@implementation CoreDataAPI (Delete)


+ (void)deleteAllObjectsInCoreDataModel
{
    
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSManagedObjectModel *model = [self grabGlobalyManagedObjectModel];
    
    NSArray *allEntities = model.entities;
    
    for (NSEntityDescription *entityDescription in allEntities)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            NSLog(@"Error requesting items from Core Data: %@", [error localizedDescription]);
        }
        
        for (NSManagedObject *managedObject in items) {
            [context deleteObject:managedObject];
        }
        
        if (![context save:&error]) {
            NSLog(@"Error deleting %@ - error:%@", entityDescription, [error localizedDescription]);
        }else{
            NSLog(@"All entities deleted");
        }
    }  
}
+(void)deleteGroupModelwithGroupID:(int)groupID{
 
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    

    NSArray *result  = [self fetchSpecificGroupWithGroupID:groupID];
    NSManagedObject *groupToBeDeleted = [result objectAtIndex:0];
    [context delete:groupToBeDeleted];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error deleting Specific Group - error:%@", [error localizedDescription]);
    }
    else{
        NSLog(@"group deleted");
    }
}

@end
