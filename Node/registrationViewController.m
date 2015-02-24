//
//  registrationViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/13/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "registrationViewController.h"
#import <dispatch/dispatch.h>

@interface registrationViewController (){
    NSString *email;
    NSString *username;
    NSString *password;
    NSString *passwordConfirmation;
    NSString *DeviceToken;
    NSString *phoneNumber;
    bool phone1FR;
    bool phone2FR;
    bool phone3FR;
    bool usernameFR;
    bool passwordFR;
    bool passwordConfFR;
    dispatch_queue_t queue;
    NSTimer *timer;
}

@end

@implementation registrationViewController

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}
- (void)viewDidLoad
{
//    timer = [NSTimer scheduledTimerWithTimeInterval:3
//                                             target:self
//                                           selector:@selector(verify)
//                                           userInfo:nil
//                                            repeats:YES];
    [super viewDidLoad];

    phone1FR=phone2FR=phone3FR=usernameFR=passwordConfFR=passwordFR=NO;
    
  //  self.createVerifLabel.userInteractionEnabled=NO;
    self.createVerifLabel.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:178.0/255.0 blue:92.0/255.0 alpha:1];
    self.phoneVerifImage.image=self.usernameVerifImage.image=self.passwordVerifImage.image=self.confirmPasswordVerifImage.image=[UIImage imageNamed:@"grayBackground.png"];
    self.phoneVerifImage.layer.cornerRadius=self.usernameVerifImage.layer.cornerRadius=self.passwordVerifImage.layer.cornerRadius=self.confirmPasswordVerifImage.layer.cornerRadius= self.phoneVerifImage.frame.size.width/2;
    self.phoneVerifImage.layer.masksToBounds=self.usernameVerifImage.layer.masksToBounds=self.passwordVerifImage.layer.masksToBounds=self.confirmPasswordVerifImage.layer.masksToBounds=YES;
    
    // Do any additional setup after loading the view.
    self.logo.layer.cornerRadius= self.logo.frame.size.width/2;
    self.logo.layer.masksToBounds=YES;
    self.usernameTextField.delegate=self.passwordTextField.delegate=self.passwordConfirmationTextField.delegate=self.phoneNumber.delegate=self.phoneNumber2.delegate=self.phoneNumber3.delegate=self;
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.background.bounds;

    [self.view sendSubviewToBack:self.background];
    [self.background addSubview:visualEffectView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.logo.layer.cornerRadius = self.logo.layer.frame.size.width/2;
    self.logo.layer.masksToBounds=YES;
}
-(BOOL)postTest{
    phoneNumber = [[self.phoneNumber.text stringByAppendingString:self.phoneNumber2.text] stringByAppendingString:self.phoneNumber3.text] ;
    
    
    [self cleanThePhoneNumber];
    //email = _emailTextField.text;
    username = _usernameTextField.text;
    password = _passwordTextField.text;
    passwordConfirmation = _passwordConfirmationTextField.text;
    
    if ([password isEqualToString:passwordConfirmation] && [password length ] > 3){
     //   if ([self.phoneNumber.text length]==3) {
            
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        DeviceToken = [defaults objectForKey:@"DeviceToken"];
    
    NSLog(@"phone number : %@",_phoneNumber.text);
    NSLog(@"email :%@",email);
    NSLog(@"username :%@",username);
    NSLog(@"password :%@",password);
    NSLog(@"passwordConfirmation :%@",passwordConfirmation);
    NSLog(@"Device Token");
    NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@&email=%@&phoneNumber=%@",username,password,email,[[self.phoneNumber.text stringByAppendingString:self.phoneNumber2.text] stringByAppendingString:self.phoneNumber3.text]];
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
        
        
        return  YES;
        }
    
    else{
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Alert"
                                     message:@"passwords don't match or you didn't format a phone number correctly"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        // shows alert to user
        [notPermitted show];
        
        return NO;
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   

    //[self verify:string];

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
-(void)verify:(NSString *)string{
    
    
    
    
    
    
    queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        NSLog(@"keystroke rec");
        if ([self.phoneNumber.text  length]==3 ) {
            if ([self.phoneNumber2.text length] ==3) {
                if ([self.phoneNumber3.text length] == 4) {
                    NSLog(@"Verification is one keystroke behind");
                    NSLog(@"prior to dispatch");
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSLog(@"After Dispatch");
                        phone1FR=true;
                        self.phoneVerifImage.image=[UIImage imageNamed:@"green.jpeg"];
                    });
                }
                else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        phone1FR=false;
                        self.phoneVerifImage.image=[UIImage imageNamed:@"grayBackground.png"];
                    });
                }
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    phone1FR=false;
                    self.phoneVerifImage.image=[UIImage imageNamed:@"grayBackground.png"];
                });
            }
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                phone1FR=false;
                self.phoneVerifImage.image=[UIImage imageNamed:@"grayBackground.png"];
            });
        }
        
        
        
    });
    
    dispatch_async(queue, ^{
        if ([self.usernameTextField.text length]>2){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameVerifImage.image =[UIImage imageNamed:@"green.jpeg"];
                usernameFR=true;
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                usernameFR=false;
                self.usernameVerifImage.image =[UIImage imageNamed:@"grayBackground.png"];
            });
            
        }
        
    });
    dispatch_async(queue, ^{
        if ([self.passwordTextField.text length] >2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.passwordVerifImage.image=[UIImage imageNamed:@"green.jpeg"];
                
            });
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.passwordVerifImage.image=[UIImage imageNamed:@"grayBackground.png"];
            });
        }
    });
    dispatch_async(queue, ^{
        if ([self.passwordConfirmationTextField.text length] >1) {
            
            
            if ([[self.passwordTextField.text substringWithRange:NSMakeRange(0, [self.passwordConfirmationTextField.text length]-1)] isEqualToString: [self.passwordConfirmationTextField.text substringWithRange:NSMakeRange(0, [self.passwordTextField.text length]-1)]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    passwordConfFR=true;
                    self.confirmPasswordVerifImage.image=[UIImage imageNamed:@"green.jpeg"];
                    
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.confirmPasswordVerifImage.image=[UIImage imageNamed:@"gray.jpeg"];
                    
                    
                });
            }
        }
        else{
            passwordConfFR=false;
        }
        
    });
    
    
    
    
    if (phone1FR) {
        if (usernameFR) {
            if (passwordConfFR) {
                self.createVerifLabel.userInteractionEnabled=YES;
                self.createVerifLabel.backgroundColor = [UIColor greenColor];
            }
            else{
                self.createVerifLabel.backgroundColor = [UIColor redColor];
                self.createVerifLabel.userInteractionEnabled = YES;
            }
        }
        else{
            self.createVerifLabel.backgroundColor = [UIColor redColor];
            self.createVerifLabel.userInteractionEnabled = YES;
        }
    }
    else{
        self.createVerifLabel.backgroundColor = [UIColor redColor];
        self.createVerifLabel.userInteractionEnabled = YES;
    }
    
    
    
}
-(void)cleanThePhoneNumber{
    NSString *phoneNumber1 = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",_phoneNumber.text]];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"+1" withString:@""];
    phoneNumber = phoneNumber1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNumber forKey:@"phoneNumber"];
    
    
}

- (IBAction)registrationButton:(id)sender {
    if([self postTest]){
        [self performSegueWithIdentifier:@"ToLogin" sender:self];
    }
}
@end
