//
//  ETLMKSocketManager.m
//  Ethome
//
//  Created by ethome on 2017/6/22.
//  Copyright © 2017年 Whalefin. All rights reserved.
//

#import "ETLMKSocketManager.h"
#import "AsyncSocket.h"

/// 心跳间隔
const NSInteger bitInterval = 10;

@interface ETLMKSocketManager()<AsyncSocketDelegate>
@property (nonatomic,strong)AsyncSocket *receiveSocket;
@property (nonatomic,strong)AsyncSocket *serverSocket;

@property (nonatomic,copy)connectedToHostBlock connectedBlock;
@property (nonatomic,copy)didDisconnectedBlock disConnectedBlock;

@property (nonatomic,copy)newConnectedBlock newConnectedBlock;
@property (nonatomic,copy)sendCompletedBlock completedSendBlock;
@property (nonatomic,copy)readDataBlock readBlock;
@property (nonatomic, strong) NSTimer *timer;


@end


@implementation ETLMKSocketManager

+ (ETLMKSocketManager *)shareInstance{
    
    static ETLMKSocketManager *tcpSocket =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tcpSocket = [[ETLMKSocketManager alloc] init];
    });
    return tcpSocket;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isReConnect = YES;
    }
    return self;
}
- (AsyncSocket *)receiveSocket{
    if (!_receiveSocket){
        _receiveSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [_receiveSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return _receiveSocket;
}

- (AsyncSocket *)serverSocket{
    if (!_serverSocket) {
        _serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [_serverSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return _serverSocket;
}


- (void)connectSocket{
        
    if ([GlobalKit shareKit].token) {
        if(![self.serverSocket isDisconnected])
        {
            [self.serverSocket disconnect];
        }
        [self connectToHost:HOST port:PORT connected:^(NSString *hostIP, NSInteger port) {
            
            NSLog(@"hostIP:%@,port:%ld",hostIP,(long)port);
            
        } didDisconnected:^{
            
        }];
    }
    
}

- (void)disconnectSocket{
    
    [self disconnected];
    
}

- (void)keepHeartBit{
    _heartbitCount =bitInterval; //倒计时时间
    __weak typeof(self) weakSelf = self;
    if (self.sourceTimer ==nil) {
        dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
        self.sourceTimer = timer;
        dispatch_source_set_timer(timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(weakSelf.heartbitCount <= 0){ //倒计时结束，关闭
                //dispatch_source_cancel(timer);
                weakSelf.heartbitCount = bitInterval;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"send heart bit");
                    
                    NSString *bitStr = @"{\"type\":1}";
                    
                    [weakSelf sendData:bitStr tag:100 finishWritedBlock:^(NSInteger tag,NSString *error) {
                        NSLog(@"send end");
                        if (error) {
                            NSLog(@"heart bit error:%@",error);
                        }
                    }];
                    
                });
                
                
            }else{
                weakSelf.heartbitCount -= 1;
                NSLog(@"-");
            }
        });
        dispatch_resume(timer);
    }
}
#pragma mark - public method
- (void)connectToHost:(NSString *)hostIP port:(NSInteger)port connected:(connectedToHostBlock)block didDisconnected:(didDisconnectedBlock)disBlock;{
    
    _isReConnect = NO;
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
    
    if(![self.serverSocket isDisconnected])
    {
        [self.serverSocket disconnect];
    }
    
    if (self.connectState !=LMKConnectStateConnecting && ![self.serverSocket isConnected]) {
        
        _isReConnect = YES;
        self.ip = hostIP;
        NSError *error;
        self.connectedBlock = block;
        self.disConnectedBlock = disBlock;
        NSLog(@"try to connect to ip:%@",hostIP);
        [self.serverSocket connectToHost:hostIP onPort:port withTimeout:-1 error:&error];
        
        _connectState =LMKConnectStateConnecting;
    }
}

- (void)sendData:(NSString *)dataStr tag:(NSInteger)tag finishWritedBlock:(sendCompletedBlock)block{
    self.completedSendBlock = block;
    if (self.connectState ==LMKConnectStateConnected) {
        
        NSString *strSend = [NSString stringWithFormat:@"%@\r\n",dataStr];
        NSData *data = [strSend dataUsingEncoding:NSUTF8StringEncoding];
        [self.serverSocket writeData:data withTimeout:-1 tag:tag];
    }else{
        if (self.completedSendBlock) {
            self.completedSendBlock(tag,NSLocalizedString(@"Disconnect",nil));
        }
    }
}

- (void)readData:(readDataBlock)block{
    [self.serverSocket readDataWithTimeout:-1 tag:self.readTag];
    self.readBlock = block;
}

