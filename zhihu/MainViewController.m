//
//  MainViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "MainViewController.h"
#import "QuestionDetailViewController.h"
#import "TopViewController.h"
#import "AddQuestionViewController.h"
#import "AppDelegate.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property(nonatomic,readwrite,strong) NSDictionary * questions;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 130, 100, 50)];
    label1.text = @"问题广场";
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(250, 130, 100, 50)];
    label2.text = @"热榜";
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    
    //添加问题按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(self.view.bounds.size.width-100, 80, 100, 50);
    //btn.backgroundColor = [UIColor cyanColor];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 10;
    //btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(register1) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    
    //
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    //为顶部两个label监听scrollView的contentSize属性
//     [scrollView addObserver:label1 forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];没写完
    
     //问题列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,scrollView.bounds.size.width , scrollView.bounds.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    NSArray *colorArray = @[[UIColor blueColor],[UIColor yellowColor]];
    
   
    
    
    [ scrollView addSubview:({
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width*1, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        
        view1.backgroundColor = [colorArray objectAtIndex:1];
        view1;
    })];
    
       [ scrollView addSubview:tableView];
    [self.view addSubview:scrollView];
//    //请求后端问题数据
//    //1.url
//    NSURL *url = [NSURL URLWithString:@"http://47.102.194.254:8000/api/v1/questions"];
//    //2.创建请求对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    //3.发送异步请求
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //4.解析数据
//        NSDictionary *dictm = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];
//        //
//        NSLog(@"%@",dictm);
//         NSDictionary *datas = dictm[@"data"];
//        self.questions =datas[@"questions"];
//
//        //5.更新UI
//        [tableView reloadData];
//
//    }];
    
    
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置UItableview的高度
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击uitableview跳转到一个view
    QuestionDetailViewController *controller = [[QuestionDetailViewController alloc] init];
    
    controller.title = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    }
    
    cell.textLabel.text=@"主标题";
    cell.detailTextLabel.text = @"副标题";
    cell.imageView.image = [UIImage imageNamed:@"图片/popup_weibo.png"];
    return cell;
}
//发布问题
-(void)register1{
    AddQuestionViewController *addQuestionController = [[AddQuestionViewController alloc]init];
    [self presentViewController:addQuestionController animated:YES completion:nil];
}
@end
