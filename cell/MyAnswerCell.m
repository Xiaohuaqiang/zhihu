//
//  MyAnswerCell.m
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "MyAnswerCell.h"

@interface MyAnswerCell()
//回答cell需要的
@property(nonatomic,strong,readwrite) UILabel *titleLabel;

@property(nonatomic,strong,readwrite) UILabel *contentLabel;

@end
@implementation MyAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
   
        [self.contentView addSubview:({
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 400, 30)];
            //self.titleLabel.backgroundColor = [UIColor redColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.numberOfLines=1;
            self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.titleLabel;
        })];
     
      
        [self.contentView addSubview:({
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 400, 90)];
             //self.contentLabel.backgroundColor = [UIColor redColor];
            self.contentLabel.font = [UIFont systemFontOfSize:12];
            self.contentLabel.numberOfLines=2;
            self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.contentLabel.textColor = [UIColor grayColor];
            self.contentLabel;
        })];
      
     
        
        
    }
    return self;
}

- (void)layoutTableViewCellWithItem:(NSDictionary *)dict{
    
    
    
    self.contentLabel.text = dict[@"content"];
    
    self.titleLabel.text = dict[@"title"];
   
   
    
}


@end
