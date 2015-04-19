//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import "GiphyViewModel.h"
#import "GiphyImageViewModel.h"
#import "GliphyData.h"
#import "GiphyClientProtocol.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface GiphyViewModel ()
@property(nonatomic, strong) id<GiphyClientProtocol> giphyClient;
@property(nonatomic) NSInteger offset;
@property(nonatomic) NSInteger count;
@end

@implementation GiphyViewModel {

}

- (instancetype)initWithGifyClient:(id<GiphyClientProtocol>)client {
    self = [super init];
    if(!self)
        return nil;

    id<GiphyImageViewModelProtocol> testModel = [GiphyImageViewModel new];
    testModel.imageUrl = [NSURL URLWithString:@"http://media1.giphy.com/media/JApYh06rwXphS/200w.gif"];
    testModel.size = (CGSize) {.height = 200, .width = 200};

    self.giphyClient = client;

    return self;
}

- (CGSize)sizeForImageModelAtIndex:(NSInteger)index {
    return ((id<GiphyImageViewModelProtocol>)self.imageModels[index]).size;
}

- (void)refreshImages {
    [[[self.giphyClient imagesWithQuery:self.query andOffset:@(0)] map:^(GiphyData *imageData) {
        self.offset = imageData.pagination.offset;
        self.count = imageData.pagination.count;

        return [imageData.data.rac_sequence map:^id(GiphyDataImage *dataImage) {
            return [[GiphyImageViewModel alloc] initWithData:dataImage];
        }];
    }] subscribeNext:^(RACSequence *imageDataSequance) {
        self.imageModels = imageDataSequance.array;
    }];
}

- (void)loadNextImages {
    [[[self.giphyClient imagesWithQuery:self.query andOffset:@(self.offset + self.count)] map:^(GiphyData *imageData) {
        self.offset = imageData.pagination.offset;
        self.count = imageData.pagination.count;

        return [imageData.data.rac_sequence map:^id(GiphyDataImage *dataImage) {
            return [[GiphyImageViewModel alloc] initWithData:dataImage];
        }];
    }] subscribeNext:^(RACSequence *imageDataSequance) {
        self.imageModels = [self.imageModels arrayByAddingObjectsFromArray:imageDataSequance.array];
    }];
}
@end