//
//  ModifyAnswerViewController.h
//  zhihu
//
//  Created by bytedance on 2021/1/4.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModifyAnswerViewController : UIViewController
@property(nonatomic,strong,readwrite) NSString *content;
@property(nonatomic,strong,readwrite) NSString *questionID;
@property(nonatomic,strong,readwrite) NSString *answerID;
@property(nonatomic,strong) void(^block)(NSString *value);
@end

NS_ASSUME_NONNULL_END
