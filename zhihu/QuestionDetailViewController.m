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

@interface QuestionDetailViewController ()<UITableViewDelegate>

@property(nonatomic,strong,readwrite) UIButton *button1;
@property(nonatomic,strong,readwrite) UIButton *button2;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSArray *answerArray;
@property(nonatomic,strong,readwrite) UITextView *textview;
//@property(nonatomic, strong)GoodButton * goodBtn;//点赞按钮
@property(nonatomic,strong,readwrite) UIButton *goodButton;
@property(nonatomic,strong,readwrite) UIButton *badButton;
@property(nonatomic,strong,readwrite) UILabel *countLabel;//显示点赞数

@property(nonatomic,readwrite) NSInteger sum;//点赞数

@property(nonatomic,readwrite) NSInteger tag;//标记是否对回答点赞，1为点赞过，0为没点赞

@end

@implementation QuestionDetailViewController

-(void) viewDidAppear:(BOOL)animated{
  
    //隐藏TabBar
    
        self.tabBarController.tabBar.hidden = YES;
    
    //当添加回答之后，返回该页面的时候，重新加载数据。加block判断是否添加了回答再重新拉接口
    //请求数据获取回答数
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers",self.questionID];
    //NSLog(urlString);
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
       // NSLog(answercount);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.button1 setTitle:answercount forState:UIControlStateNormal];
        });
        
        //NSLog(@"%d",count);
    }];
    [dataTask resume];
    
    if (self.textview.text.length!=0) {
        [self freshContent];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
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
   
  
    

   // 点赞总数
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, self.view.bounds.size.height-60, 60, 30)];

    self.countLabel.textColor = [UIColor cyanColor];
   
    [self.view addSubview:_countLabel];
    
    //设置点赞按钮
  _goodButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height-60, 40, 30)];

    [self.view addSubview:_goodButton];
    [_goodButton addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchDown];
    //设置点d踩按钮
    _badButton = [[UIButton alloc]initWithFrame:CGRectMake(120, self.view.bounds.size.height-60, 40, 30)];
 
    [_badButton addTarget:self action:@selector(diancai) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_badButton];
    
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


//点赞按钮点击
//- (void)ClickEvent:(GoodButton *)btn {
//    if (btn.selected) {
//        [btn popInsideWithDuration:0.4f];
//        //取消赞
//        [self clickLike:@"neutral"];
//    } else {
//        [btn popOutsideWithDuration:0.5f];
//        [btn animation];
//        //点赞
//        [self clickLike:@"up"];
//    }
//    btn.selected = !btn.selected;
//}


//按钮1点击事件，跳转到新视图，将回答通过tableview展示
-(void)buttonClick1{
    NSString *buttontext = self.button1.titleLabel.text;
    if (![buttontext isEqualToString:@"0个回答"] ) {
        AnswerListViewController *anlist = [[AnswerListViewController alloc]init];
        //将问题标题传给回答列表页面
        anlist.questiontitle = self.questionTitle;
        //anlist.answerArray = self.answerArray;
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
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
        //NSLog(answercount);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.button1 setTitle:answercount forState:UIControlStateNormal];
        });
        
      //  NSLog(@"%d",count);
    }];
    [dataTask resume];
}


//点赞按钮点击
-(void)dianzan{
    if (self.tag==0) {
        //点赞
        self.sum = (self.sum+1);
        int su = (int)self.sum ;
        NSString *sum1 = [NSString stringWithFormat:@"%d", su];
        self.countLabel.text = sum1;
        self.tag=1;
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good_selected"] forState:UIControlStateNormal];
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
        [self clickLike:@"up"];
        
    }else if (self.tag==1){
        //取消点赞
        self.sum = (self.sum-1);
        int su = (int)self.sum ;
        NSString *sum1 = [NSString stringWithFormat:@"%d", su];
        self.countLabel.text = sum1;
        self.tag=0;
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
        [self clickLike:@"neutral"];
    }else{
        //取消点踩，点赞
        self.sum = (self.sum+1);
        int su = (int)self.sum ;
        NSString *sum1 = [NSString stringWithFormat:@"%d", su];
        self.countLabel.text = sum1;
        self.tag=1;
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good_selected"] forState:UIControlStateNormal];
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
        [self clickLike:@"neutral"];
        [self clickLike:@"up"];
    }
}
//点踩按钮点击
-(void)diancai{
    if (self.tag==0) {
        //点踩
        
        self.tag=2;
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad_selected"] forState:UIControlStateNormal];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
        [self clickLike:@"down"];
    }else if (self.tag==1){
        //取消点赞，点踩
        self.sum = (self.sum-1);
        int su = (int)self.sum ;
        NSString *sum1 = [NSString stringWithFormat:@"%d", su];
        self.countLabel.text = sum1;
        self.tag=2;
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad_selected"] forState:UIControlStateNormal];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
        [self clickLike:@"down"];
    }else{
        //取消点踩
      
        self.tag=0;
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
        [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
        [self clickLike:@"neutral"];
    }
}
//查看回答
//获取回答内容
-(void)getcontent{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    
    //1.确定请求路径
    ///api/v1/questions/{qid}/answers/{aid}
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
   // NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    
    
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
    
   // NSLog(token);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSDictionary *dict =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answer"];
        //获得点赞数
       
       NSString *value = dict[@"like_count"];
        int value1 = [value intValue];
        self.sum = value1;
        NSString *count = [NSString stringWithFormat:@"%d", value1];
        NSString *bz =dict[@"like_status"];
        
        NSString *contentText = dict[@"content"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //获得是否点赞  1赞2踩0无
            self.tag = [bz intValue];
            if (self.tag==1) {
                [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good_selected"] forState:UIControlStateNormal];
                 [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
            }else if(self.tag==0){
                [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
                 [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad"] forState:UIControlStateNormal];
            }else{
                 [self.badButton setBackgroundImage:[UIImage imageNamed:@"图片/bad_selected"] forState:UIControlStateNormal];
                 [self.goodButton setBackgroundImage:[UIImage imageNamed:@"图片/good"] forState:UIControlStateNormal];
            }
            self.countLabel.text = count;
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
        
        
         NSNumber *code1 = jsonObj[@"code"];
        
        int code = [code1 intValue];
        if (code==4001) {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.textview.text = nil;
            });
            
            
            return ;
        }
        
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
-(void)clickLike:(NSString *)type{
    
  //  /api/v1/answers/{aid}/voters
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token =  [userDefault objectForKey:@"token"];
    // NSLog(token);
    //请求数据获取回答
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/answers/%@/voters",self.answerID];
    // NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:listURL];
      request.HTTPMethod = @"POST";
    [request setValue:token forHTTPHeaderField:@"token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    NSDictionary *parData = [[NSDictionary alloc] initWithObjectsAndKeys: type, @"type", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSError *jsonError;
       // id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

//        NSDictionary *dict =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"answer"];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            //[self.button1 setTitle:answercount forState:UIControlStateNormal];
//            self.textview.text=dict[@"content"];
//        });
//
//
    }];
    [dataTask resume];
}


@end


