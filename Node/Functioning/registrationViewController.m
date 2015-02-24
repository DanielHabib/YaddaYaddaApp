//
//  registrationViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/13/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "registrationViewController.h"

@interface registrationViewController (){
    NSString *email;
    NSString *username;
    NSString *password;
    NSString *passwordConfirmation;
    NSString *DeviceToken;
}

@end

@implementation registrationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)postTest{
    email = _emailTextField.text;
    username = _usernameTextField.text;
    password = _passwordTextField.text;
    passwordConfirmation = _passwordConfirmationTextField.text;
    if ([password isEqualToString:passwordConfirmation]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        DeviceToken = [defaults objectForKey:@"DeviceToken"];
    
    
    NSLog(@"email :%@",email);
    NSLog(@"username :%@",username);
    NSLog(@"password :%@",password);
    NSLog(@"passwordConfirmation :%@",passwordConfirmation);
    NSLog(@"Device Token");
    NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@&email=%@",username,password,email];
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
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
    [textField resignFirstResponder];
    
}

-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([self isCorrectTypeOfString:string]){
        return YES;
    }
    return YES;
}

#pragma mark- Helpers
#pragma mark Helpers
-(void)processReturn{
    
    
    
    
    //[myWorld removeChildrenInArray:@[createdNode]];
    
    
}

-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    return NO;
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

- (IBAction)registrationButton:(id)sender {
    [self postTest];
}
@end
