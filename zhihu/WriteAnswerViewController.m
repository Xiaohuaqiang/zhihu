//
//  WriteAnswerViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/31.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "WriteAnswerViewController.h"

@interface WriteAnswerViewController ()
 @property(nonatomic,readwrite,strong)   UITextView *textview;

@end

@implementation WriteAnswerViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithTitle:@"发布回答" style:UIBarButtonItemStyleDone target:self action:@selector(addAnswer)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    _textview = [[UITextView alloc]initWithFrame:self.view.bounds];
    [_textview setTextColor:[UIColor blackColor]];
    [_textview setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_textview];
}

-(void)addAnswer{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    
    //1.确定请求路径
    ///api/v1/questions/{qid}/answers
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers",self.questionID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //3.创建可变的请求对象
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    
         //4.修改请求方法为POST
         request.HTTPMethod = @"POST";
    //设置请求头token
       [request setValue:token forHTTPHeaderField:@"token"];
    
    //4.设置请求体信息,字符串--->NSData
    NSString *strBody=  [ NSString stringWithFormat:@"content=%@&type=json",self.textview.text];
    
    request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(strBody);
    NSLog(token);
    
    NSURLSession *session = [NSURLSession sharedSession];
      NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
                //8.解析数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
          NSString *code = dict[@"code"];
          NSLog(@"代码是%@",code);
          int code1 = [code intValue];
          
          if(code1 ==0){
             //发布回答成功
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布回答成功" preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                      [self.navigationController popViewControllerAnimated:YES];
                      
                  }];
                  //弹出发布问题成功
                  [alertController addAction:action];
                  [self presentViewController:alertController animated:YES completion:nil];
                  
              });
             
              
          }
        
            }];
    [dataTask resume];
}
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
