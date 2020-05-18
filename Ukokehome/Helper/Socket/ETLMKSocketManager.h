//
//  ETLMKSocketManager.h
//  Ethome
//
//  Created by ethome on 2017/6/22.
//  Copyright © 2017年 Whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  Point to Point connected
 *
 */
#define ETLMKSOCKETMANAGER [ETLMKSocketManager shareInstance]

#define ETUPDATEDEVIECENOT @"ETUPDATEDEVIECENOT"

typedef void(^connectedToHostBlock) (NSString *hostIP,NSInteger port);
typedef void(^sendCompletedBlock)(NSInteger tag,NSString *error);
typedef void(^didDisconnectedBlock)();

typedef void(^newConnectedBlock)();
typedef void(^readDataBlock)(NSData *data,NSInteger tag);

typedef NS_ENUM(NSInteger, LMKConnectState) {
    LMKConnectStateDisConnected = 0,
    LMKConnectStateConnected,
    LMKConnectStateConnecting
};
/*
 *  一对一读写socket
 */
@interface ETLMKSocketManager : NSObject


@property (nonatomic,readonly)LMKConnectState connectState;
@property (nonatomic,assign)BOOL isReConnect;//是否重新连接
@property (nonatomic,strong)NSString *ip;//remote ip
/// tag 读取tag
@property (nonatomic,assign)NSInteger readTag;
/// 心跳count
@property (nonatomic,assign)NSInteger heartbitCount;
/// gcd
@property (nonatomic,strong)dispatch_source_t sourceTimer;
/// 当前剩余尝试连接次数，设置0以下可以不尝试重连
@property (nonatomic,assign)NSInteger tryTimeCurrent;

/// 单例
+ (ETLMKSocketManager *)shareInstance;

- (void)connectSocket;

- (void)disconnectSocket;

/// 发送部分
/// 链接到指定ip和port的设备，链接成功调用block
- (void)connectToHost:(NSString *)hostIP port:(NSInteger)port connected:(connectedToHostBlock)block didDisconnected:(didDisconnectedBlock)disBlock;
/// 连接成功后发送数据，发送完毕调用block
- (void)sendData:(NSString *)dataStr tag:(NSInteger)tag finishWritedBlock:(sendCompletedBlock)block;
- (void)disconnected;

/// 读取数据，默认无超时
- (void)readData:(readDataBlock)block;
/// 读取数据
- (void)readData:(readDataBlock)block timeout:(NSInteger)timeout;
/// 接收部分
- (void)acceptPort:(NSInteger)port newConnect:(newConnectedBlock)nBlock readTag:(NSUInteger)tag didReadData:(readDataBlock)rBlock;

@end
