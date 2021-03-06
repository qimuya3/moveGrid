//
//  CustomGrid.m
//  MoveGrid
//
//  Created by Jerry.li on 14-11-6.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import "CustomGrid.h"

@implementation CustomGrid

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//创建格子
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        //计算每个格子的X坐标
        CGFloat pointX = (index % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;;
        //计算每个格子的Y坐标
        CGFloat pointY = (index / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        
        [self setFrame:CGRectMake(pointX, pointY, GridWidth, GridHeight)];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //////////
        [self setGridId:gridId];
        [self setGridIndex:index];
        [self setGridCenterPoint:self.center];
        [self setTag:999];
        //判断是否要添加删除图标
        if (isAddDelete) {
            //当长按时添加删除按钮图标
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(55, 10, 16, 16)];
            [deleteBtn setBackgroundColor:[UIColor clearColor]];
            [deleteBtn setBackgroundImage:deleteIcon forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setHidden:YES];
            
            /////////////
            [deleteBtn setTag:gridId+99999];
            [self addSubview:deleteBtn];
            
            //添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
             longPressGesture = nil;
        }
    }
    return self;
}


//响应格子点击事件
- (void)gridClick:(CustomGrid *)clickItem
{
    [self.delegate gridItemDidClicked:clickItem];
}

//响应格子删除事件
- (void)deleteGrid:(UIButton *)deleteButton
{
    [self.delegate gridItemDidDeleteClicked:deleteButton];
}

//响应格子的长安手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate pressGestureStateEnded:self];
            break;
        }
        default:
            break;
    }
}

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0;i< gridListArray.count;i++)
    {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn)
        {
            if (CGRectContainsPoint(appButton.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

@end