- (void)readData:(readDataBlock)block timeout:(NSInteger)timeout{
    [self.serverSocket readDataWithTimeout:timeout tag:self.readTag];
    self.readBlock = block;
}

- (void)disconnected{
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
        self.sourceTimer =nil;
    }
    self.isReConnect = NO;
    
    _connectState =LMKConnectStateDisConnected;
    
    [self.serverSocket disconnect];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"disconnect:%@",err);
}

- (void)acceptPort:(NSInteger)port newConnect:(newConnectedBlock)nBlock readTag:(NSUInteger)tag didReadData:(readDataBlock)rBlock{
    NSError *error;
    [self.receiveSocket disconnect];
    [self.receiveSocket acceptOnPort:port error:&error];
    self.newConnectedBlock = nBlock;
    self.readBlock = rBlock;
    self.readTag = tag;
}

#pragma mark - AsyncSocket delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
    
    _connectState =LMKConnectStateConnected;
    NSLog(@"==connected==%@",host);
    
    /*
     
     {"client":{"appId":"xxx","cid":"44-45-53-54-00-00","pwd":"abc129decac120edf","uid":"1001"},"type":2}
     
     */
    
    if (![GlobalKit shareKit].pwd || ![GlobalKit shareKit].userId) {
        
        [[GlobalKit shareKit] clearSession];
        
        [ETLMKSOCKETMANAGER disconnectSocket];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
        controller.modalPresentationStyle = 0;
        [[UKHelper getCurrentVC] presentViewController:controller animated:YES completion:nil];

    }else{
        
        NSDictionary *loginDic = @{@"client":@{@"appId":@"com.xiaowen.ethome",@"cid":[ETGetUUID getDeviceId],@"pwd":[GlobalKit shareKit].pwd,@"uid":[GlobalKit shareKit].userId},@"type":@3};
        
        NSString *loginStr = loginDic.mj_JSONString;
        
        [self sendData:loginStr tag:200 finishWritedBlock:^(NSInteger tag,NSString *error) {
            NSLog(@"login send end");
            if (error) {
                NSLog(@"login error:%@",error);
            }
        }];
        
        [self.serverSocket readDataWithTimeout:-1 tag:self.readTag];
        
        [self keepHeartBit];
        if (self.connectedBlock) {
            self.connectedBlock(host,port);
        }
        
    }
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"==disconnected==");
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
        self.sourceTimer =nil;
    }
    
    _connectState =LMKConnectStateDisConnected;
    if (self.disConnectedBlock) {
        self.disConnectedBlock();
    }
    
    if (_isReConnect) {
        
        if (_timer == nil) {
            
            _timer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
            
        }
        
    }
}

- (void)function:(NSTimer *)timer{
    
    if (!self.serverSocket.isConnected) {
        NSError *error;
        
        if(![self.serverSocket isDisconnected])
        {
            [self.serverSocket disconnect];
        }
        
        [self.serverSocket connectToHost:HOST onPort:PORT withTimeout:-1 error:&error];
        _connectState =LMKConnectStateConnecting;
    }
    
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    if (self.completedSendBlock) {
        self.completedSendBlock(tag,nil);
    }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    if (self.serverSocket != newSocket) {
        self.serverSocket = newSocket;
        [self.serverSocket readDataWithTimeout:-1 tag:self.readTag];
        if (self.newConnectedBlock) {
            self.newConnectedBlock();
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *st = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"recv:%@",st);
    
    [self.serverSocket readDataWithTimeout:-1 tag:self.readTag];
    
    /*
     
     {"device":{"deviceId":"020010fff01","status":"on"},"type":5}\r\n
     
     */
    
    NSMutableArray *resultArray = [st componentsSeparatedByString:@"\r\n"].mutableCopy;
    
    [resultArray removeLastObject];
    
    for (NSString *dicStr in resultArray) {
        
        NSDictionary *dic = dicStr.mj_JSONObject;
        
        NSInteger type = [dic[@"type"] integerValue];
        
        switch (type) {
            case 1:{
                
                
            }
                break;
            case 2:{
                
                
            }
                break;
            case 3:{
                
                
            }
                break;
            case 4:{
                
                NSInteger result = [dic[@"result"] integerValue];
                
                if (result != SUCCESS) {
                    NSLog(@"登录失败");
                }else{
                    _isReConnect = YES;
                }
            }
                break;
            case 5:{
                
                NSDictionary *deviceDic = dic[@"device"];
                                
                [[NSNotificationCenter defaultCenter] postNotificationName:ETUPDATEDEVIECENOT object:nil userInfo:@{@"result":deviceDic}];
            }
                break;
                
            default:
                break;
        }

    }
    
    if (self.readBlock) {
        self.readBlock(data,tag);
    }
}

@end
