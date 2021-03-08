//
//  MyAnswerDetailViewController.m
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "MyAnswerDetailViewController.h"

@interface MyAnswerDetailViewController ()
@property(nonatomic,strong,readwrite) UITextView *textview;
@property(nonatomic,strong,readwrite) UIButton *goodButton;
@property(nonatomic,strong,readwrite) UIButton *badButton;
@property(nonatomic,strong,readwrite) UILabel *countLabel;//显示点赞数

@property(nonatomic,readwrite) NSInteger sum;//点赞数

@property(nonatomic,readwrite) NSInteger tag;//标记是否对回答点赞，1为点赞过，0为没点赞
@end

@implementation MyAnswerDetailViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
        self.tabBarController.tabBar.hidden = YES;
    //返回该页面时刷新文本框回答
    if (self.textview.text.length!=0) {
        [self freshContent];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置问题标题
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(self.view.bounds.size.width/4, 90, self.view.bounds.size.width/2, 60);
    titleLabel.text = self.questionTitle;
    [titleLabel setTextColor:[UIColor blackColor]];
    //titleLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    
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
    //设置右上角确认修改
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStylePlain target:self action:@selector(modify)];
    //设置横线
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 0.5f)];
    [lineview setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineview];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-280)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-280); ;
    
    //scrollView.delegate = self;
    //给textview加入到scrollview中
    _textview = [[UITextView alloc ]initWithFrame:scrollView.bounds];
    _textview.backgroundColor = [UIColor whiteColor];
    //加入回答
    //_textview.text = self.answerContent;
    
    [scrollView addSubview:_textview];
    
    
    [self.view addSubview:scrollView];
    
   
    
    //评论按钮
    UIButton *deleteButton = [[UIButton alloc ]init];
    deleteButton.frame = CGRectMake(self.view.bounds.size.width/2+140,self.view.bounds.size.height-60 , 40, 30);
    //commentbutton.backgroundColor = [UIColor redColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    //设置横线
    UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 0.5f)];
    [lineview3 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineview3];
    
    [self freshContent];
    [self getcontent];
}


//返回上一级页面
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)freshContent{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token =  [userDefault objectForKey:@"token"];
   // NSLog(token);
    //请求数据获取回答
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
   // NSLog(urlString);
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
-(void)modify{
    NSLog(@"确认");
    
    NSString *contentText =  [self.textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (contentText.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"回答不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    //1.确定请求路径
 //  /api/v1/questions/{qid}/answers/{aid}
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
    //NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    //4.修改请求方法为PUT
    request.HTTPMethod = @"PUT";
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    
    NSDictionary *parData = [[NSDictionary alloc] initWithObjectsAndKeys: self.textview.text, @"content",nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parData options:0 error:&error];
    [request setHTTPBody:postData];
    //NSLog(strBody);
    //  NSLog(token);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *code = dict[@"code"];
        //NSLog(@"代码是%@",code);
        int code1 = [code intValue];
        if(code1 ==0){
            //发布回答成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改回答成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                //                if (_block) {
                //                    _block(@"123");
                //                }
                //弹出修改回答成功
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
            
            
        }
        
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
        
    }];
    [dataTask resume];
}
@end

