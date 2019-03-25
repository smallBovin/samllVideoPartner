//
//  MBWordEditViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBWordEditViewController.h"
/** 底部字体颜色选择*/
#import "MBWordEditBottomBar.h"
/** 字体颜色选择器*/
#import "MBFontColorChooseView.h"

#import "MBWordEditTextCell.h"

#import "MBWordFontColorModel.h"

@interface MBWordEditViewController ()<UITableViewDelegate,UITableViewDataSource,MBWordEditDelegate,MBWordEditBottomBarDelegate,MBFontColorChooseDelegate>

/** 底部选择字体颜色*/
@property (nonatomic, strong)MBWordEditBottomBar *bottomView;
/** 字体选择*/
@property (nonatomic, strong)MBFontColorChooseView *fontChooseView;
/** 颜色选择*/
@property (nonatomic, strong)MBFontColorChooseView *colorChooseView;
/**  文字列表 */
@property (nonatomic , strong)UITableView *textTableView;

/** ======记录按钮点击的状态===*/
/** 字体按钮*/
@property (nonatomic, strong) UIButton * fontButton;
/** 颜色按钮*/
@property (nonatomic, strong) UIButton * colorButton;
/**   */
@property (nonatomic , strong)NSArray *fontArry;
/**   */
@property (nonatomic , strong)NSArray *colorArry;

/** 是否是删除*/
@property (nonatomic, assign) BOOL  isDelete;

/** 最大行数*/
@property (nonatomic, assign) NSInteger  maxLine;

@end

@implementation MBWordEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文字编辑";
    [self setupSubviews];
    [self requestColorData];
    [self requestFontData];
//    self.bottomView.colorName = self.selectColor;
    [self.textTableView reloadData];
    self.maxLine = self.aeView.imageInfoArray.count;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}

- (void)setFontTitle:(NSString *)fontTitle {
    _fontTitle = fontTitle;
    self.fontChooseView.fontTitle = fontTitle;
}

-(void)requestColorData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    [RequestUtil POST:EDITTING_COLOR_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.colorArry = [MBWordFontColorModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"]];
        }else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   
    }];
    
}

-(void)requestFontData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"type"] = @"3";
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tempArry = [MBWordFontColorModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            for (NSInteger i=0; i<tempArry.count; i++) {
                MBWordFontColorModel *model = tempArry[i];
                if ([model.title isEqualToString:self.fontTitle]) {
                    model.isSelect = YES;
                }else{
                    model.isSelect = NO;
                }
                NSString *fileName = [model.path lastPathComponent];
                NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
                if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                    model.isDownload = YES;
                }else {
                    model.isDownload = NO;
                }
                [tempArry replaceObjectAtIndex:i withObject:model];
            }
            self.fontArry = tempArry;
        }else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



