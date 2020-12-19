//
//  AddQuestionViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "AppDelegate.h"
@interface AddQuestionViewController (){
   UITextView* textView;
    UITextView* detailTextView;
}


@end

@implementation AddQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //  初始化上述声明的UITextView文本域
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0,100,self.view.bounds.size.width,100)];
    
    // 设置它的背景颜色
    textView.backgroundColor = [UIColor whiteColor];
    // 设置textview里面的字体颜色
    textView.textColor = [UIColor blackColor];
    // 设置默认显示的内容
    textView.text = @"请输入标题";
    //设置是否允许开启滚动
    textView.scrollEnabled = YES;
    //开启是否显示边界
    textView.showsHorizontalScrollIndicator = YES;
    //设置超出边界到时候是否有弹簧效果(默认YES)
    textView.bounces = YES;
    //键盘类型
    textView.keyboardType = UIKeyboardTypeDefault;
    //返回键的类型
    textView.returnKeyType = UIReturnKeyDefault;
    //
     textView.layer.borderWidth =1.0;
    //  初始化上述声明的UITextView文本域
    detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,250,self.view.bounds.size.width,self.view.bounds.size.height-500)];
    
    // 设置它的背景颜色
    detailTextView.backgroundColor = [UIColor whiteColor];
    // 设置textview里面的字体颜色
    detailTextView.textColor = [UIColor blackColor];
    // 设置默认显示的内容
    detailTextView.text = @"请输入问题描述";
    //设置是否允许开启滚动
    detailTextView.scrollEnabled = YES;
    
    detailTextView.layer.borderWidth =1.0;
    //开启是否显示边界
    detailTextView.showsHorizontalScrollIndicator = YES;
    //设置超出边界到时候是否有弹簧效果(默认YES)
    detailTextView.bounces = YES;
    //键盘类型
      detailTextView.keyboardType = UIKeyboardTypeDefault;
    //返回键的类型
    detailTextView.returnKeyType = UIReturnKeyDefault;
    
    //设置发布按钮
    
    UIButton* btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(self.view.bounds.size.width-100, 50, 100, 50);
    //btn.backgroundColor = [UIColor cyanColor];
    //    btn.layer.masksToBounds = YES;
    //    btn.layer.cornerRadius = 10;
    //btn.backgroundColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addQuestion) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加到当前view
   
    [self.view addSubview:textView];
    [self.view addSubview:detailTextView];
    
}


//当触碰到非文本域的空白处，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)UIEvent{
    [textView resignFirstResponder];
}
-(void)addQuestion{
    
    //token string header  是用户令牌   title string POST请求体是标题  content string POST请求体是详细描述
    AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(app.token);
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
    [request setValue:app.token forHTTPHeaderField:@"token"];
    
    //4.设置请求体信息,字符串--->NSData
    NSString *strBody=  [ NSString stringWithFormat:@"title=%@&content=%@&type=json",textView.text,detailTextView.text];
    
    request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
   NSLog(strBody);
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
            textView.text = nil;
           detailTextView.text = nil;
          
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
            
        }
        
    }];
}


@end
