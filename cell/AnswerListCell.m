//
//  AnswerListCell.m
//  zhihu
//
//  Created by bytedance on 2021/1/3.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "AnswerListCell.h"
@interface AnswerListCell()
//回答cell需要的
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *nickNameLabel;
@property(nonatomic,strong,readwrite) UILabel *contentLabel;
@property(nonatomic,strong,readwrite) UIImageView *picitureview;
@property(nonatomic,strong,readwrite) UILabel *descriptionLabel;
@end
@implementation AnswerListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:({
            self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 50, 20)];
            //self.nickNameLabel.backgroundColor = [UIColor redColor];
            self.nickNameLabel.font = [UIFont systemFontOfSize:12];
            self.nickNameLabel.textColor = [UIColor grayColor];
            self.nickNameLabel;
        })];
        [self.contentView addSubview:({
            self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 20, 20)];
           // self.descriptionLabel.backgroundColor = [UIColor redColor];
            self.descriptionLabel.font = [UIFont systemFontOfSize:12];
            self.descriptionLabel.textColor = [UIColor grayColor];
            self.descriptionLabel;
        })];
        [self.contentView addSubview:({
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 350, 75)];
             //self.contentLabel.backgroundColor = [UIColor redColor];
            self.contentLabel.font = [UIFont systemFontOfSize:12];
            self.contentLabel.textColor = [UIColor grayColor];
            self.contentLabel.numberOfLines=2;
            self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.contentLabel;
        })];
        [self.contentView addSubview:({
            self.picitureview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
           // self.picitureview.backgroundColor = [UIColor redColor];
            
            
            self.picitureview.contentMode = UIViewContentModeScaleAspectFill;
            self.picitureview;
        })];
        
        
    }
    return self;
}
//设置cell的各个值
//"id"          : 6,            // 回答id
//"qid"         : 2,            // 所属问题id
//"content"     : "。。。",      // 回答内容
//"avatar"      : "",           // 用户头像地址
//"nickname"    : "root",       // 用户昵称
//"description" : "",           // 用户简介
//"created_at"  : 1608376165    // 创建时间戳
- (void)layoutTableViewCellWithItem:(NSDictionary *)dict{
    
    
    
        self.contentLabel.text = dict[@"content"];
    
    
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
        CGSize size = CGSizeMake(20, 20);
        UIImage *newimage = [self newImage:image scaleToSize:size];
        self.picitureview.image =newimage;
    
   
        self.descriptionLabel.text=dict[@"description"];
    

    //self.descriptionLabel.text = item.descriptions;

    
        self.nickNameLabel.text = dict[@"nickname"];
    
}

// 图片缩放(不改变像素)
-(UIImage *)newImage:(UIImage *)image scaleToSize:(CGSize)size
{
    
    
    
    UIGraphicsBeginImageContext(size);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
