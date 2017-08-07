//
//  NSObject+Swizzling.h
//  低耦合的埋点
//
//  Created by YuXiang on 2017/8/3.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)
+ (void)swizzleInstanceSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSeletor;
@end
