//
//  SettingsPage.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "SettingsPage.h"
#import "CoreDataAPI.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SettingsPage ()

@end

@implementation SettingsPage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    
    self.privacy.layer.cornerRadius = 20;
    self.privacy.layer.masksToBounds = YES;
    
    self.notifications.layer.cornerRadius = 20;
    self.notifications.layer.masksToBounds = YES;
    
    self.suppourt.layer.cornerRadius = 20;
    self.suppourt.layer.masksToBounds = YES;
    
    self.logOut.layer.cornerRadius = 20;
    self.logOut.layer.masksToBounds = YES;
    
    
    self.logo.layer.cornerRadius=self.logo.frame.size.height/2;
    self.logo.layer.masksToBounds=YES;
    
    // Do any additional setup after loading the view.
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

- (IBAction)logOut:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [CoreDataAPI deleteAllObjectsInCoreData];
    [FBSession setActiveSession:nil];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
