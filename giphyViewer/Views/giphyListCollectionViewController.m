//
// Created byStanislav Ageev on 4/20/15.
// Copyright (c) 2015 Stanislav Ageev. All rights reserved.
//

#import "GiphyListCollectionViewController.h"
#import "GiphyCellProtocol.h"
#import "GiphyCellView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "GiphyViewModelProtocol.h"
#import "SVProgressHUD.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface GiphyListCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) id<GiphyViewModelProtocol> viewModel;
@property(nonatomic, strong) UISearchBar *searchBar;
@end

@implementation GiphyListCollectionViewController {

}

- (instancetype)initWithViewModel:(id<GiphyViewModelProtocol>)viewModel {
    self = [super init];
    if(!self)
        return nil;

    self.viewModel = viewModel;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);

    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collection.translatesAutoresizingMaskIntoConstraints = NO;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.alwaysBounceVertical = YES;
    self.collection.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);

    self.refreshControl = [UIRefreshControl new];
    [self.collection addSubview:self.refreshControl];

    self.searchBar = [UISearchBar new];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.placeholder = @"Search...";
    self.searchBar.delegate = self;

    [self.view addSubview:self.collection];
    [self.view addSubview:self.searchBar];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_searchBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collection]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collection)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collection]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collection)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[_searchBar(44)]" options:0 metrics:@{@"padding": @(self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)} views:NSDictionaryOfVariableBindings(_collection, _searchBar)]];


    [self.collection registerClass:[GiphyCellView class] forCellWithReuseIdentifier:@"giphyCell"];


    @weakify(self);
    [RACObserve(self.viewModel, imageModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.collection reloadData];
        [self.refreshControl endRefreshing];
        [self.collection.infiniteScrollingView stopAnimating];
        [SVProgressHUD dismiss];
    }];

    RAC(self.viewModel, query) = RACObserve(self.searchBar, text);
    self.searchBar.text = @"hello";

    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel refreshImages];
    }];

    [self.collection addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self.viewModel loadNextImages];
    }];

    self.collection.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

    [SVProgressHUD show];
    [self.viewModel refreshImages];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.imageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<GiphyCellProtocol> *cell = [self.collection dequeueReusableCellWithReuseIdentifier:@"giphyCell" forIndexPath:indexPath];
    [cell setViewModel:self.viewModel.imageModels[indexPath.row]];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  [self.viewModel sizeForImageModelAtIndex:indexPath.row];
}


#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;

    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = self.viewModel.query;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.query = searchBar.text;
    [self.viewModel refreshImages];
    [searchBar resignFirstResponder];
}


@end