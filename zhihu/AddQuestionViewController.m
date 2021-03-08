//
//  AddQuestionViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "AppDelegate.h"
@interface AddQuestionViewController()
@property(nonatomic,strong,readwrite)   UITextField* textView;
@property(nonatomic,strong,readwrite)    UITextView* detailTextView;



@end

@implementation AddQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationItem.backBarButtonItem setTitle:@"返回"];
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pressBack)];
  
    
    self.navigationItem.leftBarButtonItem = backIetm;

    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextField alloc]initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, 100.f)];
    [self.textView setPlaceholder:@"请输入标题并以问号结尾"];
    [self.view addSubview:self.textView];
    self.textView.textColor = [UIColor blackColor];
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.bounds.size.width-10, 20)];
    
    tip.textColor = [UIColor grayColor];
    tip.text = @"问题详细描述";
    [self.view addSubview:tip];
    self.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height-250)];
    self.detailTextView.textColor = [UIColor blackColor];
    [self.view addSubview:self.detailTextView];
    
    //设置发布按钮
    
    UIBarItem* btn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(addQuestion)];
   
    //btn.backgroundColor = [UIColor cyanColor];
    //    btn.layer.masksToBounds = YES;
    //    btn.layer.cornerRadius = 10;
    //btn.backgroundColor = [UIColor grayColor];
//    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
//    [btn setTitle:@"发布" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(addQuestion) forControlEvents:UIControlEventTouchUpInside];
//    //
    self.navigationItem.rightBarButtonItem = btn;
   // [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加到当前view
   
    [self.view addSubview:self.textView];
    [self.view addSubview:self.detailTextView];
    
}

-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//当触碰到非文本域的空白处，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)UIEvent{
    [self.textView resignFirstResponder];
}
-(void)addQuestion{
     NSString *titleText =  [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    if (titleText.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"问题不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefault objectForKey:@"token"];
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://47.102.194.254:8000/api/v1/questions"];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    
    //设置属性,请求超时
    request.timeoutInterval = 10;
    
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    [request setValue:token forHTTPHeaderField:@"token"];
    
    //4.设置请求体信息,字符串--->NSData
    NSString *strBody=  [ NSString stringWithFormat:@"title=%@&content=%@&type=json",self.textView.text,self.detailTextView.text];
    
    request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
  // NSLog(strBody);
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //6.解析数据,NSData --->NSString
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        NSString *code = dict[@"code"];
        NSLog(@"代码是%@",code);
        int code1 = [code intValue];
        
        if(code1==1003){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"数据库错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            self.textView.text = nil;
           self.detailTextView.text = nil;
          
            return;
        }
        
        if(code1 ==0){
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布问题成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            //弹出发布问题成功
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            //返回上一个页面
            
        }
        
    }];
}


@end
