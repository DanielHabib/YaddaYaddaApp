//
//  CoreDataAPI+Fetch.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI.h"

@interface CoreDataAPI (Fetch)



+(NSArray *)fetchSpecificGroupMemberModelWithUserID:(int)userID;
+(NSArray *)fetchGroupListModel;
+(NSArray *)fetchSpecificGroupModelWithGroupID:(int)groupID;
+(NSArray *)fetchProfileInfoModel;
+(NSArray *)fetchAllEmojiPhotosModel;
+(NSArray *)fetchSpecificEmojiEntitiyModel:(NSString *)emoji;
+(NSArray *)fetchUpdatedGroupMemberListFromServerModel;
@end
