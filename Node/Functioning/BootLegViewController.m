//
//  BootLegViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/19/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BootLegViewController.h"

@interface BootLegViewController (){
    NSData *DeviceToken;
    NSString *deviceToken;
    NSString *username;
}

@end

@implementation BootLegViewController

- (void)viewDidLoad
{
   /* //NSLog(@"test");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DeviceToken = [defaults objectForKey:@"DeviceToken"];
    //NSLog(@"DeVICE ToKEN::::::%@",DeviceToken.description);
    NSLog(@"Nospaces:%@",DeviceToken);
    //NSString *username = [defaults objectForKey:@"username"];
    //[defaults removeObjectForKey:@"username"];*/
    [super viewDidLoad];
    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"username"];
    
    
    NSLog(@"username is :%@",username);
    if ([username isEqualToString:@""]){
                [self performSegueWithIdentifier:@"startToLogin" sender:self];

    }
    else if (!username){
        [self performSegueWithIdentifier:@"startToLogin" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"startToTableView" sender:self];
        [self postDeviceID];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)postTest{
   
    
    
    

        
       /* NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@&email=%@",username,password,email];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/registration.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        // NSString *isValid =[NSString stringwit]
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }
    }
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
*/}
-(void)postDeviceID{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DeviceToken = [defaults objectForKey:@"DeviceToken"];
    NSString *post = [NSString stringWithFormat:@"&username=%@&DeviceToken=%@",username,DeviceToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateDeviceToken.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    // NSString *isValid =[NSString stringwit]
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}



@end
