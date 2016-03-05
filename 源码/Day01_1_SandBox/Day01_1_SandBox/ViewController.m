//
//  ViewController.m
//  Day01_1_SandBox
//
//  Created by tarena on 16/2/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSString *documentsPath;
@end

@implementation ViewController
-(NSString *)documentsPath
{
    if (!_documentsPath) {
        _documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return _documentsPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //因为pdf文件存在于app工程文件中，所以路径只能用bundle获取
    NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"source" ofType:@"pdf"];
    NSString *targetPath = [self.documentsPath stringByAppendingString:@"target"];
    BOOL success = [[NSFileManager defaultManager]createFileAtPath:targetPath contents:nil attributes:nil];
    //读源文件控制器
    NSFileHandle *sourceReadHandle = [NSFileHandle fileHandleForReadingAtPath:sourcePath];
    //写目标文件控制器
    NSFileHandle *targetWriteHandle = [NSFileHandle fileHandleForWritingAtPath:targetPath];
    //通过while循环，每写入一部分数据，知道全部写入完成
    //标识：是否读取完毕
    BOOL notEnd = YES;
    //存储当前已读取的数量
    NSInteger readSize = 0;
    //每次读入的字节大小
    NSInteger sizePerTime = 5000;
    //获取文件总长度--通过文件属性可以获得
    NSDictionary *attr = [[NSFileManager defaultManager]attributesOfItemAtPath:sourcePath error:nil];
    //获取文件的总长度
    NSNumber *fileSize = [attr objectForKey:NSFileSize];
    NSInteger fileTotalNum = fileSize.longValue;
    //记录循环的次数，意味着读取源文件多少次
    int count = 0;
    while (notEnd) {
        //计算还剩下多少没有读完
        NSInteger leftSize = fileTotalNum - readSize;
        NSData *data = nil;
        //如果剩下的超过5000则读5000，如果少于5000则读到结尾
        if (leftSize >= sizePerTime) {
            data = [sourceReadHandle readDataOfLength:sizePerTime];
            //修改已读数量
            readSize += sizePerTime;
            //移动读取源文件的指针到新位置
            [sourceReadHandle seekToFileOffset:readSize];
        }else{
            //设置已读完
            notEnd = NO;
            //读剩余数据
            data = [sourceReadHandle readDataOfLength:leftSize];}
            //每次循环都把源文件的data写入到目标文件
            [targetWriteHandle writeData:data];
            count++;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
