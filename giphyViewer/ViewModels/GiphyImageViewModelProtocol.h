//
// Created by Stanislav Ageev on 4/21/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RACSignal;
@class GiphyDataImage;

@protocol GiphyImageViewModelProtocol <NSObject>
@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, assign) CGSize size;

- (id)initWithData:(GiphyDataImage *)imageData;
- (RACSignal *)loadImage;
@end