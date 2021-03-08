

#import "GoodButton.h"
#import "BangView.h"

@interface GoodButton ()

@property(nonatomic, strong)BangView * bangView;

@end

@implementation GoodButton

#pragma mark -邢浩- 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark -邢浩- private Method
- (void)setUp {
    self.clipsToBounds = NO;
    _bangView = [[BangView alloc] init];
    [self insertSubview:_bangView atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bangView.frame = self.bounds;
    [self insertSubview:self.bangView atIndex:0];
}

- (void)animation {
    [self.bangView animate];
}

#pragma mark -邢浩- public Method
- (void)popOutsideWithDuration:(NSTimeInterval)duration {
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations:^{
            self.transform = CGAffineTransformMakeScale(2.f, 2.f);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1 / 3.0 relativeDuration:1 / 3.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:2 / 3.0 relativeDuration:1 / 3.0 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)popInsideWithDuration:(NSTimeInterval)duration {
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:duration relativeDuration:1 / 2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(1.f, 1.f);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -邢浩- setting && getting
- (UIImage *)goodImg {
    return self.bangView.particleImg;
}

- (void)setGoodImg:(UIImage *)goodImg {
    self.bangView.particleImg = goodImg;
}

- (CGFloat)goodScale {
    return self.bangView.particleScale;
}

- (void)setGoodScale:(CGFloat)goodScale {
    self.bangView.particleScale = goodScale;
}

- (CGFloat)goodScaleRange {
    return self.bangView.particleScaleRange;
}

- (void)setGoodScaleRange:(CGFloat)goodScaleRange {
    self.bangView.particleScaleRange = goodScaleRange;
}

@end
