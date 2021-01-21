//
//  AnswerListCell.h
//  zhihu
//
//  Created by bytedance on 2021/1/3.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AnswerListCellDelegate <NSObject>

@end
@interface AnswerListCell : UITableViewCell
@property (nonatomic,weak,readwrite) id<AnswerListCellDelegate> delegate;
- (void)layoutTableViewCellWithItem:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
