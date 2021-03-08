//
//  AnswerListViewController.h
//  zhihu
//
//  Created by bytedance on 2020/12/31.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//展示所有回答页面
@interface AnswerListViewController : UIViewController
@property(nonatomic,strong,readwrite) NSString *questiontitle;
//@property(nonatomic,strong,readwrite) NSArray *answerArray;
@property(nonatomic,strong,readwrite) NSString *questionID;
@property(nonatomic,strong,readwrite) NSString *answerID;
@end

NS_ASSUME_NONNULL_END
