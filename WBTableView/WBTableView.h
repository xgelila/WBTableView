//
//  WBTableView.h
//  GoddessClock
//
//  Created by Bing on 15/5/12.
//  Copyright (c) 2015年 wubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTableViewCell.h"
@class WBTableView;

@protocol WBTableViewDelegate<NSObject,UIScrollViewDelegate>
/*点击推荐图片回调*/
- (void)tableView:(WBTableView *)tableView didSelectItemAtIndex:(NSInteger)index;
@end

@protocol WBTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInTableView:(WBTableView *)tableView;
- (WBTableViewCell *)tableView:(WBTableView *)tableView cellForItemAtIndex:(NSInteger)index;
- (CGFloat)tableView:(WBTableView *)tableView widthForItemAtIndex:(NSInteger)index;
@end

@interface WBCellData : NSObject
@property(strong , nonatomic) WBTableViewCell   * cell;
@property (nonatomic ,assign) CGFloat  leftOutOffset;
@property (nonatomic ,assign) CGFloat  rightOutOffset;
@property (nonatomic ,assign) CGFloat  leftInOffset;
@property (nonatomic ,assign) CGFloat  rightInOffset;
@property (nonatomic ,assign) NSInteger index;

- (void)setupWithVisibleWidth:(CGFloat)visibleWidth;
@end

@interface WBTableView : UIScrollView
@property (nonatomic ,assign) id<WBTableViewDelegate>   delegate;
@property (nonatomic ,assign) id<WBTableViewDataSource> dataSource;
- (id)dequeueReusableCell;
- (void)reloadData;
@end
