//
//  CoreDataAPI.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI.h"
#import "CoreDataAPI+Fetch.h"
#import "CoreDataAPI+Delete.h"
#import "CoreDataAPI+Update_Insert.h"
@implementation CoreDataAPI
+(BOOL)saveContext:(NSManagedObjectContext*)context{

    NSError *error = nil;
    [context save:&error];
    if (error) {
        NSLog(@"Error Saving");
        NSLog(@"%@, %@",error,error.description);
        return false;
    }else{
        NSLog(@"Save Successful");
        return true;
    }
}


#pragma mark - delete

+ (void)deleteAllObjectsInCoreData{
    [self deleteAllObjectsInCoreDataModel];
}
+(void)deleteGroupWithGroupID:(int)groupID{
    
    [self deleteGroupModelwithGroupID:groupID];
    
}

+(NSArray *)fetchSpecificGroupMemberWithUserID:(int)userID{
    
    return [self fetchSpecificGroupMemberModelWithUserID:userID];
    
}


#pragma mark Fetching

+(NSArray *)fetchGroupList{
    
    return [self fetchGroupListModel];
}
+(NSArray *)fetchSpecificGroupWithGroupID:(int)groupID{
    
    
    return [self fetchSpecificGroupModelWithGroupID:groupID];
    
}
+(NSArray *)fetchUpdatedGroupMemberListFromServer{
    return [CoreDataAPI fetchUpdatedGroupMemberListFromServerModel];
    
}


+(NSArray *)fetchProfileInfo{
    return [self fetchProfileInfoModel];
}

+(NSArray *)fetchAllEmojiPhotos{
    
    return [self fetchAllEmojiPhotosModel];
    
}
+(NSArray *)fetchSpecificEmojiEntitiy:(NSString*)emoji{
    
    return [self fetchSpecificEmojiEntitiyModel:emoji];
    
};


#pragma mark -Updating And Inserting

+(BOOL)newProfileInformationWithUsername:(NSString *)username
                                   email:(NSString *)email
                                 userID :(int)userID
                             phoneNumber:(NSString *)phoneNumber
                            profilePhoto:(NSData *)photo
                                password:(NSString *)password{
    
  return [self newProfileInformationModelWithUsername:username
                                                email:email
                                               userID:userID
                                          phoneNumber:phoneNumber
                                         profilePhoto:photo
                                             password:password];
}
+(BOOL)updateProfileInformationWithUsername:(NSString *)username
                                   email:(NSString *)email
                                 userID :(int)userID
                             phoneNumber:(NSString *)phoneNumber
                            profilePhoto:(NSData *)photo
                                password:(NSString *)password{
    
    return [self updateProfileInformationModelWithUsername:username
                                                  email:email
                                                 userID:userID
                                            phoneNumber:phoneNumber
                                           profilePhoto:photo
                                               password:password];
}


+(BOOL)newGroup:(NSString *)groupName
             groupID:(int)groupID
 groupImageData:(NSData *)imageData{
    
    return [self newGroupModel:groupName groupID:groupID groupImageData:imageData];
    
    
}
+(BOOL)updateGroupWithGroupID:(int)groupID
                         groupName:(NSString*)groupName
                        groupImage:(NSData *)imageData
                       lastMessage:(NSString *)lastMessage
                   lastMessageDate:(NSDate *)lastMessageDate
              lastMessageUser:(NSString *)lastMessageUser{
    
    return [self updateGroupModelWithGroupID:(int)groupID
                                   groupName:groupName
                                  groupImage:imageData
                                 lastMessage:lastMessage
                             lastMessageDate:lastMessageDate
                             lastMessageUser:lastMessageUser];
    
    
}

+(BOOL)newEmojiPhotoWithEmojiString:(NSString*)emojiString
                              emoji:(NSString *)emoji
                        emojiPhoto :(NSData *)photo{
    
    return [self newEmojiPhotoModelWithEmojiString:emojiString emoji:emoji emojiPhoto:photo];
};


#pragma mark - general

+(NSManagedObjectContext *)grabGlobalManagedObjectContext{
    CoreDataAssembly *assembly = [CoreDataAssembly sharedManager];
    NSManagedObjectContext *context = assembly.managedObjectContext;
    return context;
}

+(NSManagedObjectModel *)grabGlobalyManagedObjectModel{
    CoreDataAssembly *assembly = [CoreDataAssembly sharedManager];
    NSManagedObjectModel *model = assembly.managedObjectModel;
    return model;
}
+(NSPersistentStoreCoordinator *)grabGloballyPersistentStoreCoordinator{
    CoreDataAssembly *assembly = [CoreDataAssembly sharedManager];
    NSPersistentStoreCoordinator *PSC = assembly.persistentStoreCoordinator;
    return PSC;
}

+(NSDate *)stringToDateConverter:(NSString *)date{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss.S"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *dateStr;
    NSDate *formattedDate;
    dateStr = date;
    formattedDate = [formatter dateFromString:dateStr];
    
    return formattedDate;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
//    NSInteger hour = [components hour];
//    NSInteger minute = [components minute];
    
}


@end
