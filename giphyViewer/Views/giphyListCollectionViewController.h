//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GiphyViewModelProtocol;


@interface GiphyListCollectionViewController : UIViewController

- (instancetype)initWithViewModel:(id<GiphyViewModelProtocol>)viewModel;

@end