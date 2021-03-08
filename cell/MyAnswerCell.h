//
//  MyAnswerCell.h
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MyAnswerCellDelegate <NSObject>
@end

@interface MyAnswerCell : UITableViewCell
@property (nonatomic,weak,readwrite) id<MyAnswerCellDelegate> delegate;
- (void)layoutTableViewCellWithItem:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
