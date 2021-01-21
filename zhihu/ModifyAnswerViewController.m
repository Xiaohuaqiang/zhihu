//
//  ModifyAnswerViewController.m
//  zhihu
//
//  Created by bytedance on 2021/1/4.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "ModifyAnswerViewController.h"
#import "QuestionDetailViewController.h"
@interface ModifyAnswerViewController ()
@property(nonatomic,strong,readwrite) UITextView *textView;

@end

@implementation ModifyAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc]init];
    [_textView setFrame:CGRectMake(0, 64, self.view.bounds.size.width,  self.view.bounds.size.height)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = _content;
    [self.view addSubview:_textView];
    //右侧完成修改按钮
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(modifyAnswer)];
    self.navigationItem.rightBarButtonItem = rightbutton;
}
//将修改后的回答返回给后端
-(void)modifyAnswer{
    NSString *contentText =  [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
   // /api/v1/questions/{qid}/answers/{aid}
    NSString *urlString = [ NSString stringWithFormat:@"http://47.102.194.254/api/v1/questions/%@/answers/%@",self.questionID,self.answerID];
    NSLog(urlString);
    NSURL *listURL = [NSURL URLWithString:urlString];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:listURL];
    //4.修改请求方法为PUT
    request.HTTPMethod = @"PUT";
    //设置请求头token
    [request setValue:token forHTTPHeaderField:@"token"];
    
       [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    //4.设置请求体信息,字符串--->NSData
    //NSString *strBody=  [ NSString stringWithFormat:@"content=%@&type=json",self.textView.text];
    

    //4.设置请求体信息,字符串--->NSData
//    NSString *contentText =  [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *strBody=  [ NSString stringWithFormat:@"content=%@&type=json",contentText];
//    NSDictionary *parameter= @{@"content":self.textView.text};
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:Nil];
//    [request setHTTPBody:jsonData];
    //[request setHTTPBody:postData];
   
    NSDictionary *parData = [[NSDictionary alloc] initWithObjectsAndKeys: self.textView.text, @"content", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parData options:0 error:&error];
    [request setHTTPBody:postData];
    //NSLog(strBody);
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

@end
