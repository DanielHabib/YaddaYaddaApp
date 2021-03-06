//
//  StartUpVC.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 11/3/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "StartUpVC.h"
#import "BubbleTableViewController.h"
#import "LoginViewController.h"
#import "YaddaYaddaNavigationViewController.h"
#import "AppDelegate.h"
#import "CoreDataAPI.h"

@interface StartUpVC (){
    NSString *userName;
    NSString *password;
    NSString *phoneNumber;
    NSString *DeviceToken;
    NSString *email;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSString *element;
    NSMutableString *phoneNumberUpdate;
    dispatch_queue_t queue;
    
    NSArray *coreDataTableViewArray;
}

@end

@implementation StartUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    coreDataTableViewArray = [[NSArray alloc]init];
    

    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DeviceToken = [defaults objectForKey:@"DeviceToken"];
    email = [defaults objectForKey:@"email"];
    
    NSString *post = [NSString stringWithFormat:@"&email=%@&DeviceToken=%@",email,DeviceToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateDeviceToken.php"]]];
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
    
    
    //[self postTest];
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"username"];
    password = [defaults objectForKey:@"password"];
        email = [defaults objectForKey:@"email"];
//        if (![defaults objectForKey:@"bubbleColor"]) {
//            [defaults setObject:[NSMutableString stringWithString:@"b5aaa4"] forKey:@"bubbleColor"];
//        }
//        if (![defaults objectForKey:@"pathStyle"]) {
//            [defaults setObject:@"straight" forKey:@"pathStyle"];
//
//        }
//        if (![defaults objectForKey:@"pathColor"]) {
//            [defaults setObject:@"000000" forKey:@"pathColor"];
//        }
        
        
        
    //
    //[self runXMLParse];
        
        
    });

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          //[self sessionStateChanged:session state:state error:error];
                                      }];
        [self performSegueWithIdentifier:@"welcomeBackUserSegue" sender:self];
    }
    else if (email){
        [self performSegueWithIdentifier:@"welcomeBackUserSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)postTest{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:userName forKey:@"username"];
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
    if ([strResult length] <4) {
        
    }
    else{
    NSString *verificationString =[strResult substringFromIndex: [strResult length] - 4];
    
    NSLog(@"%@",verificationString);
    if ([@"Pass" isEqualToString:verificationString]) {
        return  YES;
    }
    }
    return NO;
}

-(void)postDeviceID{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DeviceToken = [defaults objectForKey:@"DeviceToken"];
    NSString *post = [NSString stringWithFormat:@"&email=%@&DeviceToken=%@",email,DeviceToken];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"welcomeBackUserSegue"]) {
        YaddaYaddaNavigationViewController *vc = [segue destinationViewController];
        //vc.managedObjectContext = self.managedObjectContext;
    }
    //else if ([[segue identifier]isEqualToString:@"loginSegue"]){
////        LoginViewController *vc = [segue destinationViewController];
////        vc.managedObjectContext = self.managedObjectContext;
//    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
