//
//  UMImageCollectionViewCell.m
//  YoumengTestDemo
//
//  Created by ayong on 2017/1/12.
//  Copyright © 2017年 ayong. All rights reserved.
//

#import "UMImageCollectionViewCell.h"

@implementation UMImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageView:(UIImageView *)imageView{
    _imageView = imageView;
//    _imageView.contentMode = UIViewContentModeScaleToFill;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