#pragma mark--保存编辑完成的文字--
- (void)saveEditedVideoWords {
    [self.view endEditing:YES];
    NSArray *imageLayerArry = self.aeView.imageLayerArray;
    
    for (int i=0; i<self.dataArry.count; i++) {
        LSOOneLineText *lineText = self.dataArry[i];
        [lineText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (lineText.text.length == 0 || [lineText.text isEqualToString:@""]) {
            [self.dataArry removeObject:lineText];
            if (i>0) {
                i--;
            }
        }
    }
    
    for (int i=0; i<self.dataArry.count; i++) {
        LSOOneLineText *lineText = self.dataArry[i];
        LSOAeImageLayer *imageLayer = imageLayerArry[i];
        lineText.jsonImageWidth = imageLayer.imgWidth;
        lineText.jsonImageHeight = imageLayer.imgHeight;
        lineText.startFrame = imageLayer.startFrame;
        lineText.endFrame = imageLayer.endFrame;
        NSDictionary *dic = self.titleArry[i];
        if ([dic[@"title"] length]==0) {
            CGFloat fontSize = [self getFontSizeWithText:lineText.text height:lineText.jsonImageHeight];
            lineText.fontSize = fontSize;
        }else if (lineText.text.length>[dic[@"title"] length]) {
            if (lineText.text.length>=6) {
                CGFloat fontSize = [self getFontSizeWithText:lineText.text width:lineText.jsonImageWidth];
                lineText.fontSize = fontSize;
            }else {
                CGFloat fontSize = [self getFontSizeWithText:lineText.text height:lineText.jsonImageHeight];
                lineText.fontSize = fontSize;
            }
        }else{
            lineText.fontSize = [dic[@"fontSize"] floatValue];
        }
        lineText.lineIndex = i+1;
        lineText.jsonImageID = [NSString stringWithFormat:@"image_%ld",self.maxLine-1-i];
        
        
        lineText.textImage = [self createImageWithText:lineText.text fontName:self.fontName imageSize:CGSizeMake(lineText.jsonImageWidth, lineText.jsonImageHeight) txtColor:lineText.textColor fontSize:lineText.fontSize];
        [self.dataArry replaceObjectAtIndex:i withObject:lineText];
    }
    if (self.MBWordEditingCompletion) {
        self.MBWordEditingCompletion(self.dataArry,self.fontName,self.fontTitle,self.titleArry);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImage *)createImageWithText:(NSString *)text fontName:(NSString *)fontName imageSize:(CGSize)size txtColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    //文字转图片;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode=NSLineBreakByTruncatingTail;
    
    //获取高度.
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:fontName size:fontSize],NSFontAttributeName, textColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,style,NSParagraphStyleAttributeName, nil];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
/** 计算字体的大小*/
-(CGFloat)getFontSizeWithText:(NSString *)text width:(CGFloat)width{
    //测试的结果发现,几乎高度是多少, 字号略小于他一点. 比如高度是350.则字号是293; 用PS也发现几乎是这样.
    CGFloat fontSize=25;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    CGSize size;
    while(YES){
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                     NSForegroundColorAttributeName : [UIColor redColor],
                                     NSBackgroundColorAttributeName : [UIColor clearColor],
                                     NSParagraphStyleAttributeName : style, };
        
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:attributes];
        size =  [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if(size.width<=width){
            fontSize+=0.5f;
        }else{
            break;
        }
    }
    return fontSize -0.5f ;
}

-(CGFloat)getFontSizeWithText:(NSString *)text height:(CGFloat)height{
    //测试的结果发现,几乎高度是多少, 字号略小于他一点. 比如高度是350.则字号是293; 用PS也发现几乎是这样.
    CGFloat fontSize=25;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    CGSize size;
    while(YES){
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                     NSForegroundColorAttributeName : [UIColor redColor],
                                     NSBackgroundColorAttributeName : [UIColor clearColor],
                                     NSParagraphStyleAttributeName : style, };
        
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"你" attributes:attributes];
        size =  [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if(size.height<=height){
            fontSize+=0.5f;
        }else{
            break;
        }
    }
    return fontSize -0.5f ;
}


#pragma mark--底部颜色字体选择--MBWordEditBottomBarDelegate--
- (void)chooseFontAction:(UIButton *)fontBtn {
    if (self.fontArry.count == 0) {
        [self requestFontData];
        return;
    }
    self.fontButton = fontBtn;
    self.fontChooseView.dataArray = [NSMutableArray arrayWithArray:self.fontArry];
    self.colorButton.userInteractionEnabled = NO;
    if (!self.fontButton.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.fontChooseView.frame = CGRectMake(SCREEN_WIDTH-kAdapt(106), NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(106), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
            if (self.colorButton.selected) {
                self.colorChooseView.frame = CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(53), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
                self.colorButton.selected = NO;
            }
        } completion:^(BOOL finished) {
            self.fontButton.selected = YES;
            self.colorButton.userInteractionEnabled = YES;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.fontChooseView.frame = CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(106), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
        } completion:^(BOOL finished) {
            self.fontButton.selected = NO;
            self.colorButton.userInteractionEnabled = YES;
        }];
    }
}

