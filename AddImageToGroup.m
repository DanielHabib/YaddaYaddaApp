//
//  AddImageToGroup.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/8/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "AddImageToGroup.h"
#import <dispatch/dispatch.h>
@interface AddImageToGroup ()

@end

@implementation AddImageToGroup{

NSString * username;
NSData *imageData;
BOOL Switch;
dispatch_queue_t queue;

NSString *topicHolder;

}
#pragma mark  - IMAGE STUFF


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    //input code here
    
    //post method and send username and photo
    imageData = UIImageJPEGRepresentation(self.imageView.image, 60);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
        [picker dismissViewControllerAnimated:YES completion:NULL];
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        
        [self AFPost];
    });
    
  
    
        //[self createGroup];
    //[self createGroup];
    
}






- (void)viewDidLoad
{
    
    
    //self.Finished.alpha = 0;
    //self.Finished.userInteractionEnabled = NO;
    Switch = true;
    
    for (NSString *phone in self.addedMembers) {
        NSLog(@"%@",phone);
    }
    topicHolder = self.topic;
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.image = [UIImage imageNamed:@"greenBubbleLogo.png"];
    
    imageData = UIImageJPEGRepresentation(self.imageView.image, 90);
    
    NSLog(@"Topic Train choo choo mutha fucka:%@",self.topic);
    self.topicLabel.text = self.topic;
    // self.image = [[UIImageView alloc]init];
    [super viewDidLoad];
    
    username = [[NSString alloc]init];
    username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
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
    
    
    
    [self postTest];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(addMembersToGroup)
                                   userInfo:nil
                                    repeats:NO];

    //[self addMembersToGroup];

    
    //[self addMembersToGroup];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_sync(queue, ^{
       
                
    });
    
    dispatch_sync(queue, ^{
        
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(AFPost)
                                       userInfo:nil
                                        repeats:NO];
    });
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
    self.topicLabel.text=[self.topic stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupCreated"])
    {
       // [self createGroup];
        
        //[self postTest];

        //[self AFPost];
        
        
        queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^{
            
         //           [self addMembersToGroup];

        });
        
    }
}


-(void)postTest{
    
    
    NSLog(@"Train stops here : %@",self.topic);
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
    NSString *post = [NSString stringWithFormat:@"&topic=%@&username=%@",[self.topic stringByReplacingOccurrencesOfString:@" " withString:@"_"],username];
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
    });
        
        
        
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

-(void)createGroup{
    [self postTest];
    [self addMembersToGroup];
    [self AFPost];
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
-(void)addMembersToGroup{
    
    
    for (NSString *phoneNumber in self.addedMembers) {
        
        NSLog(@"self.topic ==%@",self.topic);
        
       /* NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/addMembersToGroup.php?phoneNumber=%@&topic=%@",phoneNumber,self.topic];
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
        */
       // NSLog(@"%@",strResult);
        
//        NSLog(@"phone::%@",phoneNumber);
//        NSLog(@"TOPIC::%@",self.topic);
//        //NSString *topico = [[NSString alloc ]initWithString: self.topic];
//        
//        NSString *post = [NSString stringWithFormat:@"&phoneNumber=%@&topic=%@",phoneNumber,self.topic];
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
//            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/addMembersToGroup.php"]]];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPBody:postData];
//        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
//    if(conn) {
//        NSLog(@"Connection Successful");
//    } else {
//        NSLog(@"Connection could not be made");
//        }
//    }
        
        NSString *post = [NSString stringWithFormat:@"&topic=%@&phoneNumber=%@",topicHolder,phoneNumber];
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
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }

    
}


}





@end
