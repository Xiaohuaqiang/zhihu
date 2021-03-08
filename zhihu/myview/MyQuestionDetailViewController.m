//
//  MyQuestionDetailViewController.m
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "MyQuestionDetailViewController.h"

@interface MyQuestionDetailViewController ()
@property(nonatomic,strong,readwrite) UITextView *textTitle;
@property(nonatomic,strong,readwrite) UITextView *textContent;


@end

@implementation MyQuestionDetailViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textTitle = [[UITextView alloc]initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, 100.f)];
    [self.view addSubview:_textTitle];
     _textTitle.textColor = [UIColor grayColor];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.bounds.size.width-10, 20)];
   
    tip.textColor = [UIColor grayColor];
     tip.text = @"问题详细描述";
    [self.view addSubview:tip];
    self.textContent = [[UITextView alloc]initWithFrame:CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height-250)];
         _textContent.textColor = [UIColor grayColor];
    [self.view addSubview:_textContent];
    
    //设置右上角确认修改
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStylePlain target:self action:@selector(modify)];
    //删除按钮
    UIButton *deletetbutton = [[UIButton alloc ]init];
    deletetbutton.frame = CGRectMake(self.view.bounds.size.width/2+140,self.view.bounds.size.height-60 , 40, 30);
    //commentbutton.backgroundColor = [UIColor redColor];
    [deletetbutton setTitle:@"删除" forState:UIControlStateNormal];
    [deletetbutton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [deletetbutton addTarget:self action:@selector(deleteQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletetbutton];
    [self getinfo];
}


//获取问题的标题以及问题的详细描述
-(void) getinfo{
    //请求最新数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@",self.questionID];
    //NSLog(urlString);
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
        
       NSDictionary *question =[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"question"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.textTitle.text = question[@"title"];
            self.textContent.text = question[@"content"];
            // [self.button1 setTitle:answercount forState:UIControlStateNormal];
            
        });
        
        
    }];
    [dataTask resume];
}
-(void)modify{
    NSLog(@"确认");
    
    NSString *contentText =  [self.textTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (contentText.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"标题不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    //1.确定请求路径
    // /api/v1/questions/{qid}/
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@",self.questionID];
    //NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    //4.修改请求方法为PUT
    request.HTTPMethod = @"PUT";
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
   
    NSDictionary *parData = [[NSDictionary alloc] initWithObjectsAndKeys: self.textTitle.text, @"title",self.textContent.text, @"content" ,nil];
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
-(void)deleteQuestion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除问题" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token =  [userDefault objectForKey:@"token"];
        //NSLog(token);
        //删除问题
        // /api/v1/questions/{qid}
        NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@",self.questionID];
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

@end
