//
//  CoreDataAPI+Update_Insert.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI+Update_Insert.h"

@implementation CoreDataAPI (Update)

+(void)checkForNeccesaryUpdatesToCoreDataStore{
    
    
    
}

+(BOOL)updateGroupModelWithGroupID:(int)groupID
                         groupName:(NSString*)groupName
                        groupImage:(NSData *)imageData
                       lastMessage:(NSString *)lastMessage
                   lastMessageDate:(NSDate *)lastMessageDate
                   lastMessageUser:(NSString *)lastMessageUser{
    
    
    
  //  NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSArray *result = [self fetchSpecificGroupWithGroupID:groupID];
    NSManagedObject *groupInfo = [result objectAtIndex:0];
    
    if (groupName) {
        [groupInfo setValue:groupName forKey:@"groupName"];
    }else if (imageData)
        [groupInfo setValue:imageData forKey:@"groupImage"];
    else if (lastMessage){
        [groupInfo setValue:lastMessage forKey:@"lastMessage"];
    }
    else if(lastMessageUser){
        [groupInfo setValue:lastMessageUser forKey:@"lastMessageUser"];
    }
    else if (lastMessageDate){
            [groupInfo setValue:lastMessageDate forKey:@"lastMessageDate"];
    }
    
    
    NSError *error = nil;
    
    [groupInfo.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Updating Group Failed");
        NSLog(@"%@,%@",error,error.description);
        return false;
    }else{
        NSLog(@"successfully updated the group");
        NSLog(@"%@",lastMessage);
        return true;
    }
}



//
//+(BOOL)updateAllGroupMembersModel{
//    
//    
//}


+(BOOL)newGroupModel:(NSString *)groupName
        groupID:(int)groupID
 groupImageData:(NSData *)imageData{
    
    NSManagedObjectContext * context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupInfo" inManagedObjectContext:context];
    NSManagedObject *newGroup = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
    
    
    [newGroup setValue:groupName forKey:@"groupName"];
    [newGroup setValue:[NSNumber numberWithInt:groupID] forKey:@"groupID"];
    [newGroup setValue:imageData forKey:@"groupImage"];
    
    NSError *error = nil;
    [newGroup.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Failure Creating new group entry");
        NSLog(@"%@,%@",error,error.description);
        return false;
    }else{
        NSLog(@"new Group created successfully");
        return true;
        
    }
}





+(BOOL)newProfileInformationModelWithUsername:(NSString *)username
                                      email:(NSString *)email
                                    userID :(int)userID
                                phoneNumber:(NSString *)phoneNumber
                               profilePhoto:(NSData *)photo
                                     password:(NSString *)password{
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"CoreDataProfileInfoFlag"]) {

        NSManagedObjectContext *context = [CoreDataAPI grabGlobalManagedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProfileInfo" inManagedObjectContext:context];
        NSManagedObject *profileInfo = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
        if (username) {
            [profileInfo setValue:username forKey:@"username"];
        }
        if (email) {
            [profileInfo setValue:email forKey:@"email"];
        }
        if (userID==0) {
            //For UserID pass 0 if no value has been registered yet
            [profileInfo setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
        }
        if (phoneNumber) {
            [profileInfo setValue:phoneNumber forKey:@"phonenumber"];
        }
        if (photo) {
            [profileInfo setValue:photo forKey:@"image"];
        }
        if (password) {
            [profileInfo setValue:password forKey:@"password"];
        }

        NSError *error = nil;
        [profileInfo.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Profile Info Save Failed");
            NSLog(@"%@, %@", error, error.localizedDescription);

            return false;
        }
        NSLog(@"Profile Info Save Successful");
        [[NSUserDefaults standardUserDefaults]setObject:@"CoreDataProfileFlag indicates there is already an existing Profile Info entitiy" forKey:@"CoreDataProfileInfoFlag"];
        return true;
    }
    NSLog(@"CoreDataProfileFlag indicates there is already an existing Profile Info entitiy");
    return false;
}

+(BOOL)updateProfileInformationModelWithUsername:(NSString *)username
                                           email:(NSString *)email
                                         userID :(int)userID
                                     phoneNumber:(NSString *)phoneNumber
                                    profilePhoto:(NSData *)photo
                                        password:(NSString *)password{
    
    
    NSArray *profileFetchResults = [self fetchProfileInfo];
    NSManagedObject *profileInfo = (NSManagedObject*)[profileFetchResults objectAtIndex:0];
    if (username) {
        [profileInfo setValue:username forKey:@"username"];
    }
    if (email) {
        [profileInfo setValue:email forKey:@"email"];
    }
    if (userID!=0) {
        //For UserID pass 0 if no value has been registered yet
        [profileInfo setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
    }
    if (phoneNumber) {
        [profileInfo setValue:phoneNumber forKey:@"phonenumber"];
    }
    if (photo) {
        [profileInfo setValue:photo forKey:@"image"];
    }
    if (password) {
        [profileInfo setValue:password forKey:@"password"];
    }

    NSError *error = nil;
    [profileInfo.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Profile Info Update Failed");
        NSLog(@"%@, %@", error, error.localizedDescription);

        return false;
    }
    
    NSLog(@"Profile Info Update Successful");
    return true;
    
}

+(BOOL)newEmojiPhotoModelWithEmojiString:(NSString*)emojiString
                                   emoji:(NSString *)emoji
                             emojiPhoto :(NSData *)photo{
    
    //If an emojiimage entitiy exists this method updates it, if not it creates an entity
    
    NSArray *emojiResult = [self fetchSpecificEmojiEntitiy:emoji];
    if ([emojiResult count]>0){
        //Update
        NSManagedObject *emojiEntity = (NSManagedObject *)[emojiResult objectAtIndex:0];
        [emojiEntity setValue:photo forKey:@"photo"];
        NSError *error = nil;
        [emojiEntity.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Emoji Update Failed");
            NSLog(@"%@, %@", error, error.localizedDescription);

        }
        else{
            NSLog(@"Emoji Update Succesful");
        }
    }else{
        //Create New Entry
        NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
        NSManagedObject *profInfo = (NSManagedObject *)[[self fetchProfileInfo] objectAtIndex:0];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmojiPhoto" inManagedObjectContext:context];
        NSManagedObject *emojiPhotoEntity = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
        
        [emojiPhotoEntity setValue:emojiString forKey:@"emojiString"];
        [emojiPhotoEntity setValue:emoji forKey:@"emoji"];
        [emojiPhotoEntity setValue:photo forKey:@"photo"];
        [emojiPhotoEntity setValue:profInfo forKey:@"profileInfo"];
        
        NSError *error = nil;
        [emojiPhotoEntity.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"Creating New Emoji Entity Failed");
            NSLog(@"%@, %@", error, error.localizedDescription);

            return false;
        }
        else{
            NSLog(@"Creating New Emoji Entity Succes");
            return true;
        }
    }
    return true;
}
@end
