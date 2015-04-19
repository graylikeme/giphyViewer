//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GiphyCellView.h"
#import "GiphyImageViewModelProtocol.h"


@interface GiphyCellView ()
@property(nonatomic, weak) id<GiphyImageViewModelProtocol> data;
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation GiphyCellView {

}

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;

    [self setupSubviews];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;

    [self setupSubviews];

    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor redColor];

    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:self.imageView];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}

- (void)setViewModel:(id<GiphyImageViewModelProtocol>)data {
    if(self.data == data)
        return;
    self.data = data;
    self.imageView.image = nil;
    RAC(self.imageView, image) = [[[[self.data loadImage] deliverOnMainThread] takeUntil:self.rac_prepareForReuseSignal] catch:^RACSignal *(NSError *error) {
        NSLog(@"Failed to load image: %@", [error localizedDescription]);
        return [RACSignal return:nil];
    }];
}

@end