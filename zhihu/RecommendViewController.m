//
//  RecommendViewController.m
//  zhihu
//
//  Created by bytedance on 2021/2/8.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "RecommendViewController.h"
#import "GTNormalTableViewCell.h"
#import "ListLoader.h"
#import "QuestionListIterm.h"
#import "QuestionDetailViewController.h"
@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource,GTNormalTableViewCellDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArrays;
@property(nonatomic,strong) NSMutableArray *orderArray;
@property(nonatomic,strong,readwrite) ListLoader *listLoader;

@property(nonatomic,readwrite) NSInteger offset;
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

@implementation RecommendViewController
-(void)viewDidAppear:(BOOL)animated{
    return;
//    //从上一个页面返回的时候刷新数据
//    self.listLoader = [[ListLoader alloc]init];
//
//    __weak typeof (self) wself = self;
//    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<QuestionListIterm *> * _Nonnull dataArray) {
//        __strong typeof (self)strongSelf = wself;
//        strongSelf.dataArray = dataArray;
//        [strongSelf.tableView reloadData];
//    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //设置内边距
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 256, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight =0;
    _tableView.sectionFooterHeight = 5;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.listLoader = [[ListLoader alloc]init];
    
    __weak typeof (self) wself = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSMutableArray<QuestionListIterm *> * _Nonnull dataArray) {
        __strong typeof (self)strongSelf = wself;
        strongSelf.dataArrays = dataArray.mutableCopy;
        [strongSelf.tableView reloadData];
    }];
    
    [self setupRefresh];
}

// 或者直接
// 懒加载
- (NSMutableArray *)dataArrays{
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
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
    NSLog(@"%f",self.tableView.contentOffset.y);
    //处理header
    [self dealHeader];
    
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
    //从上一个页面返回的时候刷新数据
      NSLog(@"发送请求给服务器，下拉刷新数据");
    self.listLoader = [[ListLoader alloc]init];
    
    __weak typeof (self) wself = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<QuestionListIterm *> * _Nonnull dataArray) {
        __strong typeof (self)strongSelf = wself;
        strongSelf.dataArrays = dataArray.mutableCopy;
        [strongSelf.tableView reloadData];
        self.offset = dataArray.count;
        //结束刷新
        [self headerEndRefreshing];
    }];
  
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //服务器的数据回来了
//        //self.tableView reloadData
//
//
//    });
}
//发送请求给服务器，上拉加载更多数据
-(void)loadMoreData{
    
    NSString *urlString = [NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions?limit=10&offset=%ld",(long)self.offset ] ;
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSString *countstr = [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"count"];
           NSInteger count = [countstr integerValue];
        if (count<=0) {
            [self footerEndRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
            self.footer.hidden =YES;
                
            });
           
            return ;
        }
#warning 类型的检查
        NSArray *datalist = [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"questions"];
        
        
        NSMutableArray *listItemArray = [NSMutableArray arrayWithCapacity:datalist.count];
        NSInteger i = 0;
        
        
        for (NSDictionary *info in datalist) {
            NSString *title = [datalist[i] objectForKey:@"title"];
            NSString *questionID = [datalist[i] objectForKey:@"id"];
            NSDictionary *answerDict = [datalist[i] objectForKey:@"answer"];
            QuestionListIterm *listItem = [[QuestionListIterm alloc]init];
            [listItem configWithDictionary:answerDict WithTitle:title withID:questionID];
            [listItemArray addObject:listItem];
            i++;
        }
        [self.dataArrays addObjectsFromArray:listItemArray];
        //[self.orderArray addObjectsFromArray:listItemArray];
        self.offset+=listItemArray.count;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
       
        //结束刷新
               [self footerEndRefreshing];
       
        
        //NSLog(@"");
    }];
    [dataTask resume];
    
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
    //根据数据量显示或者隐藏footer
    self.footer.hidden = (self.dataArrays.count==0);
    return self.dataArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GTNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[GTNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
    ;
    [cell layoutTableViewCellWithItem:[self.dataArrays objectAtIndex:indexPath.section]];
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
    QuestionListIterm *ss  = [self.dataArrays objectAtIndex:indexPath.section];
    //去除l标题两端空格和换行
    NSString *strtitle =  [ss.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    controller.questionTitle = strtitle;
    controller.questionID = ss.questionID;
    controller.answerID = ss.answerID;
    controller.answerContent = ss.content;
    controller.nickname = ss.nickName;
    [self.navigationController pushViewController:controller animated:YES];
    
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
}
//

@end
