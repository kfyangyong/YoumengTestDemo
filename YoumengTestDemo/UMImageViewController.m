//
//  UMImageViewController.m
//  YoumengTestDemo
//
//  Created by ayong on 2017/1/12.
//  Copyright © 2017年 ayong. All rights reserved.
//

#import "UMImageViewController.h"
#import "UMImageCollectionViewCell.h"
//相册调用
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//友盟分享
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

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
/** 分享 */
- (IBAction)shareBtnClick:(UIButton *)sender {
    if (self.dataArr.count == 0) {
        return;
    }
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
     /* UMSocialPlatformType_Sina               = 0, //新浪
        UMSocialPlatformType_WechatSession      = 1, //微信聊天
        UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
        UMSocialPlatformType_WechatFavorite     = 3,//微信收藏
        UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
        UMSocialPlatformType_Qzone    */
        [self getUserInfoForPlatform:platformType];
        [self shareImageToPlatformType:platformType];

    }];
}
//获取用户授权
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];

}
//分享文本内容
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.shareObject = self.dataArr;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
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
    return self.dataArr.count + 1;
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
    return CGSizeMake(kUIScreenW/3 - 10,85);
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

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
        [self.dataArr insertObject:image atIndex:0];
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
