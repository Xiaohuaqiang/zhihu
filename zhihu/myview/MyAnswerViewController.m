//
//  MyAnswerViewController.m
//  zhihu
//
//  Created by bytedance on 2021/1/30.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "MyAnswerCell.h"
#import "MyAnswerDetailViewController.h"
@interface MyAnswerViewController ()<UITableViewDelegate,UITableViewDataSource,MyAnswerCellDelegate>
@property(nonatomic,strong,readwrite)UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray *answers;

@end

@implementation MyAnswerViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self getInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.view.backgroundColor = [UIColor whiteColor];
      _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.sectionHeaderHeight=2;
    self.tableView.sectionFooterHeight=2;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self getInfo];
     self.navigationItem.title = @"我的回答";
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置UItableview的高度
    return 120;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   MyAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        
        cell = [[MyAnswerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
//    NSDictionary *dict = _questions[indexPath.row];
//    cell.textLabel.text = dict[@"title"];
    
    
    
    [cell layoutTableViewCellWithItem:[self.answers objectAtIndex:indexPath.section]];
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入问题详情页
   MyAnswerDetailViewController *myAnsDetail = [[MyAnswerDetailViewController alloc]init];
    NSDictionary *dict = _answers[indexPath.row];
    myAnsDetail.answerID =dict[@"id"];
    myAnsDetail.questionID =dict[@"qid"];
    myAnsDetail.questionTitle = dict[@"title"];
    [self.navigationController pushViewController:myAnsDetail animated:YES];
    
}
//每个分组下边预留的空白高度 无效
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 20;
}
//左滑删除

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    
    //[self.questions removeObjectAtIndex:indexPath.row];
    //获取问题id
    NSDictionary *dict = _answers[indexPath.row];
    NSString *questionID =dict[@"qid"];
    NSString *answerID = dict[@"id"];
    [self deleteAnswer:questionID withaID:answerID];
    // 刷新
    [self.tableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//获取我的回答
-(void)getInfo{
    //请求最新数据
   // /api/v1/user/answers
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/user/answers"];
    //NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    //4.修改请求方法为PUT
    request.HTTPMethod = @"GET";
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        self.answers =(NSMutableArray  *)[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.answers isKindOfClass:[NSNull class]]||self.answers.count==0) {
                [self.tableView removeFromSuperview];
                UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
                label.textColor = [UIColor grayColor];
                label.text = @"还没有回答";
                label.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:label];
            }else{
                [self.tableView reloadData];
            }
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
        
    }];
    [dataTask resume];
}
//删除回答按钮的点击事件
-(void)deleteAnswer:(NSString *)questionID withaID:(NSString *) answerID{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除回答" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token =  [userDefault objectForKey:@"token"];
        NSLog(token);
        //删除回答
        // /api/v1/questions/{qid}/answers/{aid}
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",questionID,answerID];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:listURL];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:token forHTTPHeaderField:@"token"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
            
            NSString *msg =((NSDictionary *)jsonObj)[@"msg"];
            NSLog(msg);
            
        }];
        [dataTask resume];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    //弹出确认删除提醒框
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
