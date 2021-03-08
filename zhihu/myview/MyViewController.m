//
//  MyViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "MyViewController.h"
#import "ViewController.h"
#import "MyQuestionViewController.h"
#import "MyAnswerViewController.h"
#import "PassWordMannagerViewController.h"
#import "MyLikeViewController.h"
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *resignButton;
    UITableView *personalTableView;
    NSArray *dataSource;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    personalTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, SCREEN_SIZE.width, SCREEN_SIZE.height-20-44-49) style:UITableViewStyleGrouped];
    [self.view addSubview:personalTableView];
    personalTableView.delegate=self;
    personalTableView.dataSource=self;
    personalTableView.bounces=NO;
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    dataSource=@[@"我的问题",@"我的回答",@"我的赞",@"密码管理"];
//    //设置退出登录按钮
//    resignButton = [[UIButton alloc]init];
//    resignButton.frame = CGRectMake(50,250, 100, 40);
//    [resignButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    resignButton.layer.masksToBounds = YES;
//    resignButton.layer.cornerRadius = 10;
//    resignButton.backgroundColor = [UIColor cyanColor];
//    [resignButton addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:resignButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 3;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return dataSource.count;
    }else{
        return 1;
    }
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 80;
    }
    return 40;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    return 60;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (indexPath.section==0) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
       
        NSString *username = [userdefault objectForKey:@"username"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 20, 40, 40)];
        
         NSString *avatar = [userdefault objectForKey:@"avatar"];
        NSLog(@"%@",avatar);
        dispatch_queue_global_t doloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_main_t mainQueue = dispatch_get_main_queue();
        dispatch_async(doloadQueue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]]];
            
            dispatch_async(mainQueue, ^{
                imageView.image = image;
               [cell.contentView addSubview:imageView];
            });
        });
        
       
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 60, 80)];
        nameLabel.text=username;
        [cell.contentView addSubview:nameLabel];
    }else if (indexPath.section==1) {
        cell.textLabel.text=[dataSource objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text=@"退出登录";
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    return cell;
}
//处理cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    if (indexPath.section==0) {
       
        
       
    }else if (indexPath.section==1) {
        //分别设置第二个section的点击
       // cell.textLabel.text=[dataSource objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            //我的问题
            MyQuestionViewController *myQuevc =[[MyQuestionViewController alloc]init];
            [self.navigationController pushViewController:myQuevc animated:YES];
            
        }else if(indexPath.row==1){
            //我的回答
            MyAnswerViewController *myAnsvc = [[MyAnswerViewController alloc]init];
           [self.navigationController pushViewController:myAnsvc animated:YES];
        }else if(indexPath.row==2){
            //我的赞
            MyLikeViewController *mylikevc = [[MyLikeViewController alloc]init];
            [self.navigationController pushViewController:mylikevc animated:YES];
          
        }else{
            //密码管理
            PassWordMannagerViewController *pwdMvc = [[PassWordMannagerViewController alloc]init];
            [self.navigationController pushViewController:pwdMvc animated:YES];
        }
    }else{
        //退出登陆
        [self resign];
    }
}

-(void)resign{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    [userDefalut removeObjectForKey:@"username"];
    [userDefalut removeObjectForKey:@"password"];
    [userDefalut removeObjectForKey:@"avatar"];
   // NSString *token = [userDefalut objectForKey:@"token"];
    [userDefalut removeObjectForKey:@"token"];
    [userDefalut synchronize];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}


@end
