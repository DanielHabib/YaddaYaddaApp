//
//  LoginViewController.m
//  Node
//
//  Created by Daniel Habib on 9/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
#import <dispatch/dispatch.h>
#import "LoginViewController.h"
#import "BubbleTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CoreDataAPI.h"

@interface LoginViewController () <FBLoginViewDelegate> {
    NSString *userName;
    NSString *email;
    NSString *password;
    NSMutableString *phoneNumber;
    NSMutableString *phoneNumberUpdate;
    BOOL success;
    NSString *DeviceToken;
    dispatch_queue_t queue;

}
@end

@implementation LoginViewController{
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSString *element;
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    
}


// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"user officially loggedd in");

    [self performSegueWithIdentifier:@"loginToTableView" sender:self];
    
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (void)viewDidLoad
{
    FBLoginView *loginView =     [[FBLoginView alloc] initWithReadPermissions:
                                  @[@"public_profile", @"email", @"user_friends"]];
    loginView.center = CGPointMake(self.view.center.x, self.view.center.y-loginView.frame.size.width/2);
    loginView.delegate=self;
    [self.view addSubview:loginView];
    
    self.logoSpot.layer.cornerRadius=self.logoSpot.frame.size.width/2;
    self.logoSpot.layer.masksToBounds = YES;
    
    queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"username"];
    password = [defaults objectForKey:@"password"];
    [self runXMLParse];
        
    });

    success = NO;
   
    
    
    
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.background.bounds;
    [self.background addSubview:visualEffectView];
  
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view sendSubviewToBack:self.background];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    
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
    email  = _usernameTextField.text;
    
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"loginToTableView"]) {
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = YES;
        if([self postTest]){
            segueShouldOccur = YES; // you determine this
            [self runXMLParse];
            //[self setDefaults];
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
            [self runXMLParse];
            [notPermitted show];
            // prevent segue from occurring
            return NO;
        }
    }
    
    [CoreDataAPI newProfileInformationWithUsername:userName email:email userID:0 phoneNumber:nil profilePhoto:nil password:password];

    return YES;
}



/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"loginToTableView"]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userName forKey:@"username"];
        [defaults synchronize];
        
    }
}
*/

-(BOOL)postTest{
    //NSLog(@"user: %@",userName);
    //NSLog(@" PASS : %@", password);
    
    
    
    //PHONE NUMBER IS HARD CODED
   // phoneNumber = [NSMutableString stringWithFormat:@"9088128365"];
    //NSLog(@"phoneNumber : %@",phoneNumber);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:userName forKey:@"username"];
    [defaults setObject:password forKey:@"password"];
    [defaults setObject:phoneNumber forKey:@"phoneNumber"];
    [defaults synchronize];
    
    NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/login.php?email=%@&password=%@",email,password];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Verification :%@",strResult);
    /*if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }*/
    if ([strResult length]>3) {
        
    
    NSString *verificationString =[strResult substringFromIndex: [strResult length] - 4];

    NSLog(@"%@",verificationString);
        
    if ([@"Pass" isEqualToString:verificationString]) {
        [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return  YES;
    }
    }
      return NO;
}
-(void)postDeviceID{
    
    if (DeviceToken) {
        
    
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



}






-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/getPhoneNumber2.php?username=%@",userName]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    if ([element isEqualToString:@"profileInfo"]) {
        item    = [[NSMutableDictionary alloc] init];
        phoneNumberUpdate  = [[NSMutableString alloc] init];
        
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
   // NSLog(@"Step 1");
    if ([element isEqualToString:@"phoneNumber"]) {
        [phoneNumberUpdate appendString:string];
        // NSLog(@"%@",topic);
        //NSLog(@"Found User");
        //NSLog(@"title element found – create a new instance of Title class...");
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // NSLog(@"3");
    if ([elementName isEqualToString:@"profileInfo"]) {
        [item setObject:phoneNumberUpdate forKey:@"phoneNumber"];
        phoneNumber = phoneNumberUpdate;
        NSLog(@"Phone Number recognized :%@",phoneNumber);
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
        //[TopicList addObject:[topic copy]];//The problem lies in add objects
        
    }}





@end