- (void)chooseColorAction:(UIButton *)colorBtn {
    if (self.colorArry.count == 0) {
        [self requestColorData];
        return;
    }
    self.colorButton = colorBtn;
    self.colorChooseView.dataArray = [NSMutableArray arrayWithArray:self.colorArry];
    self.fontButton.userInteractionEnabled = NO;
    if (!self.colorButton.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.colorChooseView.frame = CGRectMake(SCREEN_WIDTH-kAdapt(53), NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(53), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
            if (self.fontButton.selected) {
                self.fontChooseView.frame = CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(106), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
                self.fontButton.selected = NO;
            }
        } completion:^(BOOL finished) {
            self.colorButton.selected = YES;
            self.fontButton.userInteractionEnabled = YES;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.colorChooseView.frame = CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(53), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90));
        } completion:^(BOOL finished) {
            self.colorButton.selected = NO;
            self.fontButton.userInteractionEnabled = YES;
        }];
    }
}


-(void)changeWordSelect:(BOOL)select index:(NSInteger)index{
    LSOOneLineText *model = self.dataArry[index];
    model.isSelected = select;
    [self.dataArry replaceObjectAtIndex:index withObject:model];
    [self.textTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}



-(void)changeWordFinish:(NSString *)content index:(NSInteger)index{
    if (index<self.dataArry.count) {
        if (!self.isDelete) {
            LSOOneLineText *model = self.dataArry[index];
            model.text = content;
        }
//        [self.textTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)changeLineWithIndex:(NSInteger)index{
    if (index<self.dataArry.count-1) {
        MBWordEditTextCell *cell = [self.textTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
        [cell.contentTF becomeFirstResponder];
    }
}

-(void)addLineWithIndex:(NSInteger)index location:(NSInteger)location{
    if (self.dataArry.count>=self.maxLine) {
        [MBProgressHUD showOnlyTextMessage:@"行数已达最大限制"];
        return;
    }
    self.isDelete = NO;
    LSOOneLineText *lastModel = self.dataArry[index];
    NSString *nextString = @"";
    if (location<lastModel.text.length) {
        //文字截断
        nextString = [lastModel.text substringFromIndex:location];
        lastModel.text = [lastModel.text substringToIndex:location];
        [self.dataArry replaceObjectAtIndex:index withObject:lastModel];
        MBWordEditTextCell *cell = [self.textTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.contentTF.text = lastModel.text;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"textColor" forKey:@"ffffff"];
//    [dic setObject:@(lastModel.startFrame) forKey:@"startFrame"];
//    [dic setObject:@(lastModel.endFrame) forKey:@"endFrame"];
    if (index == self.dataArry.count-1) {
        //最后一行后面
        [dic setObject:@(lastModel.startTimeS+0.1) forKey:@"startTimeS"];
        [dic setObject:@(lastModel.endTimeS) forKey:@"endTimeS"];
//        lastModel.startTimeS -= 0.01;
        lastModel.endTimeS = 0;
        [self.dataArry replaceObjectAtIndex:index withObject:lastModel];
    }else{
        //中间插入
        [dic setObject:@(lastModel.startTimeS+0.1) forKey:@"startTimeS"];
        [dic setObject:@(0) forKey:@"endTimeS"];
    }
    LSOOneLineText *model = [LSOOneLineText mj_objectWithKeyValues:dic];
    model.text = nextString;
    [self.dataArry insertObject:model atIndex:index+1];
    [self.titleArry insertObject:@{@"fontSize":@"56.5",@"title":@""} atIndex:index+1];
    
//    [self.textTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.textTableView reloadData];
   
    MBWordEditTextCell *cell = [self.textTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
    [cell.contentTF becomeFirstResponder];
    cell.model = model;
    cell.fontName = self.fontName;
    cell.index = index+1;
    cell.delegate = self;
}

-(void)deleteLineWithIndex:(NSInteger)index{
    if (index>0 && index<self.dataArry.count) {
        self.isDelete = YES;
        [self.dataArry removeObjectAtIndex:index];
        [self.titleArry removeObjectAtIndex:index];
        [self.textTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        MBWordEditTextCell *cell = [self.textTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0]];
        [cell.contentTF becomeFirstResponder];
    }
}

-(void)selectWordFontColor:(MBWordEditType)editType model:(MBWordFontColorModel *)model{
    if (editType == MBWordEditTypeFont) {
        //字体
        self.fontName = model.fontName;
        self.fontTitle = model.title;
        [self.textTableView reloadData];
    }else{
        //颜色
        self.bottomView.colorName = model.color;
        for (NSInteger i=0; i<self.dataArry.count; i++) {
            LSOOneLineText *textModel = self.dataArry[i];
            if (textModel.isSelected == YES) {
                textModel.textColor = [UIColor colorWithHexString:model.color];
                [self.dataArry replaceObjectAtIndex:i withObject:textModel];
            }
        }
    }
    [self.textTableView reloadData];
}

#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBWordEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBWordEditTextCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fontName = self.fontName;
    cell.model = self.dataArry[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark--lazy--创建控件
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232323"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(saveEditedVideoWords)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [self.view addSubview:self.textTableView];
    [self.view addSubview:self.bottomView];
    /** 字体选择*/
    [self.view addSubview:self.fontChooseView];
    /** 颜色选择*/
    [self.view addSubview:self.colorChooseView];
}
/** tableView*/
-(UITableView *)textTableView{
    if(!_textTableView){
        _textTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(70)) style:UITableViewStylePlain];
        _textTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _textTableView.backgroundColor = [UIColor clearColor];
        _textTableView.rowHeight = kAdapt(50);
        _textTableView.dataSource = self;
        _textTableView.delegate = self;
        [_textTableView registerClass:[MBWordEditTextCell class] forCellReuseIdentifier:@"MBWordEditTextCell"];
    }
    return _textTableView;
}
/** 字体颜色选择*/
- (MBWordEditBottomBar *)bottomView{
    if (!_bottomView) {
        _bottomView = [[MBWordEditBottomBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(70), SCREEN_WIDTH, kAdapt(kAdapt(70))+SAFE_INDICATOR_BAR)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
/** 字体选择*/
- (MBFontColorChooseView *)fontChooseView {
    if (!_fontChooseView) {
        _fontChooseView = [[MBFontColorChooseView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(106), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90))];
        _fontChooseView.itemSize = CGSizeMake(kAdapt(99), kAdapt(24));
        _fontChooseView.edgeInset = UIEdgeInsetsMake(kAdapt(9), kAdapt(4), kAdapt(9), kAdapt(4));
        _fontChooseView.spaceMargin = kAdapt(6);
        _fontChooseView.editType = MBWordEditTypeFont;
        _fontChooseView.delegate = self;
        _fontChooseView.superVC = self;
    }
    return _fontChooseView;
}
/** 颜色选择*/
- (MBFontColorChooseView *)colorChooseView {
    if (!_colorChooseView) {
        _colorChooseView = [[MBFontColorChooseView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(53), SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(90))];
        _colorChooseView.itemSize = CGSizeMake(kAdapt(28), kAdapt(28));
        _colorChooseView.edgeInset = UIEdgeInsetsMake(kAdapt(9), kAdapt(12), kAdapt(9), kAdapt(12));
        _colorChooseView.spaceMargin = kAdapt(7);
        _colorChooseView.editType = MBWordEditTypeColor;
        _colorChooseView.delegate = self;
        _colorChooseView.superVC = self;
    }
    return _colorChooseView;
}

-(NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

@end
