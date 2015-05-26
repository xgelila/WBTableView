//
//  ViewController.m
//  WBTableViewDemo
//
//  Created by Bing on 15/5/18.
//  Copyright (c) 2015年 Bing. All rights reserved.
//
#define SPORT_IMAGE_SIZE CGSizeMake(60.f,60.f)
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#import "ViewController.h"
#import "WBTableView.h"
@interface ViewController ()<WBTableViewDataSource,WBTableViewDelegate>

@end

@implementation ViewController
{
    WBTableView * _tableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self tableView]];
    [self _layoutPageViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - WBTableViewDelegate
- (void)tableView:(WBTableView *)tableView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"------%ld",(long)index);
    
}

#pragma mark - WBTableViewDataSource
- (NSInteger)numberOfItemsInTableView:(WBTableView *)tableView
{
    return 50;
}

- (CGFloat)tableView:(WBTableView *)tableView widthForItemAtIndex:(NSInteger)index
{
    return 70.f;
}

- (WBTableViewCell *)tableView:(WBTableView *)tableView cellForItemAtIndex:(NSInteger)index
{
    WBTableViewCell * cell =  [tableView dequeueReusableCell];
    if (cell == nil)
    {
        cell = [[WBTableViewCell alloc] init];

        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SPORT_IMAGE_SIZE.width, SPORT_IMAGE_SIZE.height)];
        imageView.image = [UIImage imageNamed:@"head"];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = SPORT_IMAGE_SIZE.width/2;
        imageView.layer.masksToBounds = YES;
        [cell addSubview:imageView];
    }
    return cell;
}

#pragma mark - private method
- (void)_layoutPageViews
{
    _tableView.frame = CGRectMake(0, 100, ScreenWidth, 70.f);
}

#pragma mark - getter
- (WBTableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[WBTableView alloc] init];
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
