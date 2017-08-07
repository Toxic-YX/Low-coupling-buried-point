//
//  UIViewController+UserStatistics.m
//  低耦合的埋点
//
//  Created by YuXiang on 2017/8/3.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "UIViewController+UserStatistics.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (UserStatistics)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(viewDidAppear:);
        SEL swizzledSel = @selector(YX_viewDidAppear:);
        
        [self swizzleInstanceSelector:originalSel swizzledSelector:swizzledSel];
    });
    
    static dispatch_once_t onceDidDisappearToken;
    dispatch_once(&onceDidDisappearToken, ^{
        
        SEL originalDidDisappearSel = @selector(viewDidDisappear:);
        SEL swizzledDidDisappearSel = @selector(YX_viewDidDisappear:);
        
        [self swizzleInstanceSelector:originalDidDisappearSel swizzledSelector:swizzledDidDisappearSel];
    });
}

- (void)YX_viewDidAppear:(BOOL)animated {
    [self YX_viewDidAppear:animated];
    
    [self userBehaviorStatistics:@"begin"];
}

- (void)YX_viewDidDisappear:(BOOL)animated {
    [self YX_viewDidDisappear:animated];
    
    [self userBehaviorStatistics:@"end"];
}


/**
 统计用户行为方法

 @param prefix 标识位
 */
- (void)userBehaviorStatistics:(NSString *)prefix {
    
    NSDictionary *dic = [self dictionaryFromUserStatisticsPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    NSString *pageName = dic[selfClassName];
    if (pageName) {
        if ([prefix isEqualToString:@"begin"]) {
            [self beginLogPageView:pageName];
        }else if ([prefix isEqualToString:@"end"]) {
            [self endLogPageView:pageName];
        }
    }
}

/**
 *  加载Plist文件
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryFromUserStatisticsPlist {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserStatistics" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

/**
 *  begin页面统计
 *
 *  @param pageName 页面名称
 */
- (void)beginLogPageView:(NSString *)pageName {
    // 在这里可以添加统计代码,如友盟：[MobClick endLogPageView:pageName];
    NSLog(@"页面统计：begin%@",pageName);
}
/**
 *  end页面统计
 *
 *  @param pageName 页面名称
 */
- (void)endLogPageView:(NSString *)pageName {
    // 在这里可以添加统计代码,如友盟：[MobClick endLogPageView:pageName];
    NSLog(@"页面统计：end%@",pageName);
}

@end
