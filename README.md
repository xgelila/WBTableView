# WBTableView  
A tableview has only one row and Multi-column  allows horizontal scrolling  
#usage  
1、import head file  
```
#import "WBTableView.h"
```
2、create instance of  WBTableView    
```
@implementation ViewController
{
    WBTableView * _tableView;
}
...
...
_tableView = [[WBTableView alloc] init];
_tableView.delegate = self;
_tableView.dataSource = self;
```
3、WBTableViewDataSource  
the number of columns
```
- (NSInteger)numberOfItemsInTableView:(WBTableView *)tableView;
```
the width of columns  
```
- (CGFloat)tableView:(WBTableView *)tableView widthForItemAtIndex:(NSInteger)index;
```
the content of column  
```
- (WBTableViewCell *)tableView:(WBTableView *)tableView cellForItemAtIndex:(NSInteger)index
```
4、WBTableViewDelegate  
response of selecting a column  
```
- (void)tableView:(WBTableView *)tableView didSelectItemAtIndex:(NSInteger)index;
```
