//
//  customizeGroup.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "customizeGroup.h"
#import "GroupCollectionViewCollectionViewController.h"
#import <dispatch/dispatch.h>
@interface customizeGroup ()

@end

@implementation customizeGroup{
    NSData *imageData;
    dispatch_queue_t queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addToGroupLabel.layer.cornerRadius = 20;
    self.addToGroupLabel.layer.masksToBounds = YES;
    
    self.deleteGroupLabel.layer.cornerRadius=20;
    self.deleteGroupLabel.layer.masksToBounds = YES;
    
    self.greyBackground.layer.cornerRadius=self.greyBackground.frame.size.width/2;
    self.greyBackground.layer.masksToBounds=YES;
    
    
    // Do any additional setup after loading the view.
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    self.profileImageView.image = [UIImage imageNamed:@"DeepMustacheTransparent.png"];
    
    dispatch_async(queue, ^{
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@/groupPic.jpg",self.topic]]];
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
                self.profileImageView.layer.masksToBounds=YES;
                self.profileImageView.image=[UIImage imageWithData:imageData];
            
        });
    
    });

 
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    //input code here
    
    //post method and send username and photo
    imageData = UIImageJPEGRepresentation(self.profileImageView.image, 90);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self AFPost];
    //[self createGroup];
    //[self createGroup];
    
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"checkGroupMembers"])
    {
        
        
        NSLog(@"All ABooad %@",self.topic);
        
        GroupCollectionViewCollectionViewController *vc = [segue destinationViewController];
        vc.topic=[NSString stringWithFormat:@"%@",self.topic];
        //AddAdditionalMembers *vc = [segue destinationViewController];
        //Fix this to go to the table view
        //vc.topic = [NSString stringWithFormat:@"%@",self.topic];
        //vc.addedMembers = [NSMutableArray arrayWithArray:addedMembers];
        
    }
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

- (IBAction)leaveGroup:(id)sender {
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/removeUserFromGroup.php?topic=%@&phone=%@",self.topic,phone];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if (strResult) {
        NSLog(@"str:: %@",strResult);
    }
    
    
    
}

- (IBAction)editPicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
@end
