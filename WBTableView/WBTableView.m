//
//  WBTableView.m
//  GoddessClock
//
//  Created by Bing on 15/5/12.
//  Copyright (c) 2015年 wubing. All rights reserved.
//
#define GAP  4.f

#import "WBTableView.h"

@implementation WBCellData
- (void)setupWithVisibleWidth:(CGFloat)visibleWidth
{
    CGFloat x = self.cell.frame.origin.x;
    CGFloat width = self.cell.frame.size.width;
    self.leftOutOffset = x + width;
    self.rightOutOffset = x - visibleWidth;
    self.rightInOffset = x - (visibleWidth-width);
    self.leftInOffset = x;
}
@end

@interface WBTableView()
@property(strong , nonatomic) NSMutableArray * visibleCells;
@property(strong , nonatomic) NSMutableArray * reusableCells;
@end

@implementation WBTableView
{
    CGPoint                     _lastContentOffset;
    NSInteger                   _numberOfItem;
}

@dynamic delegate;

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_numberOfItem == 0)
    {
        [self reloadData];
    }else{
        if (_lastContentOffset.x < self.contentOffset.x)
        {
            [self _handleLeftScrolling:self.contentOffset];
        }else if(_lastContentOffset.x > self.contentOffset.x){
            [self _handleRightScrolling:self.contentOffset];
        }
        _lastContentOffset = self.contentOffset;
    }
}

#pragma mark - interface
- (WBTableViewCell *)dequeueReusableCell
{
    WBTableViewCell * cell = nil;
    if (self.reusableCells.count > 0)
    {
        cell = [self.reusableCells lastObject];
        [self.reusableCells removeLastObject];
    }
    return cell;
}
- (void)reloadData
{
    if (_dataSource == nil)
    {
        return;
    }
    if (self.visibleCells.count > 0)
    {
        [self.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WBCellData * cellData = obj;
            [cellData.cell removeFromSuperview];
            [self.reusableCells addObject:cellData.cell];
        }];
        [self.visibleCells removeAllObjects];
    }
    NSInteger number = [_dataSource numberOfItemsInTableView:self];
    _numberOfItem = number;
    CGFloat contentWidth = 0.f;
    CGFloat visibleWidth = self.frame.size.width;
    for (int i = 0; i < number; ++i)
    {
        CGFloat  width = [_dataSource tableView:self widthForItemAtIndex:i];
        if (visibleWidth > 0)
        {
            visibleWidth -= width;
            CGFloat x = contentWidth;
            WBTableViewCell * cell = [_dataSource tableView:self cellForItemAtIndex:i];
            cell.frame = CGRectMake(x, 0, width,self.frame.size.height);
            [self addSubview:cell];
            WBCellData * cellData = [[WBCellData alloc] init];
            cellData.cell = cell;
            [cellData setupWithVisibleWidth:self.frame.size.width];
            cellData.index = i;
            [self.visibleCells addObject:cellData];
        }
        contentWidth += width;
    }
    self.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}

#pragma mark - response event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self _handleTouchEventAtPoint:point];
}

#pragma mark private method
- (void)_handleLeftScrolling:(CGPoint)contentOffset
{
    //view will disappear
    WBCellData * fistCellData = [_visibleCells firstObject];
    if (contentOffset.x >= fistCellData.leftOutOffset)
    {
        WBTableViewCell * cell = fistCellData.cell;
        [cell removeFromSuperview];
        [_visibleCells removeObject:fistCellData];
        [self.reusableCells addObject:cell];
    }
    //view will appear
    WBCellData * lastCellData = [_visibleCells lastObject];
    if (contentOffset.x >= lastCellData.rightInOffset && lastCellData.index+1 < _numberOfItem)
    {
        CGPoint lastOrigin = lastCellData.cell.frame.origin;
        CGSize  lastSize = lastCellData.cell.frame.size;
        NSInteger index = lastCellData.index + 1;
        CGFloat width = [_dataSource tableView:self widthForItemAtIndex:index];
        WBTableViewCell * cell = [_dataSource tableView:self cellForItemAtIndex:index];
        [self addSubview:cell];
        CGFloat x = lastOrigin.x + lastSize.width;
        cell.frame = CGRectMake(x, 0, width, self.frame.size.height);
        WBCellData * viewData = [[WBCellData alloc] init];
        viewData.cell = cell;
        [viewData setupWithVisibleWidth:self.frame.size.width];
        viewData.index = index;
        [self.visibleCells addObject:viewData];
    }
}
- (void)_handleRightScrolling:(CGPoint)contentOffset
{
    //view will disappear
    WBCellData * lastCellData = [_visibleCells lastObject];
    if (contentOffset.x <= lastCellData.rightOutOffset)
    {
        WBTableViewCell * cell = lastCellData.cell;
        [cell removeFromSuperview];
        [_visibleCells removeObject:lastCellData];
        [self.reusableCells addObject:cell];
    }
    //view will appear
    WBCellData * fistCellData = [_visibleCells firstObject];
    if (contentOffset.x <= fistCellData.leftInOffset && fistCellData.index > 0)
    {
        CGPoint fistOrigin = fistCellData.cell.frame.origin;
        CGSize  fistSize = fistCellData.cell.frame.size;
        NSInteger index = fistCellData.index - 1;
        CGFloat width = [_dataSource tableView:self widthForItemAtIndex:index];
        WBTableViewCell * cell = [_dataSource tableView:self cellForItemAtIndex:index];
        [self addSubview:cell];
        CGFloat x = fistOrigin.x - fistSize.width;
        cell.frame = CGRectMake(x, 0, width, self.frame.size.height);
        WBCellData * newCellData = [[WBCellData alloc] init];
        newCellData.cell = cell;
        [newCellData setupWithVisibleWidth:self.frame.size.width];
        newCellData.index = index;
        [self.visibleCells insertObject:newCellData atIndex:0];
    }
}

- (void)_didSelectItemAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectItemAtIndex:)])
    {
        [self.delegate tableView:self didSelectItemAtIndex:index];
    }
}

- (void)_handleTouchEventAtPoint:(CGPoint)point
{
    [_visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WBCellData * cellData = obj;
        if (CGRectContainsPoint(cellData.cell.frame, point))
        {
            [self _didSelectItemAtIndex:cellData.index];
            *stop = YES;
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)visibleCells
{
    if (_visibleCells == nil)
    {
        _visibleCells = [@[] mutableCopy];
    }
    return _visibleCells;
}
- (NSMutableArray *)reusableCells
{
    if (_reusableCells == nil)
    {
        _reusableCells = [@[] mutableCopy];
    }
    return _reusableCells;
}
@end
