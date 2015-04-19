//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiphyViewModelProtocol.h"

@class RACSignal;


@interface GiphyViewModel : NSObject <GiphyViewModelProtocol>

@property(nonatomic, copy) NSArray *imageModels;
@property (nonatomic, copy) NSString *query;

@end