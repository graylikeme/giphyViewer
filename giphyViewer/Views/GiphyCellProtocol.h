//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GiphyImageViewModel;
@protocol GiphyImageViewModelProtocol;

@protocol GiphyCellProtocol <NSObject>

- (void)setViewModel:(id<GiphyImageViewModelProtocol>)data;

@end