//
//  StartUpVC.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 11/3/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <dispatch/dispatch.h>
@interface StartUpVC : UIViewController<FBLoginViewDelegate,NSXMLParserDelegate>




@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
