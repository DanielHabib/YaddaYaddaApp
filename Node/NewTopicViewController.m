//
//  NewTopicViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/19/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "NewTopicViewController.h"

@interface NewTopicViewController ()

@end

@implementation NewTopicViewController{
   // UITextField *textField;
}

//newTopicToTableView


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //textField = _textField;
     _textField.userInteractionEnabled = YES;
    _textField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark text stuff
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self processReturn];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //uILabel.text = newString;
    if([self isCorrectTypeOfString:string]){
        return YES;
    }
    return YES;
}

-(void)processReturn{
    
    NSLog(@"process return called");
    
   //[self postTest];
    
    [_textField resignFirstResponder];//hides the keyboard
    //[self shouldPerformSegueWithIdentifier:@"textFieldToInvitationPage" sender:self];

}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"textFieldToInvitationPage"])
    {
        InvitationPage *vc = [segue destinationViewController];
        //Fix this to go to the table view
       // NSLog(@"TEXT ::::: : :%@",_textField.text);
        vc.topic = [NSString stringWithFormat:@"%@",[_textField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    }}

-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    return NO;
}
-(void)postTest{
    NSLog(@"TextField = %@",_textField.text);
    NSString *post = [NSString stringWithFormat:@"&topic=%@",[_textField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
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



- (IBAction)nextButtonAction:(id)sender {
    [_textField resignFirstResponder];
}
@end
