//
//  InvitationPage.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/10/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "InvitationPage.h"
@interface InvitationPage ()

@end

@implementation InvitationPage{
    NSString * addressBookNum;
    CFArrayRef allPeople;
    ABAddressBookRef addressBook;
}

















- (void)viewDidLoad {
    [super viewDidLoad];
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            addressBook = ABAddressBookCreate( );
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        CFErrorRef *error = NULL;
        addressBook = ABAddressBookCreateWithOptions(NULL, error);
        allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSLog(@"all people %@",allPeople);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
             NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            // NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            // NSLog(@"Name:%@ %@", firstName, lastName);
            NSLog(@"firstname : %@",firstName);
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            [[UIDevice currentDevice] name];
            
            //NSLog(@"\n%@\n", [[UIDevice currentDevice] name]);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                
                addressBookNum = [addressBookNum stringByAppendingFormat: @":%@",phoneNumber];
            }  
        }
        NSLog(@"AllNumber:%@",addressBookNum);
    }
    
    
    
    else {
        // Send an alert telling user to change privacy setting in settings app
    }

    
    
    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);

    return  numberOfPeople;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
   
    
    ABRecordRef person = CFArrayGetValueAtIndex( allPeople, indexPath.row);

    
    
     NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    //NSString *phoneNumber = (_bridge NSString *)(ABRecordCopyValue(person, kABPersonPhoneProperty));
    
    NSLog(@"%@",firstName);
    cell.textLabel.text = firstName;

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"InvToImage"])
    {
        
        
        
        NSLog(@"All ABooadt %@",self.topic);
        AddImageToGroup *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];
    }
}


@end
