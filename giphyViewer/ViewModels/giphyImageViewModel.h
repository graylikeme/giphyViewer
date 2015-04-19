//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GiphyImageViewModelProtocol.h"

@class GiphyDataImage;

@interface GiphyImageViewModel : NSObject <GiphyImageViewModelProtocol>

@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, assign) CGSize size;

@end