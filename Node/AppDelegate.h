//
//  AppDelegate.h
//  Node
//
//  Created by Daniel Habib on 8/26/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "XMPP.h"



//#import "Globals.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    //XMPP ADDITIONS START-------
    XMPPStream *xmppStream;
    NSString *password;
    BOOL isOpen;
    //XMPP ADDITIONS END-----------
    
    
}
//@property (strong,nonatomic) NSString *userName;
@property (strong, nonatomic) UIWindow *window;
//@property UINavigationController *navController;



//XMPPP ADDITIONS START------------------------------
@property (nonatomic, readonly) XMPPStream *xmppStream;

- (BOOL)connect;
- (void)disconnect;
//XMPP ADDITIONS END------------------------------







@end
