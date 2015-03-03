//
//  CoreDataAPI+Delete.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI.h"

@interface CoreDataAPI (Delete)



+(void)deleteAllObjectsInCoreDataModel;
+(void)deleteGroupModelwithGroupID:(int)groupID;
@end
