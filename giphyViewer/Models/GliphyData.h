//
// Created by Stanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiphyDataImage : NSObject

@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;

@end

@interface GiphyDataPagination : NSObject

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger offset;

@end

@interface GiphyData : NSObject

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, strong) GiphyDataPagination *pagination;

@end
