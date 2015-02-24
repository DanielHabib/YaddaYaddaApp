//
//  AddImageToGroup.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/8/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "AddImageToGroup.h"

@interface AddImageToGroup ()

@end

@implementation AddImageToGroup{

NSString * username;
NSData *imageData;
BOOL Switch;

}
#pragma mark  - IMAGE STUFF


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






- (void)viewDidLoad
{
    
    
    Switch = true;
    
    NSLog(@"Topic Train choo choo mutha fucka:%@",self.topic);
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





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupCreated"])
    {
        
        
        //[self postTest];

        //[self AFPost];
        
        
    }
}


-(void)postTest{
    
    NSLog(@"Train stops here : %@",self.topic);
    
    NSString *post = [NSString stringWithFormat:@"&topic=%@",[self.topic stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/newTopic.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}
- (IBAction)Submit:(id)sender {
    if (Switch) {
        
    [self postTest];
    [self AFPost];
    
    }
    Switch = true;
    
}

-(void)AFPost{

    if(imageData){
        NSLog(@"image Data exists");
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@",self.topic]]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
        NSDictionary *parameters = @{@"message": @"test"};
        AFHTTPRequestOperation *op = [manager POST:@"uploadGroupPic.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"groupPic.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
        
    }}
    





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
- (IBAction)GalleryButton:(id)sender {
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (IBAction)CameraButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
@end
