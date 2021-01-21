//
//  QuestionListIterm.m
//  zhihu
//
//  Created by bytedance on 2020/12/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "QuestionListIterm.h"

@implementation QuestionListIterm
-(void)configWithDictionary:(NSDictionary *)dictionary WithTitle:(NSString *)title withID:(NSString *)questionID{
#warning 类型是否匹配
    //{
    //    "id"    : 1,          // 问题id
    //    "title" : "问题1",     // 问题标题
    //    "answer": {
    //        "id"         : 6,           // 回答id
    //        "content"    : "。。。",     // 回答内容
    //        "avatar"     : "",          // 用户头像地址
    //        "nickname"   : "root",      // 用户昵称
    //        "description": ""           // 用户简介
    //    }
    //},
    //判断该问题是否有回答
    if (![dictionary isKindOfClass:[NSNull class]]) {
        self.content= [dictionary objectForKey:@"content"];
        self.avatar= [dictionary objectForKey:@"avatar"];
        self.nickName= [dictionary objectForKey:@"nickname"];
        self.descriptions= dictionary[@"description"];
        self.answerID = dictionary[@"id"];
    }
    self.title = title;
    self.questionID =questionID;
    
    
    
    
}
@end
