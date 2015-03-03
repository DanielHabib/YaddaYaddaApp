//
//  ProfileViewerViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ProfileViewerViewController.h"
#import "CoreDataAPI.h"
@interface ProfileViewerViewController ()

@end

@implementation ProfileViewerViewController{
    NSXMLParser *parser;
    NSString * username1;
    NSData *imageData;
    NSString *phone;
    NSString *email;
    NSMutableDictionary *item;
    NSMutableString *usernameUpdate;
    NSString *element;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _contactsLabel.layer.cornerRadius = 20;
    _contactsLabel.layer.masksToBounds = YES;
    _settingsLabel.layer.cornerRadius = 20;
    _settingsLabel.layer.masksToBounds = YES;
    
    _grayBackground.layer.cornerRadius = _grayBackground.frame.size.width/2;
    _grayBackground.layer.masksToBounds = YES;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
    self.profilePic.layer.masksToBounds = YES;
    //[self.view sendSubviewToBack:_grayBackground];
    [self.view sendSubviewToBack:_bluebackgound];
    //[self.view bringSubviewToFront:self.]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username1 = [defaults objectForKey:@"username"];
    phone = [defaults objectForKey:@"phoneNumber"];
    email = [defaults objectForKey:@"email"];
    [self pullInfo];
    NSLog(@"testing:::%@",username1);

    NSArray *result = [CoreDataAPI fetchProfileInfo];

    
    ProfileInfo *profInfo = [result objectAtIndex:0];
    imageData = profInfo.image;
    if (imageData) {
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^{
            
            imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",email]]];
            profInfo.image = imageData;
            [CoreDataAPI updateProfileInformationWithUsername:nil email:nil userID:0 phoneNumber:nil profilePhoto:imageData password:nil];
        });

    }
    self.profilePic.image = [UIImage imageWithData:imageData];
    
    

    
    
    [self.username setDelegate:self];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)pullInfo{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ProfileInfo *profInfo = [[CoreDataAPI fetchProfileInfo]objectAtIndex:0];

    self.username.text = profInfo.username;
    dispatch_async(queue,^{
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/pullUserInfo.php?email=%@",email]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
      
        
        
    });


}

-(void)viewDidAppear:(BOOL)animated{
    self.profilePic.image = [UIImage imageWithData:imageData];
    [self setUpObserver];
    [self.view bringSubviewToFront:self.profilePic];
    
}
-(void)detectSingleTap:(UITapGestureRecognizer *)tapRec{
    if ([self.username isFirstResponder]) {
        
        [self newUsername];
        [self.username resignFirstResponder];
        
    }
}

-(void)settingsTap{
    NSLog(@"settings Tapped");
    [self shouldPerformSegueWithIdentifier:@"settings" sender:self];
}
-(void)contactsTap{
    NSLog(@"contacts Tapped");
    [self shouldPerformSegueWithIdentifier:@"whatsNext" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeProfilePicture:(id)sender {
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = chosenImage;
    //input code here
    
    //post method and send username and photo
    imageData = UIImageJPEGRepresentation(self.profilePic.image, 90);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imageData forKey:@"profilePhoto"];
    email = [defaults objectForKey:@"email"];
    phone = [defaults objectForKey:@"phoneNumber"];
    [defaults synchronize];
    [self AFPost];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
   
}
-(void)AFPost{

    if(imageData){
        NSLog(@"image Data exists");
        [CoreDataAPI updateProfileInformationWithUsername:nil email:nil userID:0 phoneNumber:nil profilePhoto:imageData password:nil];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@",email]]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
        NSDictionary *parameters = @{@"message": @"test"};
        AFHTTPRequestOperation *op = [manager POST:@"uploadProfilePic.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"profilePic.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self processReturn];

    return YES;
    
}
-(void)newUsername{
    email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/updateUsername.php?email=%@&username=%@",email,self.username.text];
    NSLog(@"Username =>>%@",self.username.text);
    //[[NSUserDefaults standardUserDefaults]setObject:self.username.text forKey:@"username"];
    [CoreDataAPI updateProfileInformationWithUsername:self.username.text email:nil userID:0 phoneNumber:nil profilePhoto:nil password:nil];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
}
-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

   // NSString *newString = [textedField.text stringByReplacingCharactersInRange:range withString:string];
    //uITextView.text = newString;//edits it live
    
    if([self isCorrectTypeOfString:string]){
        return YES;
        
    }
    return YES;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    NSLog(@"::::::::%@",element);
    if ([element isEqualToString:@"User"]) {
        usernameUpdate = [[NSMutableString alloc]init];
    }
}

//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    if ([element isEqualToString:@"username"]) {
        [usernameUpdate appendString:string];
        self.username.text=usernameUpdate;
        [CoreDataAPI updateProfileInformationWithUsername:usernameUpdate email:nil userID:0 phoneNumber:nil profilePhoto:nil password:nil];
        [[NSUserDefaults standardUserDefaults]setObject:usernameUpdate forKey:@"username"];
        NSLog(@"self.username::%@",usernameUpdate);
    }
}
// CLEAN THIS PARSING UP TO FIX THE INCORRECT GROUP MATCHING PROBLEM
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Topics"]) {
//        this is the questionable part
//        [item setObject:topic forKey:@"topic"];
//        [TopicList addObject:[topic copy]];//The problem lies in add objects
//        [groupIDList addObject:[groupIDUpdate copy]];
        
    }
}
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError{
    NSLog(@"parse error");
    
}


#pragma mark -
#pragma mark Helpers
-(void)processReturn{
    [self.username resignFirstResponder];
    [self newUsername];
    [CoreDataAPI updateProfileInformationWithUsername:self.username.text email:nil userID:0 phoneNumber:nil profilePhoto:nil password:nil];
}
- (void)setUpObserver
{
//    // This could be in an init method.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardArrived:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardLeft:) name:UIKeyboardDidHideNotification object:nil];
}
-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    
    return NO;
}

@end
