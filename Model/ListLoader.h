//
//  ListLoader.h
//  zhihu
//
//  Created by bytedance on 2020/12/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
@ class QuestionListIterm;
NS_ASSUME_NONNULL_BEGIN
typedef void(^GTListLoaderFinishBlock)(BOOL success,NSArray<QuestionListIterm *> *dataArray);



@interface ListLoader : NSObject
- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
