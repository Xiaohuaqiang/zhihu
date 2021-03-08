


#import "BangView.h"

@interface BangView ()

@property(nonatomic, strong)CAEmitterLayer * explosionLayer;
@property(nonatomic, strong)CAEmitterCell * explosionCell;

@end

@implementation BangView

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

#pragma mark -邢浩- private method
- (void)setUp {
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    
    _explosionCell = [CAEmitterCell emitterCell];
    _explosionCell.name = @"explosion";
    _explosionCell.alphaRange = 0.2f;
    _explosionCell.alphaSpeed = -0.1f;
    _explosionCell.lifetime = 0.7f;
    _explosionCell.lifetimeRange = 0.3f;
    _explosionCell.birthRate = 0.1f;
    _explosionCell.velocity = 40.f;
    _explosionCell.velocityRange = 10.f;
    
    _explosionLayer = [CAEmitterLayer layer];
    _explosionLayer.name = @"emitterLayer";
    _explosionLayer.emitterShape = kCAEmitterLayerCircle;
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;
    _explosionLayer.emitterSize = CGSizeMake(25.f, 0.f);
    _explosionLayer.emitterCells = @[_explosionCell];
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = NO;
    [self.layer addSublayer:_explosionLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.explosionLayer.emitterPosition = center;
}

#pragma mark -邢浩- public method
- (void)animate {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        self.explosionLayer.beginTime = CACurrentMediaTime();
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"emitterCells.explosion.birthRate"];
        animation.fromValue = @0;
        animation.toValue = @500;
        [self.explosionLayer addAnimation:animation forKey:nil];
    });
}

#pragma mark -邢浩- setting
- (void)setParticleImg:(UIImage *)particleImg {
    _particleImg = particleImg;
    self.explosionCell.contents = (id)[particleImg CGImage];
}

- (void)setParticleScale:(CGFloat)particleScale {
    _particleScale = particleScale;
    self.explosionCell.scale = particleScale;
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    _particleScaleRange = particleScaleRange;
    self.explosionCell.scaleRange = particleScaleRange;
}

@end
