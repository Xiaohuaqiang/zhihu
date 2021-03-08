//
//  MyAnswerCell.h
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HotCellDelegate <NSObject>
@end

@interface HotCell : UITableViewCell
@property (nonatomic,weak,readwrite) id<HotCellDelegate> delegate;
- (void)layoutTableViewCellWithItem:(NSDictionary *)dict withorder: (NSInteger *)order;
@end

NS_ASSUME_NONNULL_END
