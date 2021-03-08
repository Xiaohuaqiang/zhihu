//
//  MyAnswerDetailViewController.h
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAnswerDetailViewController : UIViewController
@property(nonatomic,strong,readwrite) NSString *answerID;
@property(nonatomic,strong,readwrite) NSString *questionTitle;

@property(nonatomic,strong,readwrite) NSString *questionID;
@end

NS_ASSUME_NONNULL_END
