
#import "MyLikeViewController.h"
#import "AnswerListViewController.h"
#import "AnswerListCell.h"
#import "ClearAnswerViewController.h"
@interface MyLikeViewController ()<UITableViewDataSource,UITableViewDelegate,AnswerListCellDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
//@property(nonatomic,strong,readwrite) UIButton *defaultbutton;
//@property(nonatomic,strong,readwrite) UIButton *newbutton;
//@property(nonatomic,readwrite) NSInteger tag;//tag为0的时候表示默认，为1的时候表示最新；
@property(nonatomic,strong,readwrite) NSArray  *answerArray;//保存最新排序的数据
@end

@implementation MyLikeViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
     self.tabBarController.tabBar.hidden = YES;
    //重新加载tableviewcell的数据
   
        //请求最新数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/user/awesomes"];
        NSLog(urlString);
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

            self.answerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.answerArray isKindOfClass:[NSNull class]]||self.answerArray.count==0) {
                    [self.tableView removeFromSuperview];
                    UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
                    label.textColor = [UIColor grayColor];
                    label.text = @"还没有点赞";
                    label.textAlignment = NSTextAlignmentCenter;
                    [self.view addSubview:label];}
                    else{
                        [self.tableView reloadData];
                    }
               
                
                // [self.button1 setTitle:answercount forState:UIControlStateNormal];
                
            });
            
            
        }];
        [dataTask resume];
    
    }
    
    
    
    


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight =3;
    _tableView.sectionFooterHeight = 5;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.navigationItem.title = @"我的点赞";
    
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
    if ([_answerArray isKindOfClass:[NSNull class]]) {
        return 0;
    }
    return _answerArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[AnswerListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
   
        [cell layoutTableViewCellWithItem:[self.answerArray objectAtIndex:indexPath.section]];
    
    //[cell layoutTableViewCellWithItem:[self.answerArray objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击uitableview跳转到一个view
    //NSLog(@"😯我被点击了");
    ClearAnswerViewController *clearvc = [[ClearAnswerViewController alloc]init];
    NSDictionary* answerdict ;
    
        answerdict =  [self.answerArray objectAtIndex:indexPath.section];
   

    clearvc.answerContent = answerdict[@"content"];
   // clearvc.questionTitle = self.questiontitle;


    clearvc.nickname =answerdict[@"nickname"];
    clearvc.questionID = answerdict[@"qid"];
    clearvc.answerID = answerdict[@"id"];
    
    
    
    
    
    [self.navigationController pushViewController:clearvc animated:YES];
    
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 20;
}

@end
