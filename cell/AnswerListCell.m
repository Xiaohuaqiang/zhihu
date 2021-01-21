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
            self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 50, 50)];
            //self.nickNameLabel.backgroundColor = [UIColor redColor];
            self.nickNameLabel.font = [UIFont systemFontOfSize:12];
            self.nickNameLabel.textColor = [UIColor grayColor];
            self.nickNameLabel;
        })];
        [self.contentView addSubview:({
            self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 50, 50)];
           // self.descriptionLabel.backgroundColor = [UIColor redColor];
            self.descriptionLabel.font = [UIFont systemFontOfSize:12];
            self.descriptionLabel.textColor = [UIColor grayColor];
            self.descriptionLabel;
        })];
        [self.contentView addSubview:({
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 350, 50)];
             //self.contentLabel.backgroundColor = [UIColor redColor];
            self.contentLabel.font = [UIFont systemFontOfSize:12];
            self.contentLabel.textColor = [UIColor grayColor];
            self.contentLabel.numberOfLines=2;
            self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.contentLabel;
        })];
        [self.contentView addSubview:({
            self.picitureview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
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
        self.picitureview.image =image ;
    
   
        self.descriptionLabel.text=dict[@"description"];
    

    //self.descriptionLabel.text = item.descriptions;

    
        self.nickNameLabel.text = dict[@"nickname"];
    
}


@end
