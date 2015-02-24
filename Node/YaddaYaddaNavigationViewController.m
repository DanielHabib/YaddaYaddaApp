//
//  YaddaYaddaNavigationViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 9/30/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "YaddaYaddaNavigationViewController.h"

@interface YaddaYaddaNavigationViewController ()

@end

@implementation YaddaYaddaNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    //self.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.6];
    //self.navigationBar.alpha=.3;
    //self.navigationItem.title =
    
    
    
   // [UIFont fontNamesForFamilyName:@"Nexa Bold"];
    self.navigationBar.layer.cornerRadius = 0.0;
    self.navigationBar.layer.borderColor = (__bridge CGColorRef)([UIColor grayColor]);
    self.navigationBar.layer.masksToBounds=YES;
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

@end
