//
//  ChatRoomViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDMulticastDelegate.h"
#import <dispatch/dispatch.h>
@interface ChatRoomViewController ()
{
    NSMutableArray *NodeClassList;
    GCDAsyncSocket *socket;
}
@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NodeClassList = [[NSMutableArray alloc]init];
    [NodeClassList addObject:@"yup"];
    [NodeClassList addObject:@"yup"];
    [NodeClassList addObject:@"yup"];
    
    
    NSError *err = nil;
    if (![socket connectToHost:@"104.131.53.146" onPort:8080 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return [NodeClassList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [NodeClassList objectAtIndex:indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)testbutton:(id)sender {
    [NodeClassList addObject:@"HOOOORAY"];
    [self.tableView reloadData];
    }
@end
