//
//  HTTPConnect.h
//  zhihu
//
//  Created by bytedance on 2020/12/30.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPConnect : NSObject
-(NSDictionary*) getResponseData :(NSString *)url;
@end

NS_ASSUME_NONNULL_END
