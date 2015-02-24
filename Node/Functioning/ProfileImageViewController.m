//
//  ProfileImageViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
//#import "AFNetworking.h"
#import "ProfileImageViewController.h"

@interface ProfileImageViewController ()

@end

@implementation ProfileImageViewController{
 
    NSString * username;
    NSData *imageData;

}


- (void)viewDidLoad
{
   // self.image = [[UIImageView alloc]init];
    [super viewDidLoad];

    username = [[NSString alloc]init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    /*self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    //self.picker.wantsFullScreenLayout = YES;
    self.picker.delegate = self;*/
   // [self presentModalViewController:self.picker animated:NO];
    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }*/
/*- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.image.image = chosenImage;
    //input code here
    
    //post method and send username and photo
    imageData = UIImageJPEGRepresentation(self.image.image, 90);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imageData forKey:@"profilePhoto"];
    username = [defaults objectForKey:@"username"];
    [defaults synchronize];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)imageButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)lookUpPhoto:(id)sender {

        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    
}

- (IBAction)imageSubmit:(id)sender {
    //here we post the data
    
   //imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"purpleBubbleIcon.jpg"],90);
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"username"];
    [self AFPost];
    //[self postTest];
}
    -(void)postTest{
        //username = @"Dan";
        
        
        
        //SData *imageData = UIImageJPEGRepresentation("yourImage",0.2);     //change Image to NSData
        
        if (imageData != nil){
            NSLog(@"Testingtesting");
           NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/uploadProfilePic.php",username]];
            NSString *FileParamConstant = @"image_field";
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            //[request setURL:[NSURL URLWithString:]];
            [request setHTTPMethod:@"POST"];
            
            NSString *BoundaryConstant = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            /*
             now lets create the body of the post
             */
            NSMutableData *body = [NSMutableData data];
            if (imageData) {
                printf("appending image data\n");
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\'%@\'; filename=\".jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // set the content-length
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set URL
            [request setURL:requestURL];
            
            NSURLResponse *response = nil;
            NSError *err = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Response : %@",str);
            
            
            
            
            
            
        }
    }

-(void)AFPost{
   // username = @"Dan";
    NSLog(@"USERNAME:::::::%@",username);
    //username = @"Daniel";
    if(imageData){
        NSLog(@"image Data exists");
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/uploadProfilePic.php",username]]];
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
        

 
    /* NSLog(@"AFPOST RECOGNIZED");
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://104.131.53.146/"]];
    //NSDictionary *parameters = @{@"username": username};
    //NSLog(@"STEP 1");
    
    
    
    
    
    AFHTTPRequestOperation *op = [manager POST:@"uploadProfilePic.php" parameters:@{@"username" :username} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"profilePic" fileName:@"profilePhoto.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
     */
}
}



- (void)showcamera {
    self.picker = [[UIImagePickerController alloc] init];
    [self.picker setDelegate:self];
    [self.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.picker setAllowsEditing:YES];
    
    //[self presentModalViewController:self.picker animated:YES];
}














@end
