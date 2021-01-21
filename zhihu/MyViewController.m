//
//  MyViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "MyViewController.h"
#import "ViewController.h"
@interface MyViewController ()
{
    UIButton *resignButton;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置退出登录按钮
    resignButton = [[UIButton alloc]init];
    resignButton.frame = CGRectMake(50,250, 100, 40);
    [resignButton setTitle:@"退出登录" forState:UIControlStateNormal];
    resignButton.layer.masksToBounds = YES;
    resignButton.layer.cornerRadius = 10;
    resignButton.backgroundColor = [UIColor cyanColor];
    [resignButton addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)resign{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    [userDefalut removeObjectForKey:@"username"];
    [userDefalut removeObjectForKey:@"password"];
    NSString *token = [userDefalut objectForKey:@"token"];
    [userDefalut removeObjectForKey:@"token"];
    [userDefalut synchronize];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}


@end
