//
//  ViewController.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "MessageViewController.h"
#import "TopViewController.h"
#import "AppDelegate.h"
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
@interface ViewController ()
{
    UITextField *loginText;
    UITextField *passwdText;
    NSNumber *code;
    
    
}
    


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    loginText = [[UITextField alloc] initWithFrame:CGRectMake(20, SCREEN_SIZE.height/4, SCREEN_SIZE.width-40, 60)];
    loginText.borderStyle = UITextBorderStyleRoundedRect;
    loginText.placeholder = @"请输入用户名";
    
    UIImageView *loginImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loginImage.image = [UIImage imageNamed:@"图片/personalicon_tab.png"];
    
    loginText.leftView = loginImage;
    loginText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:loginText];
    
    
    passwdText = [[UITextField alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/4+50, SCREEN_SIZE.width-40, 60)];
    passwdText.borderStyle = UITextBorderStyleRoundedRect;
    passwdText.placeholder = @"请输入密码";
    passwdText.secureTextEntry = YES;
    
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    passImage.image = [UIImage imageNamed:@"图片/personalicon_tab.png"];
    passwdText.leftView = passImage;
    passwdText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwdText];
    
    //创建登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(SCREEN_SIZE.width/4-50, SCREEN_SIZE.width/4+250, 100, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 10;
    loginBtn.backgroundColor = [UIColor cyanColor];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册按钮
    UIButton *registerBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(SCREEN_SIZE.width/4*3-50,  SCREEN_SIZE.width/4+250, 100, 40);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 10;
    registerBtn.backgroundColor = [UIColor cyanColor];
    [registerBtn addTarget:self action:@selector(register1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

//登录前，先做校验
-(void)login{
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
    if (loginText.text.length<3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录名长度必须大于3" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (passwdText.text.length<6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码长度必须大于等于6" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    [self setPost];
    
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
    //弹出登录成功
//    [alertController addAction:action];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    //登录成功跳转到主页面
    
    
    
}
//点击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [loginText resignFirstResponder];
    [passwdText resignFirstResponder];
}

//注册
-(void)register1{
    
    RegisterViewController *registe = [[RegisterViewController alloc]init];
    
    [self presentViewController:registe animated:YES completion:nil];
}
-(void)setPost{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://47.102.194.254:8000/api/v1/user/login"];
  
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
    NSString *strBody=  [ NSString stringWithFormat:@"username=%@&password=%@&type=json",loginText.text,passwdText.text];
    
    request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(strBody);
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //6.解析数据,NSData --->NSString
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSLog(@"%@",dict);
        code = dict[@"code"];
        //NSLog(@"代码是%@",code);
        int code1 = [code intValue];
        
        //用户名不存在
        if(code1==2101){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"用户名不存在" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        //密码错误
        if (code1==2102) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        if(code1 ==0){
            //设置token值
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSDictionary *dictData = dict[@"data"];
            app.token = dictData[@"token"];
            //NSLog(app.token);
            
            //登陆成功，进行持久化存储
            NSString *userName = loginText.text;
            NSString *passWord = passwdText.text;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userName forKey:@"username"];
            [userDefaults setObject:passWord forKey:@"password"];
            [userDefaults  setObject:app.token forKey:@"token"];
            [userDefaults synchronize];
            
          
            
            UITabBarController *tabbarcontroller = [[UITabBarController alloc]init];
            MainViewController *mainController = [[MainViewController alloc]init];
            MyViewController *myController = [[MyViewController alloc]init];
            MessageViewController *messageController = [[MessageViewController alloc]init];
            
            mainController.tabBarItem.title = @"首页";
            messageController.tabBarItem.title = @"消息";
            myController.tabBarItem.title = @"我的";
            
           
            
            
            [tabbarcontroller setViewControllers:@[mainController,messageController,myController]];
            //[self.navigationController presentViewController:tabbarcontroller animated:YES completion:nil];
            //tabbarcontroller.title=@"g标题";
//            UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(pressLeftbtn)];
//            tabbarcontroller.navigationItem.leftBarButtonItem = leftbtn;
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabbarcontroller];
            //设置根控制器
            app.window.rootViewController = nav;
//            [self.navigationController pushViewController:tabbarcontroller animated:YES];
        }
        
    }];
}
//-(void)pressLeftbtn{
//    //[self.navigationController popViewControllerAnimated:YES];
//}




@end
