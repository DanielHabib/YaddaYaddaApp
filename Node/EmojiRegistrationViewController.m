//
//  EmojiRegistrationViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "EmojiRegistrationViewController.h"
#import <dispatch/dispatch.h>

@interface EmojiRegistrationViewController ()

@end

@implementation EmojiRegistrationViewController{
    NSString *emojiType;
    NSString *username;
    NSString *phone;
    dispatch_queue_t queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"username"];
    phone = [defaults objectForKey:@"phoneNumber"];
//    __block NSData *happyImageData;
//    __block NSData *angelImageData;
//    __block NSData *sleepyImageData;
//    
//    NSLog(@"username is :%@",username);
//    
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_sync(queue, ^{
//        
//        
//    });
//        happyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",phone]]];
//        angelImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",phone]]];
//        sleepyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",phone]]];
//    
//    
//    self.happy.layer.cornerRadius = self.happy.frame.size.width/2;
//    self.happy.layer.masksToBounds = YES;
//    
//    self.angelic.layer.cornerRadius = self.angelic.frame.size.width/2;
//    self.angelic.layer.masksToBounds = YES;
//    
//    self.sleepy.layer.cornerRadius = self.sleepy.frame.size.width/2;
//    self.sleepy.layer.masksToBounds = YES;
//    
    
    
    self.happy.layer.cornerRadius = self.happy.frame.size.width/2;
    self.happy.layer.masksToBounds = YES;
    
    self.angelic.layer.cornerRadius = self.angelic.frame.size.width/2;
    self.angelic.layer.masksToBounds = YES;
    
    self.sleepy.layer.cornerRadius = self.sleepy.frame.size.width/2;
    self.sleepy.layer.masksToBounds = YES;
    
        self.happy.image = [UIImage imageNamed:@"blueBackground.png"];
        self.sleepy.image = [UIImage imageNamed:@"blueBackground.png"];
        self.angelic.image = [UIImage imageNamed:@"blueBackground.png"];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __block NSData *happyImageData;
    __block NSData *angelImageData;
    __block NSData *sleepyImageData;
    
    NSLog(@"username is :%@",username);
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^{
        
        
            happyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",phone]]];
    angelImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",phone]]];
    sleepyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",phone]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.happy.image = [UIImage imageWithData:happyImageData];
            self.angelic.image = [UIImage imageWithData:angelImageData];
            self.sleepy.image = [UIImage imageWithData:sleepyImageData];
            
            
        });
        
        
    });

    

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)happyButton:(id)sender {
    emojiType = @"happy";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"happy" forKey:@"emojiTyped"];
    [defaults synchronize];
}

- (IBAction)angelButton:(id)sender {
    emojiType = @"angel";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"angel" forKey:@"emojiTyped"];
    [defaults synchronize];
}
- (IBAction)sleepyButton:(id)sender {
    emojiType = @"sleepy";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"sleepy" forKey:@"emojiTyped"];
    [defaults synchronize];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   /* if ([[segue identifier] isEqualToString:@"emojiRegistration"])
    {
        
        EmojiPictureChangeViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.emojiType = [NSString stringWithFormat:@"%@",emojiType];
    }
    else if([[segue identifier] isEqualToString:@"emojiRegistrationTwo"])
    {
        
        EmojiPictureChangeViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.emojiType = [NSString stringWithFormat:@"%@",emojiType];
    }
    else if([[segue identifier] isEqualToString:@"emojiRegistrationThree"])
    {
        
        EmojiPictureChangeViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.emojiType = [NSString stringWithFormat:@"%@",emojiType];
    }*/




    EmojiPictureChangeViewController *vc = [segue destinationViewController];
    //Fix this to go to the table view
    NSLog(@"emoji type before transition:%@",emojiType);
    vc.emojiType = [NSString stringWithFormat:@"%@",emojiType];















}


@end
