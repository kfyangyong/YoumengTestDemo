//
//  ViewController.m
//  YoumengTestDemo
//
//  Created by ayong on 2017/1/11.
//  Copyright © 2017年 ayong. All rights reserved.
//

#import "ViewController.h"
#import "UMTextshareViewController.h"
#import "UMImageViewController.h"
#import "UMFileShareViewController.h"

typedef enum : NSUInteger {
    imageShare,
    textShare,
    fileShare,
} shareType;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ViewController

static NSString *identifier = @"cell";

- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"图片分享",@"文字分享",@"文件分享"];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UMImageViewController *imageVC = [[UMImageViewController alloc] init];
        [self.navigationController pushViewController:imageVC animated:YES];
    }
    if (indexPath.row == 1) {
        UMTextshareViewController *textVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UMTextshareViewController"];
        [self.navigationController pushViewController:textVC animated:YES];
    }

    if (indexPath.row == 2) {
        UMFileShareViewController *fileVC = [[ UMFileShareViewController alloc] init];
        [self.navigationController pushViewController:fileVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
