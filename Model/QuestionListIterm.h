//
//  QuestionListIterm.h
//  zhihu
//
//  Created by bytedance on 2020/12/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
首页结构化数据
 */

NS_ASSUME_NONNULL_BEGIN

@interface QuestionListIterm : NSObject
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
@property(nonatomic,copy,readwrite)   NSString *questionID;
@property (nonatomic ,copy,readwrite) NSString *title;//问题标题
@property (nonatomic ,copy,readwrite) NSString *avatar;//用户头像地址
@property (nonatomic ,copy,readwrite) NSString *nickName;//用户昵称
@property (nonatomic ,copy,readwrite) NSString *content;//用户内容
@property (nonatomic ,copy,readwrite) NSString *descriptions;//用户昵称
@property (nonatomic,copy,readwrite) NSString *answerID;
-(void)configWithDictionary:(NSDictionary *)dictionary WithTitle:(NSString *)title withID:(NSString *)questionID;//

@end

NS_ASSUME_NONNULL_END
