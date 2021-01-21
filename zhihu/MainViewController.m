//
//  MainViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//
#import "GTNormalTableViewCell.h"
#import "MainViewController.h"
#import "QuestionDetailViewController.h"
#import "TopViewController.h"
#import "AddQuestionViewController.h"
#import "AppDelegate.h"
#import "ListLoader.h"
#import "QuestionListIterm.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,GTNormalTableViewCellDelegate,UIScrollViewDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSArray *dataArray;
@property(nonatomic,strong,readwrite) ListLoader *listLoader;
//@property(nonatomic,readwrite,strong) NSDictionary * questions;
@property(nonatomic,strong,readwrite) UIButton *button1;
@property(nonatomic,strong,readwrite) UIButton *button2;
@property(nonatomic,strong,readwrite) UIScrollView *scrollView;
@end

@implementation MainViewController

#pragma mark -
-(instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    //从上一个页面返回的时候刷新数据
    self.listLoader = [[ListLoader alloc]init];
    
    __weak typeof (self) wself = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<QuestionListIterm *> * _Nonnull dataArray) {
        __strong typeof (self)strongSelf = wself;
        strongSelf.dataArray = dataArray;
        [strongSelf.tableView reloadData];
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.leftBarButtonItem.title = @"返回";
    //self.title= @"jhhh";
    self.button1 = [[UIButton alloc]initWithFrame:CGRectMake(90, 130, 100, 50)];
    
    [self.button1 setTitle:@"推荐" forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(buttonClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.button2 = [[UIButton alloc]initWithFrame:CGRectMake(250, 130, 100, 50)];
    [self.button2 setTitle:@"热榜" forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(buttonClick2) forControlEvents:UIControlEventTouchUpInside];
   [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    
    
    //添加问题按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(self.view.bounds.size.width-100, 80, 100, 50);
    //btn.backgroundColor = [UIColor cyanColor];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 10;
    //btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(addQuestion) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    
    //
   self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    //为顶部两个label监听scrollView的contentSize属性
//     [scrollView addObserver:label1 forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];没写完
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //[self.view addSubview:_tableView];
//     //问题列表
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,scrollView.bounds.size.width , scrollView.bounds.size.height)];
//    tableView.dataSource = self;
//    tableView.delegate = self;
    
    NSArray *colorArray = @[[UIColor blueColor],[UIColor yellowColor]];
    
   
    
    
    [ self.scrollView addSubview:({
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width*1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        
        view1.backgroundColor = [colorArray objectAtIndex:1];
        view1;
    })];
    
       [ self.scrollView addSubview:_tableView];
    [self.view addSubview:self.scrollView];
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
    self.listLoader = [[ListLoader alloc]init];
    
    __weak typeof (self) wself = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<QuestionListIterm *> * _Nonnull dataArray) {
        __strong typeof (self)strongSelf = wself;
        strongSelf.dataArray = dataArray;
        [strongSelf.tableView reloadData];
    }];
  
    
}

-(void)buttonClick1{
    [self.button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.scrollView.contentOffset = CGPointMake(0, 0);
}
-(void)buttonClick2{
    [self.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
}
#pragma mark -UIscrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前角标
    NSInteger i =scrollView.contentOffset.x/self.view.bounds.size.width;
    if(i==1){
        [self.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if(i==0){
        [self.button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    //1选中标题
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置UItableview的高度
    return 150;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //点击uitableview跳转到一个view
//    GTListIterm *item= [self.dataArray objectAtIndex:indexPath.row];
//    GTDetailViewController *controller = [[GTDetailViewController alloc]initWithUrlString:item.articleUrl];
//    controller.title = [NSString stringWithFormat:@"%@",@(indexPath.row)];
//    [self.navigationController pushViewController:controller animated:YES];
//
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GTNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[GTNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
    ;
    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableViewCell:(UITableViewCell *)tableViewCell clickDeleteButton:(UIButton *)deleteButton{
    //    GTDeleteCellView *deleteView = [[GTDeleteCellView alloc]initWithFrame:self.view.bounds];
    //    CGRect rect = [tableViewCell convertRect:deleteButton.frame toView:nil];
    //
    //    __weak typeof (self) wself = self;
    //
    //    [deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
    //       __strong typeof (self)strongSelf = wself;
    //        [strongSelf.dataArray removeLastObject];
    //        [strongSelf.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    //    }];
}




//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //设置UItableview的高度
//    return 100;
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击uitableview跳转到一个view
    QuestionDetailViewController *controller = [[QuestionDetailViewController alloc] init];
    QuestionListIterm *ss  = [self.dataArray objectAtIndex:indexPath.row];
    //去除l标题两端空格和换行
    NSString *strtitle =  [ss.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    controller.questionTitle = strtitle;
    controller.questionID = ss.questionID;
    controller.answerID = ss.answerID;
    controller.answerContent = ss.content;
    controller.nickname = ss.nickName;
    [self.navigationController pushViewController:controller animated:nil];

}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 20;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
//    if(!cell){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
//    }
//
//    cell.textLabel.text=@"主标题";
//    cell.detailTextLabel.text = @"副标题";
//    cell.imageView.image = [UIImage imageNamed:@"图片/popup_weibo.png"];
//    return cell;
//}
//发布问题
-(void)addQuestion{
    AddQuestionViewController *addQuestionController = [[AddQuestionViewController alloc]init];
    //[self presentViewController:addQuestionController animated:YES completion:nil];
   
    [self.navigationController pushViewController:addQuestionController animated:YES];
}
@end
