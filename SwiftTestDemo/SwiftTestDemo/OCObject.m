//
//  OCObject.m
//  SwiftTestDemo
//
//  Created by MA806P on 2018/7/11.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "OCObject.h"
#import "SwiftTestDemo-Swift.h"

@interface OCObject ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation OCObject

- (void)startTimerRunWithGCD {
    NSLog(@" %s ", __func__);
}

@end
