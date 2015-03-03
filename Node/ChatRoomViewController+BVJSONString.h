//
//  ChatRoomViewController+BVJSONString.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/6/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ChatRoomViewController.h"

@interface ChatRoomViewController (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end
