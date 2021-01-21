//
//  WriteAnswerViewController.h
//  zhihu
//
//  Created by bytedance on 2020/12/31.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//写回答页面
@interface WriteAnswerViewController : UIViewController
@property(nonatomic,strong,readwrite) NSString *questionID;
@end

NS_ASSUME_NONNULL_END
