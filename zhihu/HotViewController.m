//
//  HotViewController.m
//  zhihu
//
//  Created by bytedance on 2021/2/7.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "HotViewController.h"
#import "HotCell.h"
#import "AnswerListViewController.h"
@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource,HotCellDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableview;
@property(nonatomic,strong,readwrite) NSMutableArray *hotquestions;
@end

@implementation HotViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.view.backgroundColor = [UIColor redColor];
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.contentInset = UIEdgeInsetsMake(0, 0, 256, 0);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.sectionHeaderHeight =0;
    _tableview.sectionFooterHeight = 5;
    [self.view addSubview:_tableview];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getinfo];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置UItableview的高度
    return 120;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //点击uitableview跳转到一个view
//    GTListIterm *item= [self.dataArray objectAtIndex:indexPath.row];
//    GTDetailViewController *controller = [[GTDetailViewController alloc]initWithUrlString:item.articleUrl];
//    controller.title = [NSString stringWithFormat:@"%@",@(indexPath.row)];
//    [self.navigationController pushViewController:controller animated:YES];
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotquestions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell"];
    if(!cell){
        cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"hotcell"];
        cell.delegate = self;
        
    }
   
  
    
    
    
    [cell layoutTableViewCellWithItem:[self.hotquestions objectAtIndex:indexPath.section]withorder:indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //[self.navigationController pushViewController:myQueDetail animated:YES];
    AnswerListViewController *anlistvc = [[AnswerListViewController alloc]init];
    //将问题标题传给回答列表页面
    NSDictionary *dict =[self.hotquestions objectAtIndex:indexPath.section];
    anlistvc.questiontitle =dict[@"title"];
  
    anlistvc.questionID = dict[@"id"];

    [self.navigationController pushViewController:anlistvc animated:YES];
    
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
}
//获取我的回答
-(void)getinfo{
    //请求最新数据
//   /api/v1/hot_questions
    
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/hot_questions"];
    //NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    //4.修改请求方法为PUT
    request.HTTPMethod = @"GET";
    //设置请求头token
   // [request setValue:token forHTTPHeaderField:@"token"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        self.hotquestions =(NSMutableArray  *)[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"questions"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
                [self.tableview reloadData];
            
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
        
    }];
    [dataTask resume];
}

@end
