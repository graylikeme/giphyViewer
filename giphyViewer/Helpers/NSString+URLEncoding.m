//
// Created by Stanislav Ageev on 4/21/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {

    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(
                kCFAllocatorDefault,
                (__bridge CFStringRef) self,
                NULL,
                CFSTR(":/?#[]@!$&'()*+,;="),
            CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end