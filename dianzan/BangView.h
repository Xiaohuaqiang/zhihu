//
//  BangView.h
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BangView : UIView
@property(nonatomic, strong)UIImage * particleImg;
@property(nonatomic, assign)CGFloat particleScale;
@property(nonatomic, assign)CGFloat particleScaleRange;

- (void)animate;
@end

NS_ASSUME_NONNULL_END
