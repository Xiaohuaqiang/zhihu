//
//  GTNormalTableViewCell.h
//  SampleApp
//
//  Created by bytedance on 2020/12/8.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GTListIterm;
@protocol GTNormalTableViewCellDelegate <NSObject>
/**
 点击删除按钮
 */
-(void)tableViewCell:(UITableViewCell*)tableViewCell clickDeleteButton:(UIButton *)deleteButton;

@end

/**
 新闻列表cell
 */
@interface GTNormalTableViewCell : UITableViewCell

@property (nonatomic,weak,readwrite) id<GTNormalTableViewCellDelegate> delegate;
- (void)layoutTableViewCellWithItem:(GTListIterm *)item;

@end

NS_ASSUME_NONNULL_END
