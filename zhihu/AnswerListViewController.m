//
//  AnswerListViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/31.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "AnswerListViewController.h"
#import "AnswerListCell.h"
#import "ClearAnswerViewController.h"
@interface AnswerListViewController ()<UITableViewDataSource,UITableViewDelegate,AnswerListCellDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UIButton *defaultbutton;
@property(nonatomic,strong,readwrite) UIButton *newbutton;
@property(nonatomic,readwrite) NSInteger tag;//tag为0的时候表示默认，为1的时候表示最新；
@property(nonatomic,strong,readwrite) NSArray  *newanswerArray;//保存最新排序的数据
@end

@implementation AnswerListViewController

-(void)viewWillAppear:(BOOL)animated{

    //重新加载tableviewcell的数据
    if (_tag==0) {
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0",self.questionID];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
            self.answerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 0;
                [self.tableView reloadData];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                
            });
            
            
        }];
        [dataTask resume];
    }
    
    
    
    //重新加载tableviewcell的数据
    if (_tag==1) {
        //请求最新数据

        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1",self.questionID];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];

        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
            self.newanswerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 1;
                [self.tableView reloadData];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];

            });


        }];
        [dataTask resume];
    }
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //默认tag为0；
    self.tag = 0;
    //设置问题标题
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(self.view.bounds.size.width/4, 90, self.view.bounds.size.width/2, 40);
    titleLabel.text = self.questiontitle;
    [titleLabel setTextColor:[UIColor blackColor]];
    //titleLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    //设置右侧的默认和最新按钮排序回答
    //默认
    _defaultbutton = [[UIButton alloc]init];
    [_defaultbutton setFrame:CGRectMake(self.view.bounds.size.width-120, 140, 40, 40)];
   // [defaultbutton setBackgroundColor:[UIColor redColor]];
    [_defaultbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_defaultbutton setTitle:@"默认" forState:UIControlStateNormal];
    [_defaultbutton addTarget:self action:@selector(defaultClick) forControlEvents:UIControlEventTouchUpInside];
     
    //最新
    _newbutton = [[UIButton alloc]init];
    [_newbutton setFrame:CGRectMake(self.view.bounds.size.width-60, 140, 40, 40)];
   // [newbutton setBackgroundColor:[UIColor redColor]];
    [_newbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_newbutton setTitle:@"最新" forState:UIControlStateNormal];
    [_newbutton addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_defaultbutton];
    [self.view addSubview:_newbutton];
    //设置tableview
   _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height-150) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight =3;
    _tableView.sectionFooterHeight = 5;
    
    _tableView.dataSource = self;
     _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}
//默认按钮点击
-(void)defaultClick{
    [self.defaultbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.newbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tag=0;
    //请求最新数据
    
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        self.answerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tag = 0;
            [self.tableView reloadData];
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
        
    }];
    [dataTask resume];
   
}
//最新按钮点击
-(void)newClick{
    [self.defaultbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.newbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //请求最新数据
   
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
       self.newanswerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tag = 1;
            [self.tableView reloadData];
           // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
       
    }];
    [dataTask resume];
    
    
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
    return _answerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[AnswerListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
    if (self.tag==0) {
        [cell layoutTableViewCellWithItem:[self.answerArray objectAtIndex:indexPath.row]];
        NSLog(@"😊我是默认回答排序");
    }else if (self.tag==1){
        [cell layoutTableViewCellWithItem:[self.newanswerArray objectAtIndex:indexPath.row]];
        NSLog(@"😭我是最新回答排序");
    }
    //[cell layoutTableViewCellWithItem:[self.answerArray objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击uitableview跳转到一个view
    NSLog(@"😯我被点击了");
     ClearAnswerViewController *clearvc = [[ClearAnswerViewController alloc]init];
    NSDictionary* answerdict ;
    if (_tag==0) {
         answerdict =  [self.answerArray objectAtIndex:indexPath.row];
    }else if (_tag==1){
       answerdict =  [self.newanswerArray objectAtIndex:indexPath.row];
    }
   
    clearvc.answerContent = answerdict[@"content"];
    clearvc.questionTitle = self.questiontitle;
   
    
        clearvc.nickname =answerdict[@"nickname"];
        clearvc.questionID = answerdict[@"qid"];
        clearvc.answerID = answerdict[@"id"];
    
        
    
    
    
    [self.navigationController pushViewController:clearvc animated:YES];
    
}
//每个分组下边预留的空白高度 无效
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 20;
}


@end
