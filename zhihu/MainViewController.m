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
#import "HotViewController.h"
#import "RecommendViewController.h"
@interface MainViewController ()<UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSArray *dataArray;
@property(nonatomic,strong,readwrite) ListLoader *listLoader;
//@property(nonatomic,readwrite,strong) NSDictionary * questions;
@property(nonatomic,strong,readwrite) UIButton *button1;
@property(nonatomic,strong,readwrite) UIButton *button2;
@property(nonatomic,strong,readwrite) UIScrollView *scrollView;
@property(nonatomic,strong,readwrite) UITableView *hotTableView;
@end

@implementation MainViewController

#pragma mark -
-(instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
//-(void)viewDidAppear:(BOOL)animated{
//    
//    //从上一个页面返回的时候刷新数据
//    self.listLoader = [[ListLoader alloc]init];
//    
//    __weak typeof (self) wself = self;
//    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<QuestionListIterm *> * _Nonnull dataArray) {
//        __strong typeof (self)strongSelf = wself;
//        strongSelf.dataArray = dataArray;
//        [strongSelf.tableView reloadData];
//    }];
//    
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.leftBarButtonItem.title = @"返回";
    //self.title= @"jhhh";
    
    
    
    
    //设置右上角发布问题按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发布问题" style:UIBarButtonItemStylePlain target:self action:@selector(addQuestion)];
    
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
    
    
    
   
  
   
//    //添加问题按钮
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    btn.frame = CGRectMake(self.view.bounds.size.width-100, 80, 100, 50);
//    //btn.backgroundColor = [UIColor cyanColor];
////    btn.layer.masksToBounds = YES;
////    btn.layer.cornerRadius = 10;
////    //btn.backgroundColor = [UIColor grayColor];
//    [btn addTarget:self action:@selector(addQuestion) forControlEvents:UIControlEventTouchUpInside];
//    //
//   [self.view addSubview:btn];
   self.view.backgroundColor = [UIColor whiteColor];
//
    
    
    //
   self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*2,0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
 
    
    RecommendViewController *recommendvc = [[RecommendViewController alloc]init];
    [recommendvc.view setFrame:CGRectMake(self.scrollView.bounds.size.width*0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.scrollView addSubview:recommendvc.view];
    [self addChildViewController:recommendvc];
    //首页的tableview
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    _tableView.sectionHeaderHeight =3;
//    _tableView.sectionFooterHeight = 5;
//    [self.view addSubview:_tableView];

    
    
   
  
    
    HotViewController *hotvc = [[HotViewController alloc]init];
    [hotvc.view setFrame:CGRectMake(self.scrollView.bounds.size.width*1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
      [self.scrollView addSubview:hotvc.view];
    [self addChildViewController:hotvc];
    
//    [ self.scrollView addSubview:({
//        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width*1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
//
//        view1.backgroundColor = [colorArray objectAtIndex:1];
//
//        view1;
//    })];
  
    
       [ self.scrollView addSubview:_tableView];
    [self.view addSubview:self.scrollView];

    
  
    
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _dataArray.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    GTNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
//    if(!cell){
//        cell = [[GTNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
//        cell.delegate = self;
//    }
//    
//    ;
//    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.section]];
//    return cell;
//}
//-(void)tableViewCell:(UITableViewCell *)tableViewCell clickDeleteButton:(UIButton *)deleteButton{
//    //    GTDeleteCellView *deleteView = [[GTDeleteCellView alloc]initWithFrame:self.view.bounds];
//    //    CGRect rect = [tableViewCell convertRect:deleteButton.frame toView:nil];
//    //
//    //    __weak typeof (self) wself = self;
//    //
//    //    [deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
//    //       __strong typeof (self)strongSelf = wself;
//    //        [strongSelf.dataArray removeLastObject];
//    //        [strongSelf.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    //    }];
//}
//
//
//
//
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    //设置UItableview的高度
////    return 100;
////}
////
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //点击uitableview跳转到一个view
//    QuestionDetailViewController *controller = [[QuestionDetailViewController alloc] init];
//    QuestionListIterm *ss  = [self.dataArray objectAtIndex:indexPath.section];
//    //去除l标题两端空格和换行
//    NSString *strtitle =  [ss.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    controller.questionTitle = strtitle;
//    controller.questionID = ss.questionID;
//    controller.answerID = ss.answerID;
//    controller.answerContent = ss.content;
//    controller.nickname = ss.nickName;
//    [self.navigationController pushViewController:controller animated:nil];
//
//}
////每个分组下边预留的空白高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    return 10;
//}
////
////- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
////    return 20;
////}
////
////- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
////    if(!cell){
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
////    }
////
////    cell.textLabel.text=@"主标题";
////    cell.detailTextLabel.text = @"副标题";
////    cell.imageView.image = [UIImage imageNamed:@"图片/popup_weibo.png"];
////    return cell;
////}
//发布问题
-(void)addQuestion{
    AddQuestionViewController *addQuestionController = [[AddQuestionViewController alloc]init];
    //[self presentViewController:addQuestionController animated:YES completion:nil];
   
    [self.navigationController pushViewController:addQuestionController animated:YES];
}
@end
