//
//  QuestionDetailViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AnswerListViewController.h"
#import "WriteAnswerViewController.h"
#import "ModifyAnswerViewController.h"
@interface QuestionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong,readwrite) UIButton *button1;
@property(nonatomic,strong,readwrite) UIButton *button2;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSArray *answerArray;
@property(nonatomic,strong,readwrite) UITextView *textview;
@end

@implementation QuestionDetailViewController

-(void) viewDidAppear:(BOOL)animated{
    //当添加回答之后，返回该页面的时候，重新加载数据。加block判断是否添加了回答再重新拉接口
    //请求数据获取回答数
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        _answerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
        NSString *count= [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"count"];
        // NSString *sum =  [NSString stringWithFormat: @"%d", count];
        
        NSString *answercount = [NSString stringWithFormat:@"%@个回答",count];
        NSLog(answercount);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.button1 setTitle:answercount forState:UIControlStateNormal];
        });
        
        NSLog(@"%d",count);
    }];
    [dataTask resume];
    
    if (self.textview.text.length!=0) {
        [self freshContent];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   //设置问题标题
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(self.view.bounds.size.width/4, 90, self.view.bounds.size.width/2, 60);
    titleLabel.text = self.questionTitle;
    [titleLabel setTextColor:[UIColor blackColor]];
    //titleLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.button1 = [[UIButton alloc]initWithFrame:CGRectMake(90, 150, 100, 50)];
    
    
    [self.button1 addTarget:self action:@selector(buttonClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    
    self.button2 = [[UIButton alloc]initWithFrame:CGRectMake(250, 150, 100, 50)];
    [self.button2 setTitle:@"写回答" forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(buttonClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height)];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-280)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-280); ;
    
    scrollView.delegate = self;
    //给textview加入到scrollview中
    _textview = [[UITextView alloc ]initWithFrame:scrollView.bounds];
    _textview.backgroundColor = [UIColor whiteColor];
    //加入回答
    //_textview.text = self.answerContent;
   [_textview setEditable:NO];
    [scrollView addSubview:_textview];
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //得到该回答的用户昵称与登录用户的昵称进行对比，若相同则在底部展示修改回答和删除回答按钮
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *username  = (NSString*) [userdefault objectForKey:@"username"];
    if ([self.nickname isEqualToString:username]) {
        //修改回答按钮
        UIButton *modifybutton = [[UIButton alloc ]init];
        modifybutton.frame = CGRectMake(self.view.bounds.size.width/2+20,self.view.bounds.size.height-60 , 40, 30);
        // modifybutton.backgroundColor = [UIColor redColor];
        [modifybutton setTitle:@"修改" forState:UIControlStateNormal];
        [modifybutton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        //添加点击修改按钮事件
        [modifybutton addTarget:self action:@selector(modifyAnswer) forControlEvents:UIControlEventTouchUpInside];
        //删除回答按钮
        UIButton *delbutton = [[UIButton alloc ]init];
        delbutton.frame = CGRectMake(self.view.bounds.size.width/2+80,self.view.bounds.size.height-60 , 40, 30);
        //delbutton.backgroundColor = [UIColor redColor];
        [delbutton setTitle:@"删除" forState:UIControlStateNormal];
        [delbutton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        //添加点击删除按钮事件
        [delbutton addTarget:self action:@selector(deleteAnswer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delbutton];
        [self.view addSubview:modifybutton];
    }
    
    
    //设置横线
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 0.5f)];
    [lineview setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineview];
    //设置竖线
    UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 150, 0.5f, 50)];
    [lineview2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineview2];
    //设置底部视图
//    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 80)];
//    footview.backgroundColor = [UIColor whiteColor];
    
    //评论按钮
    UIButton *commentbutton = [[UIButton alloc ]init];
    commentbutton.frame = CGRectMake(self.view.bounds.size.width/2+140,self.view.bounds.size.height-60 , 40, 30);
    //commentbutton.backgroundColor = [UIColor redColor];
    [commentbutton setTitle:@"评论" forState:UIControlStateNormal];
    [commentbutton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
   
     [self.view addSubview:commentbutton];
    //设置横线
    UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 0.5f)];
    [lineview3 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineview3];
    
    //请求数据获取回答数
    [self getCount];
    
    //设置回答内容![dictionary isKindOfClass:[NSNull class]]
    if (_answerID ) {
        [self.textview setEditable:NO];
         [self getcontent];
    }
   
    
    
    
    
    
   
        
}
//按钮1点击事件，跳转到新视图，将回答通过tableview展示
-(void)buttonClick1{
    NSString *buttontext = self.button1.titleLabel.text;
    if (![buttontext isEqualToString:@"0个回答"] ) {
        AnswerListViewController *anlist = [[AnswerListViewController alloc]init];
        //将问题标题传给回答列表页面
        anlist.questiontitle = self.questionTitle;
        anlist.answerArray = self.answerArray;
        anlist.questionID = self.questionID;
        //anlist.answerID =self.answerID;
        [self.navigationController pushViewController:anlist animated:YES];
    }
}
//按钮2点击事件，跳转到新视图，写回答页面
-(void)buttonClick2{
    WriteAnswerViewController *wranswer = [[WriteAnswerViewController alloc]init];
    wranswer.questionID = self.questionID;
    [self.navigationController pushViewController:wranswer animated:YES];
}
//修改回答按钮的点击事件
-(void)modifyAnswer{
    ModifyAnswerViewController *modifyvc = [[ModifyAnswerViewController alloc]init];
    modifyvc.content = self.textview.text;
    modifyvc.questionID = self.questionID;
    modifyvc.answerID = self.answerID;
    [self.navigationController pushViewController:modifyvc animated:YES];
    
}
//删除回答按钮的点击事件
-(void)deleteAnswer{
   
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除回答" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token =  [userDefault objectForKey:@"token"];
        NSLog(token);
        //删除回答
        // /api/v1/questions/{qid}/answers/{aid}
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
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
        
        
    }];
    //弹出确认删除提醒框
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getCount{
    //请求数据获取回答数
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        _answerArray =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answers"];
        NSString *count= [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"count"];
        // NSString *sum =  [NSString stringWithFormat: @"%d", count];
        
        NSString *answercount = [NSString stringWithFormat:@"%@个回答",count];
        NSLog(answercount);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.button1 setTitle:answercount forState:UIControlStateNormal];
        });
        
        NSLog(@"%d",count);
    }];
    [dataTask resume];
}
//获取回答内容
-(void)getcontent{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    
    //1.确定请求路径
    ///api/v1/questions/{qid}/answers/{aid}
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    
    
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
    
    NSLog(token);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSDictionary *dict =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answer"];
        NSString *contentText = dict[@"content"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.textview.text = contentText;
            [self.textview setEditable:NO];
            
        });
        
    }];
    [dataTask resume];
}
-(void)freshContent{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   NSString *token =  [userDefault objectForKey:@"token"];
    NSLog(token);
    //请求数据获取回答
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:listURL];
    [request setValue:token forHTTPHeaderField:@"token"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        NSDictionary *dict =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answer"];
//        NSString *count= [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"count"];
        // NSString *sum =  [NSString stringWithFormat: @"%d", count];
        
       // NSString *answercount = [NSString stringWithFormat:@"%@个回答",count];
        //NSLog(answercount);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[self.button1 setTitle:answercount forState:UIControlStateNormal];
            self.textview.text=dict[@"content"];
        });
        
       // NSLog(@"%d",count);
    }];
    [dataTask resume];
}
@end


