//
//  FunctionsView.m
//  talk
//
//  Created by LiLe on 2017/9/19.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "FunctionsView.h"
#import "imageCell.h"

@interface FunctionsView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation FunctionsView
static NSString *identifier = @"Cell";

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createCollection];
    }
    return self;
}

- (void)createCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(ScreenWidth / 4, ScreenWidth / 4);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[imageCell class] forCellWithReuseIdentifier:identifier];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.button setTitle:@"照片" forState:UIControlStateNormal];
        [cell.button setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
    } else if (indexPath.row == 1) {
        [cell.button setTitle:@"拍摄" forState:UIControlStateNormal];
        [cell.button setImage:[UIImage imageNamed:@"sharemore_video"] forState:UIControlStateNormal];
    } else if (indexPath.row == 2) {
        [cell.button setTitle:@"小视频" forState:UIControlStateNormal];
        [cell.button setImage:[UIImage imageNamed:@"sharemore_sight"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        if (self.chooseImg) {
            self.chooseImg();
        }
    } else if (indexPath.item == 1) {
        
    } else {
        
    }
}

@end
