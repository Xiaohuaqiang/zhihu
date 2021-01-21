//
//  ListLoader.m
//  zhihu
//
//  Created by bytedance on 2020/12/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ListLoader.h"
#import "QuestionListIterm.h"
@implementation ListLoader
- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock{
    NSString *urlString = @"http://47.102.194.254/api/v1/questions?limit=20&offset=0";
    NSURL *listURL = [NSURL URLWithString:urlString];
    
    //NSURLRequest *listRequest =  [NSURLRequest requestWithURL:listURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
#warning 类型的检查
        NSArray *dataArray = [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"data"]) objectForKey:@"questions"];
       
        
        NSMutableArray *listItemArray = @[].mutableCopy;
        NSInteger i = 0;
        
        for (NSDictionary *info in dataArray) {
            NSString *title = [dataArray[i] objectForKey:@"title"];
            NSString *questionID = [dataArray[i] objectForKey:@"id"];
            NSDictionary *answerDict = [dataArray[i] objectForKey:@"answer"];
            QuestionListIterm *listItem = [[QuestionListIterm alloc]init];
            [listItem configWithDictionary:answerDict WithTitle:title withID:questionID];
            [listItemArray addObject:listItem];
            i++;
       }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(finishBlock){
                finishBlock(error==nil,listItemArray.copy);
            }
        });
        
        NSLog(@"");
    }];
    [dataTask resume];
    
   
}
@end
