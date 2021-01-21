//
//  CleanAnswerViewController.m
//  zhihu
//
//  Created by bytedance on 2021/1/3.
//  Copyright © 2021 bytedance. All rights reserved.
//

/*
 只展示回答的页面
 */
#import "ClearAnswerViewController.h"
#import "ModifyAnswerViewController.h"
@interface ClearAnswerViewController ()
@property(nonatomic,strong,readwrite) UITextView *textview;
@end

@implementation ClearAnswerViewController

-(void)viewWillAppear:(BOOL)animated{
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
    _textview.text = self.answerContent;
    [_textview setEditable:NO];
    [scrollView addSubview:_textview];
    
    
    [self.view addSubview:scrollView];
    
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
    
    
}
//修改回答按钮的点击事件
-(void)modifyAnswer{
    ModifyAnswerViewController *modifyvc = [[ModifyAnswerViewController alloc]init];
    modifyvc.content = self.textview.text;
   modifyvc.questionID = self.questionID;
   modifyvc.answerID = self.answerID;
    [self.navigationController pushViewController:modifyvc animated:YES];
    
}

//返回上一级页面
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
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
@end
