//
//  TopViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3, 50, 50, 50)];
    label1.text = @"问题广场";
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3*2, 50, 50, 50)];
    label2.text = @"热榜";
}


@end
