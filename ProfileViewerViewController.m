//
//  ProfileViewerViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ProfileViewerViewController.h"

@interface ProfileViewerViewController ()

@end

@implementation ProfileViewerViewController{
    NSString * username;
    NSData *imageData;
    NSString *phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];

 
    
    _contactsLabel.layer.cornerRadius = 20;
    _contactsLabel.layer.masksToBounds = YES;
    _settingsLabel.layer.cornerRadius = 20;
     _settingsLabel.layer.masksToBounds = YES;
    
    _grayBackground.layer.cornerRadius = _grayBackground.frame.size.width/2;
    _grayBackground.layer.masksToBounds = YES;
   // [self.view sendSubviewToBack:_grayBackground];
    [self.view sendSubviewToBack:_bluebackgound];
//[self.view bringSubviewToFront:self.]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"username" ];
    phone = [defaults objectForKey:@"phoneNumber"];
    self.nameLabel.text  = [NSString stringWithFormat:@"-%@-",username];
    NSLog(@"testing:::%@",username);
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",phone]]];
    //[self.view bringSubviewToFront:_settingsLabel];
    //[self.view bringSubviewToFront:_contactsLabel];
    
  /*  UITapGestureRecognizer* tapSettings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTap)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_settingsLabel setUserInteractionEnabled:NO];
    [_settingsLabel addGestureRecognizer:tapSettings];
    
    UITapGestureRecognizer* tapContacts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactsTap)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_contactsLabel setUserInteractionEnabled:NO];
    [_contactsLabel addGestureRecognizer:tapContacts];*/
    
                       
                       
                       //initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",username]]]]];


   // self.customizationCollection.
    

}
-(void)viewDidAppear:(BOOL)animated{
   // self.profilePic = [[UIImageView alloc] init];
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.image = [UIImage imageWithData:imageData];
    [self.view bringSubviewToFront:self.profilePic];
    
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
    username = [defaults objectForKey:@"username"];
    phone = [defaults objectForKey:@"phoneNumber"];
    [defaults synchronize];
    [self AFPost];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
   
}
-(void)AFPost{
    // username = @"Dan";
    NSLog(@"USERNAME:::::::%@",username);
    //username = @"Daniel";
    if(imageData){
        NSLog(@"image Data exists");
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@",phone]]];
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
        
        
        
    }}
@end
