//
//  AddAdditionalMembers.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "AddAdditionalMembers.h"

@interface AddAdditionalMembers ()

@end

@implementation AddAdditionalMembers{
    NSString * addressBookNum;
    CFArrayRef allPeople;
    ABAddressBookRef addressBook;
    NSMutableArray *addedMembers;
    NSMutableArray *listOfPhoneNumbers;
    NSMutableArray *selected;
    dispatch_queue_t queue;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *MemberList;
    NSString *element;
    
    NSMutableString *memberNumberUpdate;
    NSMutableString *usernameUpdate;
}



- (void)viewDidLoad {
    
    MemberList = [[NSMutableArray alloc]init];
    addedMembers = [[NSMutableArray alloc]init];
    selected = [[NSMutableArray alloc]init];
    [self runXMLParse];
    [super viewDidLoad];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        //bool beenSelected = NO;
        
        
        addedMembers = [[NSMutableArray alloc]init];
        listOfPhoneNumbers = [[NSMutableArray alloc]init];
        
//        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//        
//        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//                addressBook = ABAddressBookCreate( );
//            });
//        }
//        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//            
//            CFErrorRef *error = NULL;
//            addressBook = ABAddressBookCreateWithOptions(NULL, error);
//            allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//            NSLog(@"all people %@",allPeople);
//            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
//            
//            
//            NSString *number = @"0";
//            
//            for(int i = 0; i < numberOfPeople; i++) {
//                
//                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
//               // [selected addObject:number];
//                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//                // NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
//                // NSLog(@"Name:%@ %@", firstName, lastName);
//                NSLog(@"firstname : %@",firstName);
//                ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
//                [[UIDevice currentDevice] name];
//                
//                //NSLog(@"\n%@\n", [[UIDevice currentDevice] name]);
//                
//                for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
//                    NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
//                    
//                    addressBookNum = [addressBookNum stringByAppendingFormat: @":%@",phoneNumber];
//                }
//            }
//            NSLog(@"AllNumber:%@",addressBookNum);
//        }
//        
//        
//        
//        else {
//            // Send an alert telling user to change privacy setting in settings app
//        }
//        
//        
  });
//    
//    
//    
//    
//    
//    
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    //sleep(1);
//
//    
//
//    
//    
//    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return  [MemberList count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    // UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    
    //imageView.image=[UIImage imageNamed:@"addIn.png"];
    
    
    
    
    NSString* phone ;
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    
    NSString *username;
    
    
    phone = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
    username= [[MemberList objectAtIndex:indexPath.row] objectForKey:@"username"];
    __block NSData *imageData;
    //Recipe *recipe = [recipes objectAtIndex:indexPath.row];
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:20];
    profileImageView.layer.cornerRadius=profileImageView.frame.size.width/2;
    profileImageView.layer.masksToBounds=YES;
    profileImageView.image= [UIImage imageNamed:@"blueToPurpleGradient.png"];
    
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",phone]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_sync(queue, ^{
                if (imageData) {
                    profileImageView.image= [UIImage imageWithData:  imageData];
                }
            });
            profileImageView.image =   [UIImage imageWithData:imageData];
            
        });
        
        
        
    });
    
    UILabel *NameLabel = (UILabel *)[cell viewWithTag:30];
    NameLabel.text = username;
    
    
    UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
    
    if ([[selected objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        addedImageView.image=[UIImage imageNamed:@"memberAdded"];
    }
    else{
        addedImageView.image = [UIImage imageNamed:@"addIn.png"];
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

     NSString *phone = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
    if ([[selected objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
       
        
        [addedMembers addObject:phone];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
        addedImageView.image = [UIImage imageNamed:@"memberAdded.png"];
        NSString *number = @"1";
        [selected setObject:number atIndexedSubscript:indexPath.row];
        [self addMembersToGroup:phone];

    }
    else{
        [addedMembers removeObjectIdenticalTo:phone];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
        addedImageView.image = [UIImage imageNamed:@"addIn.png"];
        NSString *number = @"0";
        [selected setObject:number atIndexedSubscript:indexPath.row];
        
        
    }
    //}
    
    //Add in + animation----------------------------------------------------
    
    //topic = [TopicList objectAtIndex:indexPath.row];
    // [self performSegueWithIdentifier:@"sceneSegue" sender:self];
    
    
    //Add in + animation----------------------------------------------------
    
    //topic = [TopicList objectAtIndex:indexPath.row];
    // [self performSegueWithIdentifier:@"sceneSegue" sender:self];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */



-(NSString *)cleanThePhoneNumber:(NSString *)phoneNumber{
    NSString *phoneNumber1 = [NSString stringWithFormat:phoneNumber];
    
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"+1" withString:@""];
    
    return phoneNumber1;
}



-(BOOL)postTest:(NSString *)phoneNumber{
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/checkPhoneNumber.php?phoneNumber=%@",phoneNumber];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Verification :%@",strResult);
    
    
    /*if(conn) {
     NSLog(@"Connection Successful");
     } else {
     NSLog(@"Connection could not be made");
     }*/
    
    if ([strResult length] > 3) {
        
    
    NSString *verificationString =[strResult substringFromIndex: [strResult length] - 4];
    
    
    NSLog(@"%@",verificationString);
    if ([@"Pass" isEqualToString:verificationString]) {
        return  YES;
    }
    }
    return NO;
    
}
-(void)addMembersToGroup:(NSString *)phoneNumber{
    
    
    //for (NSString *phoneNumber in self.addedMembers) {
        NSLog(@"phone::%@",phoneNumber);
        NSLog(@"TOPIC::%@",self.topic);
        
        NSString *post = [NSString stringWithFormat:@"&phoneNumber=%@&topic=%@",phoneNumber,self.topic];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/addMembersToGroup.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful bruh");
        } else {
            NSLog(@"Connection could not be made");
        }
    }
    





-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/allMembers.php"]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"Members"]) {
        item    = [[NSMutableDictionary alloc] init];
        memberNumberUpdate  = [[NSMutableString alloc] init];
        usernameUpdate =[[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    if ([element isEqualToString:@"phoneNumber"]) {
        [memberNumberUpdate appendString:string];
        
    }
    else if ([element isEqualToString:@"username"]){
        [usernameUpdate appendString:string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Members"]) {
        NSLog(@"memberNumberUpdate::%@",memberNumberUpdate);
        NSLog(@"usernameUpdate: %@",usernameUpdate);
        [item setObject:memberNumberUpdate forKey:@"phoneNumber"];
        [item setObject:usernameUpdate forKey:@"username"];
        [MemberList addObject:item];//The problem lies in add objects
        [selected addObject:@"0"];
    }}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"error occured");
    NSLog(@"PARSE ERROR %@",parseError );
    
};






@end
