//
//  AppDelegate.m
//  Node
//
//  Created by Daniel Habib on 8/26/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()


@end




@implementation AppDelegate










- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   	// Let the device know we want to receive push notifications
    /*[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Override point for customization after application launch.
    */
    //NS if i need both
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
     [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge  categories:nil]];
    
  
    
    
    
    return YES;
    
    
    
    
    

     }
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //NSLog(@"My token is: %@", deviceToken);
    
    //NSString *DeviceToken = [[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
//Sending NSData
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *DeviceToken = deviceToken.description;
    DeviceToken = [DeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    DeviceToken = [DeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    DeviceToken = [DeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
   // NSLog(@"TESTING TESTING::::::::%@",DeviceToken);
    [defaults setObject:DeviceToken forKey:@"DeviceToken"];
    //NSLog(@"%@",DeviceToken);
    [defaults synchronize];
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:    (NSDictionary *)userInfo {
    
    
      //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"userInfo:%@",userInfo);
    int badge_value;
    badge_value+=[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]intValue];
    NSLog(@"Totoal badge Value:%d",badge_value);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge_value;}

@end
