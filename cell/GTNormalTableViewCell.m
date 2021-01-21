//
//  GTNormalTableViewCell.m
//  SampleApp
//
//  Created by bytedance on 2020/12/8.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "GTNormalTableViewCell.h"
#import "QuestionListIterm.h"

@interface GTNormalTableViewCell()
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *nickNameLabel;
@property(nonatomic,strong,readwrite) UILabel *contentLabel;
@property(nonatomic,strong,readwrite) UIImageView *picitureview;
@property(nonatomic,strong,readwrite) UILabel *descriptionLabel;
//@property(nonatomic,strong,readwrite) UIImageView *rightImageView;

@property(nonatomic,strong,readwrite) UIButton *deleteButton;

@end

@implementation GTNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:({
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 270, 30)];
            //self.titleLabel.backgroundColor = [UIColor redColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.numberOfLines=1;
            self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.titleLabel;
        })];
        [self.contentView addSubview:({
            self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 50, 40)];
            //self.nickNameLabel.backgroundColor = [UIColor redColor];
            self.nickNameLabel.font = [UIFont systemFontOfSize:12];
            self.nickNameLabel.textColor = [UIColor grayColor];
            self.nickNameLabel;
        })];
        [self.contentView addSubview:({
            self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, 50, 40)];
            //self.descriptionLabel.backgroundColor = [UIColor redColor];
            self.descriptionLabel.font = [UIFont systemFontOfSize:12];
            self.descriptionLabel.textColor = [UIColor grayColor];
            self.descriptionLabel;
        })];
        [self.contentView addSubview:({
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 380, 60)];
            // self.contentLabel.backgroundColor = [UIColor redColor];
            self.contentLabel.font = [UIFont systemFontOfSize:12];
            self.contentLabel.numberOfLines=2;
            self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.contentLabel.textColor = [UIColor grayColor];
            self.contentLabel;
        })];
        [self.contentView addSubview:({
            self.picitureview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 50, 40)];
            //self.picitureLabel.backgroundColor = [UIColor redColor];
           
            
            self.picitureview.contentMode = UIViewContentModeScaleAspectFill;
            self.picitureview;
        })];
        
        //        [self.contentView addSubview:({
        //            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 80, 30, 20)];
        //
        //            [self.deleteButton setTitle:@"X" forState:UIControlStateNormal];
        //            [self.deleteButton setTitle:@"V" forState:UIControlStateHighlighted];
        //            [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //            //self.deleteButton.backgroundColor = [UIColor blueColor];
        //
        //            self.deleteButton.layer.cornerRadius = 10;
        //            self.deleteButton.layer.masksToBounds = YES;
        //            self.deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //            self.deleteButton.layer.borderWidth = 2;
        //
        //            self.deleteButton;
        //        })];
    }
    return self;
}
- (void)layoutTableViewCellWithItem:(QuestionListIterm *)item{
   NSString *strtitle =  [item.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.titleLabel.text = strtitle;
    if (item.content.length==0 ) {
        self.contentLabel.text=@"暂无回答";
    }else{
        self.contentLabel.text = item.content;
    }
    if(item.avatar.length==0){
       // UIImage *image  = [UIImage imageNamed:@"图片/personalicon_tab.png"];
       //self.picitureview.image =image ;
    }else{
//        NSThread *downloadImage = [[NSThread alloc]initWithBlock:^{
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.avatar]]];
//            self.picitureview.image =image ;
//        }];
//        downloadImage.name = @"downloadImage";
//        [downloadImage start];
        
        dispatch_queue_global_t doloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_main_t mainQueue = dispatch_get_main_queue();
        dispatch_async(doloadQueue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.avatar]]];
            dispatch_async(mainQueue, ^{
                self.picitureview.image = image;
            });
        });
        
    }
    if (item.descriptions.length==0) {
        //self.descriptionLabel.text=@"个人描述";
    }else{
        self.descriptionLabel.text=item.descriptions;
    }

    //self.descriptionLabel.text = item.descriptions;
   
    if (item.nickName.length==0) {
       // self.nickNameLabel.text = @"昵称";
    }else{
        self.nickNameLabel.text = item.nickName;}
    
  
#warning
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//    self.rightImageView.image = image;
}
-(void) deleteButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDeleteButton:)]) {
        [self.delegate tableViewCell:self clickDeleteButton:self.deleteButton];
    }
}
@end
