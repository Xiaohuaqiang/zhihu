//
//  MyAnswerCell.m
//  zhihu
//
//  Created by bytedance on 2021/2/1.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "HotCell.h"

@interface HotCell()
//热榜cell需要的
@property(nonatomic,strong,readwrite) UILabel *titleLabel;

@property(nonatomic,strong,readwrite) UILabel *hotLabel;
@property(nonatomic,strong,readwrite) UILabel *orderLabel;

@end
@implementation HotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self.contentView addSubview:({
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 350, 80)];
             //self.titleLabel.backgroundColor = [UIColor redColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.numberOfLines=1;
            self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.titleLabel;
        })];
        
        
        [self.contentView addSubview:({
            self.hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 90, 100, 30)];
            //self.hotLabel.backgroundColor = [UIColor redColor];
            self.hotLabel.font = [UIFont systemFontOfSize:12];
            //self.hotLabel.numberOfLines=2;
            //self.hotLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.hotLabel.textColor = [UIColor grayColor];
            self.hotLabel;
        })];
        
        [self.contentView addSubview:({
            self.orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 80)];
            //self.orderLabel.backgroundColor = [UIColor redColor];
            self.orderLabel.font = [UIFont systemFontOfSize:16];
           
            self.orderLabel.textColor = [UIColor grayColor];
            self.orderLabel;
        })];
        
        
        
    }
    return self;
}

- (void)layoutTableViewCellWithItem:(NSDictionary *)dict withorder: (NSInteger *)order{
    
    if (dict.count==0) {
        return;
    }else{
       NSString *hot1 =dict[@"hot"];
        int value =[hot1 intValue];
        NSLog(@"%d",value) ;
        NSString *hotstr = [NSString stringWithFormat:@"%d热度",value ];
    self.hotLabel.text = hotstr;
        int ordercount =(int) order;
 NSString *order1 = [NSString stringWithFormat:@" %d",(ordercount+1)];
//        NSLog(str);
        self.orderLabel.text = order1;
    self.titleLabel.text = dict[@"title"];
    }
    
    
}


@end
