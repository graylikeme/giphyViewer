//
// Created by Stanislav Ageev on 4/21/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol GiphyClientProtocol <NSObject>
- (instancetype)initWithApiKey:(NSString *)apiKey;
- (RACSignal *)imagesWithQuery:(NSString *)query andOffset:(NSNumber *)offset;
@end