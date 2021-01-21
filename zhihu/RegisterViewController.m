//
//  RegisterViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "RegisterViewController.h"
#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size
@interface RegisterViewController (){
    UITextField *loginText;
    UITextField *passwdText;
    UITextField *rePasswdText;
   NSNumber *code ;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    //修改系统自带的返回键为中文d返回
    UIButton *backbutton = [[UIButton alloc ]init];
    [backbutton setFrame:CGRectMake(10, 35, 50, 40)];
    [backbutton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [backbutton setTitle:@"返回" forState:UIControlStateNormal];
    
    [backbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    loginText = [[UITextField alloc] initWithFrame:CGRectMake(20, SCREEN_SIZE.height/5, SCREEN_SIZE.width-40, 50)];
    loginText.borderStyle = UITextBorderStyleRoundedRect;
    loginText.placeholder = @"请输入用户名";
    
    UIImageView *loginImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    loginImage.image = [UIImage imageNamed:@"图片/personalicon_tab.png"];
    
    loginText.leftView = loginImage;
    loginText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:loginText];
    
    
    passwdText = [[UITextField alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/5+70, SCREEN_SIZE.width-40, 50)];
    passwdText.borderStyle = UITextBorderStyleRoundedRect;
    passwdText.placeholder = @"请输入密码";
    passwdText.secureTextEntry = YES;
    
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    passImage.image = [UIImage imageNamed:@"图片/personalicon_tab.png"];
    passwdText.leftView = passImage;
    passwdText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwdText];
    
    rePasswdText = [[UITextField alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/5+140, SCREEN_SIZE.width-40, 50)];
    rePasswdText.borderStyle = UITextBorderStyleRoundedRect;
    rePasswdText.placeholder = @"请输入确认密码";
    rePasswdText.secureTextEntry = YES;
    
    
    UIImageView *rePassImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    rePassImage.image = [UIImage imageNamed:@"图片/personalicon_tab.png"];
    rePasswdText.leftView = rePassImage;
    rePasswdText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:rePasswdText];
    
    
    
    //注册按钮
    UIButton *registerBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(SCREEN_SIZE.width/4*3-50, SCREEN_SIZE.height/5+220, 100, 40);
    [registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 10;
    registerBtn.backgroundColor = [UIColor cyanColor];
    [registerBtn addTarget:self action:@selector(register2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(20, 100, SCREEN_SIZE.width-40, 60)];
//    label.font = [UIFont systemFontOfSize:23];
//    label.text = @"注册页面";
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
    
    
    
//    //返回按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(SCREEN_SIZE.width/2-50, 220, 100, 30);
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

//点击空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [loginText resignFirstResponder];
    [passwdText resignFirstResponder];
    [rePasswdText resignFirstResponder];
}
//返回上一级页面
-(void)backClick{
 [self dismissViewControllerAnimated:YES completion:NULL];
}

//注册前，先做校验
-(void)register2{
    if(loginText.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if(passwdText.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if(rePasswdText.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
   
    if(passwdText.text!=rePasswdText.text){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"两次密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (loginText.text.length<3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册名长度必须大于3" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if(passwdText.text.length<6){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码长度必须大于6" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    //发送请求
    [self setPost];
    /*
     2001注册失败，用户名已存在2002注册失败，两次输入密码不一致2101登录失败，用户不存在2102登录失败，密码错误
     */
    
    
    
}
-(void)setPost{
    //1.确定请求路径
        NSURL *url = [NSURL URLWithString:@"http://47.102.194.254:8000/api/v1/user/register"];
    
        //2.创建可变请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
         //3.修改请求方法,POST必须大写
         request.HTTPMethod = @"POST";
    
         //设置属性,请求超时
         request.timeoutInterval = 10;
    
         //设置请求头User-Agent
        //注意:key一定要一致(用于传递数据给后台)
         [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    
         //4.设置请求体信息,字符串--->NSData
    NSString *strBody=  [ NSString stringWithFormat:@"username=%@&password=%@&password_confirm=%@&type=json",loginText.text,passwdText.text,rePasswdText.text];
    
         request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(strBody);
         //5.发送请求
         [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
                 //6.解析数据,NSData --->NSString
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSLog(@"%@",dict);
             code = dict[@"code"];
             NSLog(@"代码是%@",code);
             int code1 = [code intValue];
             
             if(code1==2001){
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"用户名已存在" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                 }];
                 [alertController addAction:action];
                 [self presentViewController:alertController animated:YES completion:nil];
                 loginText.text = nil;
                 passwdText.text = nil;
                 rePasswdText.text = nil;
                 return;
             }
             
             if(code1 ==0){
                 
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }];
                 //弹出注册成功
                 [alertController addAction:action];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
             
            }];
     }





@end
