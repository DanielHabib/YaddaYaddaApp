//
//  EmojiPictureChangeViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "EmojiPictureChangeViewController.h"
//#import "AFNetworking.h"
@interface EmojiPictureChangeViewController ()

@end

@implementation EmojiPictureChangeViewController{
    NSString *username;
    NSData *imageData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"emojiTYPE:%@",self.emojiType);
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"username"];
    
    
    
    if(!self.emojiType){
        self.emojiType = @"sleepy";
    }
    
    
    // self.image = [[UIImageView alloc]init];
    [super viewDidLoad];
    
   // username = [[NSString alloc]init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    // Do any additional setup after loading the view.
}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)takeImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)Submit:(id)sender {
    [self AFPost];
}

- (IBAction)Gallery:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}






- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    //input code here
    
    //post method and send username and photo
    imageData = UIImageJPEGRepresentation(self.imageView.image, 90);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)AFPost{
    
    if(imageData){
        NSLog(@"image Data exists");
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/%@",username,self.emojiType]]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
        NSDictionary *parameters = @{@"message": @"test"};
        AFHTTPRequestOperation *op = [manager POST:@"uploadEmojiPicture.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"emojiPicture.jpg"] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
        
    }}


@end
