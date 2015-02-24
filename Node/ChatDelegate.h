//
//  ChatDelegate.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatDelegate 
- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;
@end
