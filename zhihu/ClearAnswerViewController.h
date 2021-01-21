//
//  CleanAnswerViewController.h
//  zhihu
//
//  Created by bytedance on 2021/1/3.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClearAnswerViewController : UIViewController
@property(nonatomic,strong,readwrite) NSString *questionTitle;
@property(nonatomic,strong,readwrite) NSString *answerContent;
@property(nonatomic,strong,readwrite) NSString *nickname;

@property(nonatomic,strong,readwrite) NSString *questionID;
@property(nonatomic,strong,readwrite) NSString *answerID;

@end

NS_ASSUME_NONNULL_END
