//
//  GoodButton.h
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodButton : UIButton

@property(nonatomic, strong)UIImage * goodImg;
@property(nonatomic, assign)CGFloat goodScale;
@property(nonatomic, assign)CGFloat goodScaleRange;

- (void)animation;
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
