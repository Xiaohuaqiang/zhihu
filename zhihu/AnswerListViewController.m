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
#import "WriteAnswerViewController.h"
@interface AnswerListViewController ()<UITableViewDataSource,UITableViewDelegate,AnswerListCellDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UIButton *defaultbutton;
@property(nonatomic,strong,readwrite) UIButton *newbutton;
@property(nonatomic,readwrite) NSInteger tag;//tag为0的时候表示默认，为1的时候表示最新；
@property(nonatomic,strong,retain) NSMutableArray *answerArray;
@property(nonatomic,strong,retain) NSMutableArray  *newanswerArray;//保存最新排序的数据
@property(nonatomic,readwrite) NSInteger offset;//加载更多的偏移量

//下拉刷新控件时候是否正在刷新
@property(nonatomic,assign,getter=isHeaderRefreshing) BOOL headerRefreshing;
//下拉刷新控件
@property(nonatomic,weak) UIView *header;
@property(nonatomic,weak) UILabel *headerLabel;//上拉刷新控件里面的文字
//下拉刷新控件
@property(nonatomic,weak) UIView *footer;
@property(nonatomic,weak) UILabel *footerLabel;//上拉刷新控件里面的文字
//上拉刷新控件时候是否正在刷新
@property(nonatomic,assign,getter=isFooterRefreshing) BOOL footerRefreshing;
@end

@implementation AnswerListViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
 self.tabBarController.tabBar.hidden = YES;
    return;
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
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置右上角回答问题按钮
    //设置右上角发布问题按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"写回答" style:UIBarButtonItemStylePlain target:self action:@selector(addAnswer)];
    
    
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
   _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height-244) style:UITableViewStyleGrouped];
   // _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //设置内边距
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.sectionHeaderHeight =0;
    _tableView.sectionFooterHeight = 5;
    
    _tableView.dataSource = self;
     _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    if (self.tag==0) {
        [self getMoren];
    }else{
        [self getZuixin];
    }
    
    [self setupRefresh];
    
}


// 懒加载
- (NSMutableArray *)answerArray{
    if (!_answerArray) {
        _answerArray = [NSMutableArray array];
    }
    return _answerArray;
}
// 或者直接
// 懒加载
- (NSMutableArray *)newanswerArray{
    if (!_newanswerArray) {
        _newanswerArray = [NSMutableArray array];
    }
    return _newanswerArray;
}
-(void) setupRefresh{
    
    //header
    UIView *header = [[UIView alloc]init];
    header.frame = CGRectMake(0, -50, self.tableView.bounds.size.width, 50);
    self.header = header;
    [self.tableView addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.frame =header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    //进来header自动刷新
    [self headerBeginRefreshing];
    
    //footer
    UIView *footer = [[UIView alloc]init];
    footer.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 35);
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc]init];
    footerLabel.frame =footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
    self.tableView.tableFooterView = footer;
}
#pragma mark -代理方法
//用户松开scrollview调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) {
        return;
    }
    
    //可以通过文字或者偏移量
    if (self.tableView.contentOffset.y<=-(50)) {
        //header已经完全出现
        //进入下拉刷新状态
        
        [self headerBeginRefreshing];
        
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //处理header
    [self dealHeader];
    NSLog(@"%f",self.tableView.contentOffset.y);
    //处理footer
    [self dealFooter];
}
//处理header
-(void)dealHeader{
    //如果正在下拉刷新数据，直接返回
    if (self.isHeaderRefreshing) {
        return;
    }
    
    //当scrollview的偏移量y值<=offsetY时，代表header已经完全出现
    if (self.tableView.contentOffset.y<= -(50)) {
        //header已经完全出现
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
    }else{
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
    
}
//处理footer
-(void)dealFooter{
    //还没有内容的时候，不需要判断
    if (self.tableView.contentSize.height==0) {
        return;
    }
    
    //如果正在上拉刷新，直接返回
    if (self.isFooterRefreshing) {
        return;
    }
    
    //当scrollview的偏移量>=ofsetY时，代表footer已经完全出现
    CGFloat ofsetY = self.tableView.contentSize.height+self.tableView.contentInset.bottom-self.tableView.bounds.size.height;
    if (self.tableView.contentOffset.y>=ofsetY &&self.tableView.contentOffset.y>-50) {//footer完全出现，并且是往上拖拽
        [self footerBeginRefreshing];
    }
}
#pragma mark -数据处理
//发送请求给服务器，下拉刷新数据
-(void)loadNewData{
    NSLog(@"发送请求给服务器，下拉刷新数据");
    
    if (_tag==0) {
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0&limit=10&offset=0",self.questionID];
       // NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
            NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
            self.answerArray=[[NSMutableArray alloc ]initWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 0;
                [self.tableView reloadData];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                //结束刷新
                 self.offset = self.answerArray.count;
                 [self headerEndRefreshing];
                
            });
            
            
        }];
        [dataTask resume];
    }
    
    
    
    //重新加载tableviewcell的数据
    if (_tag==1) {
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1&limit=10&offset=0",self.questionID];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
           NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
              self.newanswerArray=[[NSMutableArray alloc ]initWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 1;
                [self.tableView reloadData];
                 self.offset = self.newanswerArray.count;
                //结束刷新
                 [self headerEndRefreshing];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                
            });
            
            
        }];
        [dataTask resume];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //服务器的数据回来了
