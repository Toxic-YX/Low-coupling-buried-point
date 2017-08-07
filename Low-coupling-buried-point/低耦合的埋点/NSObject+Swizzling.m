//
//  NSObject+Swizzling.m
//  低耦合的埋点
//
//  Created by YuXiang on 2017/8/3.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)


/**
 实例方法swizzle
  instance method swizzle

 @param originalSelector 原方法
 @param swizzledSeletor 替换方法
 */
+ (void)swizzleInstanceSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSeletor {
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSeletor);
    
    // 若已经存在，则添加会失败
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        
                                        method_getImplementation(swizzledMethod),
                                        
                                        method_getTypeEncoding(swizzledMethod));
    // 若原来的方法并不存在，则添加即可
    
    if (didAddMethod) {
        
        class_replaceMethod(class,swizzledSeletor,
                            
                            method_getImplementation(originalMethod),
                            
                            method_getTypeEncoding(originalMethod));
        
    } else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
