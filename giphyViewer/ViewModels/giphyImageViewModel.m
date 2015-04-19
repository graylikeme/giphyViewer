//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "GiphyImageViewModel.h"
#import "GliphyData.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation GiphyImageViewModel {

}

- (RACSignal *)loadImage {
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];

    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        id<SDWebImageOperation> operation = [manager downloadImageWithURL:self.imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!error) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
                return;
            }

            [subscriber sendError:error];
        }];

        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }] subscribeOn:scheduler];
}

- (id)initWithData:(GiphyDataImage *)imageData {
    self = [super init];
    if(!self)
        return nil;

    self.imageUrl = imageData.imageUrl;
    self.size = (CGSize) {.height = imageData.height, .width = imageData.width};

    return self;
}
@end