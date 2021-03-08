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
            self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 50, 20)];
           // self.nickNameLabel.backgroundColor = [UIColor redColor];
            self.nickNameLabel.font = [UIFont systemFontOfSize:12];
            self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
            self.nickNameLabel.textColor = [UIColor grayColor];
            self.nickNameLabel;
        })];
        [self.contentView addSubview:({
            self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 45, 50, 20)];
            //self.descriptionLabel.backgroundColor = [UIColor redColor];
            self.descriptionLabel.font = [UIFont systemFontOfSize:12];
            self.descriptionLabel.textColor = [UIColor grayColor];
            self.descriptionLabel;
        })];
        [self.contentView addSubview:({
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 380, 50)];
            // self.contentLabel.backgroundColor = [UIColor redColor];
            self.contentLabel.font = [UIFont systemFontOfSize:12];
            self.contentLabel.numberOfLines=2;
            self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.contentLabel.textColor = [UIColor grayColor];
            self.contentLabel;
        })];
        [self.contentView addSubview:({
            self.picitureview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 20, 20)];
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
    if (!item.content ) {
        self.contentLabel.text=@"暂无回答";
        return;
    }else{
        self.contentLabel.text = item.content;
    }
    if(!item.avatar){
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
            CGSize size = CGSizeMake(20, 20);
            UIImage *scaleimage = [ self newImage:image scaleToSize:size];
            dispatch_async(mainQueue, ^{
                
                self.picitureview.image = scaleimage;
            });
        });
        
    }
    if (!item.descriptions) {
        self.descriptionLabel.text=@"学生";
    }else{
        self.descriptionLabel.text=item.descriptions;
         //self.descriptionLabel.text=@"学生";
    }

    //self.descriptionLabel.text = item.descriptions;
   
    if (!item.nickName  ) {
       // self.nickNameLabel.text = @"昵称";
    }else{
        NSLog(@"%@",item.nickName);
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