//        //self.tableView reloadData
//
//        //结束刷新
//        [self headerEndRefreshing];
//    });
}
//发送请求给服务器，上拉加载更多数据
-(void)loadMoreData{
   // offset=%ld",(long)self.offset
    if (_tag==0) {
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0&limit=10&offset=%ld",self.questionID,(long)self.offset];
         NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
           NSMutableArray *Array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
          
            if ( Array.count<=0) {
                [self footerEndRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.footer.hidden =YES;
                    
                });
                
                return ;
            }
            [self.answerArray addObjectsFromArray:Array];
            //[self.orderArray addObjectsFromArray:listItemArray];
            self.offset+=Array.count;

            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 0;
                [self.tableView reloadData];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                //结束刷新
                [self footerEndRefreshing];
                
            });
            
            
        }];
        [dataTask resume];
    }
    
    
    
    //重新加载tableviewcell的数据
    if (_tag==1) {
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1&limit=10&offset=%ld",self.questionID,(long)self.offset];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
           NSMutableArray *Array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
            if ( Array.count<=0) {
                [self footerEndRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.footer.hidden =YES;
                    
                });
                
                return ;
            }
            [self.newanswerArray addObjectsFromArray:Array];
            
            self.offset+=Array.count;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 1;
                [self.tableView reloadData];
                //结束刷新
                [self footerEndRefreshing];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                
            });
            
            
        }];
        [dataTask resume];
    }
//    NSLog(@"正在发送请求-加载更多数据");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //服务器请求回来了
//
//
//        //结束刷新
//        [self footerEndRefreshing];
//    });
}
#pragma mark - header
-(void)headerBeginRefreshing{
    //如果正在下拉刷新数据，直接返回
    if (self.isHeaderRefreshing) {
        return;
    }
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    
    //增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top +=50;
        self.tableView.contentInset =inset;
    }];
    //发送请求给服务器，下拉刷新数据
    [self loadNewData];
    
}
-(void)headerEndRefreshing{
    self.headerRefreshing = NO;
    //减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -=50;
        self.tableView.contentInset =inset;
    }];
    
    //可不写，no会调用didscroll
    //            self.headerLabel.text = @"下拉可以刷新";
    //            self.headerLabel.backgroundColor = [UIColor redColor];
}
#pragma mark - footer
-(void)footerBeginRefreshing{
    //如果正在刷新，直接返回
    if (self.isFooterRefreshing) {
        return;
    }
    //进入刷新状态
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载更多数据...";
    self.footerLabel.backgroundColor = [UIColor blueColor];
    //发送请求给服务器 上拉加载更多数据
    [self loadMoreData];
}
-(void)footerEndRefreshing{
    self.footerRefreshing = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.footerLabel.text = @"上拉可以加载更多";
        self.footerLabel.backgroundColor = [UIColor redColor];
        
    });
  
}

//返回上一级页面
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//默认按钮点击
-(void)defaultClick{
    [self.defaultbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.newbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tag=0;
    //请求最新数据
    
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0&limit=10&offset=0",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
        self.answerArray = [[NSMutableArray alloc]initWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tag = 0;
            [self.tableView reloadData];
            self.offset = self.answerArray.count;
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
   
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1&limit=10&offset=0",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
       NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
       self.newanswerArray = [[NSMutableArray alloc]initWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tag = 1;
            [self.tableView reloadData];
           // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            self.offset = self.answerArray.count;
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
    
    
    return 1;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_tag==0) {
        if ([_answerArray isKindOfClass:[NSNull class]]) {
            return 0;
        }
        return _answerArray.count;
    }else{
        if ([_newanswerArray isKindOfClass:[NSNull class]]) {
            return 0;
        }
        return _newanswerArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[AnswerListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
    if (self.tag==0) {
        [cell layoutTableViewCellWithItem:[self.answerArray objectAtIndex:indexPath.section]];
        NSLog(@"😊我是默认回答排序");
    }else if (self.tag==1){
        [cell layoutTableViewCellWithItem:[self.newanswerArray objectAtIndex:indexPath.section]];
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
         answerdict =  [self.answerArray objectAtIndex:indexPath.section];
    }else if (_tag==1){
       answerdict =  [self.newanswerArray objectAtIndex:indexPath.section];
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
-(void) addAnswer{
    WriteAnswerViewController *wranswer = [[WriteAnswerViewController alloc]init];
    wranswer.questionID = self.questionID;
    [self.navigationController pushViewController:wranswer animated:YES];
}
-(void) getMoren{
    //重新加载tableviewcell的数据
    
        //请求最新数据
        
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=0&limit=10&offset=0",self.questionID];
        NSLog(urlString);
        NSURL *listURL = [NSURL URLWithString:urlString];
        
        //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
            NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
               self.answerArray=[[NSMutableArray alloc ]initWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tag = 0;
                [self.tableView reloadData];
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                self.offset = self.answerArray.count;
            });
            
            
        }];
        [dataTask resume];
    
}
-(void) getZuixin{
    
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers?type=1&limit=10&offset=0",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        NSArray *array =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
           self.answerArray=[[NSMutableArray alloc ]initWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tag = 1;
            [self.tableView reloadData];
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            self.offset = self.answerArray.count;
        });
        
        
    }];
    [dataTask resume];
}

@end
