//
// Created by Stanislav Ageev on 4/21/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GiphyClientProtocol;
@class GiphyViewModel;

@protocol GiphyViewModelProtocol <NSObject>
@property(nonatomic, copy) NSArray *imageModels;
@property (nonatomic, copy) NSString *query;

- (GiphyViewModel *)initWithGifyClient:(id<GiphyClientProtocol>)client;
- (struct CGSize)sizeForImageModelAtIndex:(NSInteger)index;
- (void)refreshImages;
- (void)loadNextImages;
@end