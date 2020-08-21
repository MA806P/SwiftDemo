//
//  main.m
//  OCTOSwiftExample
//
//  Created by MA806P on 2018/12/11.
//  Copyright © 2018 myz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTOSwiftExample-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        MySwiftClass *swiftClass = [[MySwiftClass alloc] init];
        [swiftClass sayHello];
        
        
        MySwiftOtherClass *otherClass = [[MySwiftOtherClass alloc] init];
        [otherClass greeting:@"小明"];
        
    }
    return 0;
}
