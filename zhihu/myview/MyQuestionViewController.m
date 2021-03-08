//
//  MyQuestionViewController.m
//  zhihu
//
//  Created by bytedance on 2021/1/30.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "MyQuestionDetailViewController.h"
@interface MyQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong,readwrite) UITableView *tableview;
@property(nonatomic,strong,readwrite) NSArray *questions;

@end

@implementation MyQuestionViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    //重新加载tableviewcell的数据
    
    //请求最新数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/user/questions"];
   // NSLog(urlString);
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
        
        self.questions =(NSArray *)[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"questions"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.questions isKindOfClass:[NSNull class]]||self.questions.count==0) {
                [self.tableview removeFromSuperview];
                UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
                label.textColor = [UIColor grayColor];
                label.text = @"还没有内容";
                label.textAlignment =NSTextAlignmentCenter;
                [self.view addSubview:label];
            }else{
            [self.tableview reloadData];
            }
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
        
    }];
    [dataTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
   
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的问题";
    //[self setupRefresh];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置UItableview的高度
    return 120;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.questions.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
      
    }
    NSDictionary *dict = _questions[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    //cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//进入问题详情页
    MyQuestionDetailViewController *myQueDetail = [[MyQuestionDetailViewController alloc]init];
    NSDictionary *dict = _questions[indexPath.row];
 
    myQueDetail.questionID =dict[@"id"];
    [self.navigationController pushViewController:myQueDetail animated:YES];
    
}


//左滑删除

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    
    //[self.questions removeObjectAtIndex:indexPath.row];
    //获取问题id
    NSDictionary *dict = _questions[indexPath.row];
    NSString *questionID =dict[@"id"];
    [self deleteQuestion:questionID];
    
    // 刷新
    [self.tableview reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)deleteQuestion:(NSString *)questionID{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除问题" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token =  [userDefault objectForKey:@"token"];
        //NSLog(token);
        //删除问题
        // /api/v1/questions/{qid}
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@",questionID];
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
