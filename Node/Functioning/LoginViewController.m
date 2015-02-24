//
//  LoginViewController.m
//  Node
//
//  Created by Daniel Habib on 9/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "LoginViewController.h"
#import "BubbleTableViewController.h"

@interface LoginViewController (){
    NSString *userName;
    NSString *password;
    BOOL success;
    NSString *DeviceToken;
}
@end

@implementation LoginViewController


- (void)viewDidLoad
{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"username"];
    NSLog(@"%@",userName);
   
    success = NO;
   //userName = [[NSString alloc]init];
    //globalUserName = [[NSMutableString alloc]init];
    //userName = [[NSString alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{

    
     if(userName){
        [self postDeviceID];
        [self performSegueWithIdentifier:@"welcomeBackUserSegue" sender:self];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(id)sender {
    
    userName = _usernameTextField.text;
    password = _passwordTextField.text;

    
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"loginToTableView"]) {
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = YES;
        if([self postTest]){
            segueShouldOccur = YES; // you determine this
            
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               [defaults setObject:userName forKey:@"username"];
               [defaults synchronize];
            [self postDeviceID];
        }
        else{
            segueShouldOccur = NO;
        }
        
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Invalid username/password"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"loginToTableView"]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userName forKey:@"username"];
        [defaults synchronize];
        
    }
}


-(BOOL)postTest{
    NSLog(@"user: %@",userName);
    NSLog(@" PASS : %@", password);
    /*NSString *post = [NSString stringWithFormat:@"&user=%@&password=%@",userName,password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/login.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSError *error = nil;
    NSString *verify = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://104.131.53.146/login.php"] encoding:NSASCIIStringEncoding error:&error ];*/
    NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/login.php?username=%@&password=%@",userName,password];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Verification :%@",strResult);
    
    
    /*if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }*/
    NSString *verificationString =[strResult substringFromIndex: [strResult length] - 4];

    NSLog(@"%@",verificationString);
    if ([@"Pass" isEqualToString:verificationString]) {
        return  YES;
    }
      return NO;
}
-(void)postDeviceID{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DeviceToken = [defaults objectForKey:@"DeviceToken"];
     NSString *post = [NSString stringWithFormat:@"&username=%@&DeviceToken=%@",userName,DeviceToken];
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
