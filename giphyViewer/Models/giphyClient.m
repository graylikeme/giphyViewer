//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import "GiphyClient.h"
#import "GliphyData.h"
#import <RestKit/RestKit.h>
#import "NSString+URLEncoding.h"
#import "GiphyClientProtocol.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface GiphyClient ()
@property(nonatomic, copy) NSString *requestUrlTemplate;
@property(nonatomic, strong) RKObjectMapping *mapping;
@end

@implementation GiphyClient {

}

- (instancetype)initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (!self)
        return nil;

    self.requestUrlTemplate = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q={{query}}&api_key=%@&offset={{offset}}", apiKey];
    self.mapping = [self buildMappings];

    return self;
}

- (RACSignal *)imagesWithQuery:(NSString *)query andOffset:(NSNumber *)offset {
    NSString *requestUrl = [self buildRequestUrlWithQuery:query offset:offset];
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];

    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
            [subscriber sendNext:result.firstObject];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {

            [subscriber sendError:error];
        }];

        [requestOperation start];

        return [RACDisposable disposableWithBlock:^{
            [requestOperation cancel];
        }];
    }] subscribeOn:scheduler];
}

- (NSString *)buildRequestUrlWithQuery:(NSString *)query offset:(NSNumber *)offset {
    NSString *encodedQuery = [query urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSString *requestUrl = [self.requestUrlTemplate stringByReplacingOccurrencesOfString:@"{{query}}" withString:encodedQuery];
    requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@"{{offset}}" withString:[offset stringValue]];
    return requestUrl;
}

- (RKObjectMapping *)buildMappings {
    RKObjectMapping *dataMapping = [RKObjectMapping mappingForClass:[GiphyDataImage class]];
    [dataMapping addAttributeMappingsFromDictionary:@{
            @"images.fixed_width_small.url": @"imageUrl",
            @"images.fixed_width_small.height": @"height",
            @"images.fixed_width_small.width": @"width"
    }];


    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[GiphyDataPagination class]];
    [paginationMapping addAttributeMappingsFromDictionary:@{
            @"total_count":@"totalCount",
            @"count":@"count",
            @"offset":@"offset"
    }];

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[GiphyData class]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"pagination" toKeyPath:@"pagination" withMapping:paginationMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"data" withMapping:dataMapping]];

    return mapping;
}

@end