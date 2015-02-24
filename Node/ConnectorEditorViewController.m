//
//  ConnectorEditorViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/12/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ConnectorEditorViewController.h"

@interface ConnectorEditorViewController ()

@end

@implementation ConnectorEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)black:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"000000" forKey:@"pathColor"];
    
}

- (IBAction)red:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"FF8E1D" forKey:@"pathColor"];
}

- (IBAction)blue:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2479A3" forKey:@"pathColor"];
}

- (IBAction)straight:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"straight" forKey:@"pathStyle"];
}

- (IBAction)dashed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"dashed" forKey:@"pathStyle"];
}

- (IBAction)curved:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"curved" forKey:@"pathStyle"];
}
@end
