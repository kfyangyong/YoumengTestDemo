//
//  UMImageViewController.m
//  YoumengTestDemo
//
//  Created by ayong on 2017/1/12.
//  Copyright © 2017年 ayong. All rights reserved.
//

#import "UMImageViewController.h"
#import "UMImageCollectionViewCell.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kUIScreenW [UIScreen mainScreen].bounds.size.width
#define kUIScreenH [UIScreen mainScreen].bounds.size.height
@interface UMImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation UMImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UMImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemEditCell:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

#pragma action
- (IBAction)shareBtnClick:(UIButton *)sender {
    
}

- (void)rightItemEditCell:(UIBarButtonItem *)sender{
    NSLog(@"编辑Cell");
}

- (void)addBtnClick:(UIButton *)sender{
    //进入相册
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.allowsEditing = YES;

    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 20;
    return self.dataArr.count == 0 ? 1 :self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        UMImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == self.dataArr.count) {
        [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.addBtn removeFromSuperview];
        cell.imageView.image = self.dataArr[indexPath.row];
    }
        return cell;
}

#pragma mark -UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kUIScreenW/3 - 10,kUIScreenW/2);
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - 相册
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    NSLog(@"选择完毕，image：%@, info：%@",image,editingInfo);
}
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [self.dataArr insertObject:imageView atIndex:0];
//        //压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(imageView.image, 1.0);
//        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        //上传图片
//        [self uploadImageWithData:fileData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
