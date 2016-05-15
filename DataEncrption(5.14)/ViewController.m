//
//  ViewController.m
//  DataEncrption(5.14)
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonCrypto.h> //MD5
//复杂对象
#import "Person.h"
//第三方GTMBase64
#import "GTMBase64.h"
//RSA 公钥加密和解密
#import "RSA.h"
//钥匙串加密--将信息存到本机
#import "KeychainItemWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"awdawdawdawd");
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //MD5加密字符串
    [self md5WithString:@"郑州"];
    //MD5对图片进行加密
    [self imageTransformToData];
    //MDS对数组进行加密
    [self systemArrayToData];
    //base64加密
    [self base64WithStr:@"iOS开发"];
    //GTMDBase64解密
    [self GTMDBase64];
    
    //RSA加密
    [self RSEncoderWithString:@"936840998"];
    
    //钥匙串加密
    [self keyChainEncoderWithUserName:@"zhang" password:@"12345"];
    //钥匙串解密
    [self keyChainDecoder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//1⃣️使用MD5对字符串进行加密
- (void)md5WithString:(NSString *)str {
    //MD5加密方式使用的是C语言函数
    //所以，1.要将OC字符串对象转化成为C语言字符串
    const char *CStr = [str UTF8String];
    //2.创建C数组,用来接收MD5加密后的值
    unsigned char result [CC_MD5_DIGEST_LENGTH];
    //计算MD5的值,进行加密
    //参数1:要加密的字符窜
    //参数2:字符窜长度(转为CC_LONG类型)
    //参数3:存储密文的数组首地址(数组名就是首地址)
    CC_MD5(CStr, (CC_LONG)strlen(CStr), result);
    NSLog(@"%s",result);
    //4.获取摘要
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x", result[i]];
    }
    NSLog(@"%@", resultStr);
}

//2⃣️对图片进行加密
- (void)imageTransformToData {
    //获取图片路径
    NSString *filPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"PNG"];
    //2.根据路将图片转化为data
    NSData *data = [NSData dataWithContentsOfFile:filPath];
    //3.对data进行加密(此方法在线面进行封转)
    [self md5WithData:data];
}

#pragma mark - MD5对data进行加密
- (void)md5WithData:(NSData *)data {
    //创建MD5变量
    CC_MD5_CTX md5;
    //初始化变量
    CC_MD5_Init(&md5);
    //MD5加密
    /*
     参数1:变量的首地址
     参数2:将OC中的data转化为C语言的指针
     参数3:data的长度(CC_LONG)类型
     */
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    //创建字符串数组接收结果
    unsigned char result [CC_MD5_DIGEST_LENGTH];
    //结束加密,存储密文
    CC_MD5_Final(result, &md5);
    //获取结果
    NSMutableString *string = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        [string appendFormat:@"%02x", result[i]];
    }
    NSLog(@"%@", string);
}

//3⃣️对数组转化为data
- (void)systemArrayToData {
    //创建数组(简单对象)
    NSArray *array = @[@"哈哈", @123];
    //转化为data--仅限简单对象,复杂对象需要用编码反编码
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    [self md5WithData:data];
    //
    NSLog(@"%@", data);
}


//4⃣️复杂对象转化为data
- (void)personToData {
    //创建PersonToData
    Person *person = [[Person alloc] init];
    person.name = @"黄";
    person.age = @19;
    person.gender = @"boy";
    //对复杂对象进行归档转化为Data
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:person];
    //调用加密方法
    [self md5WithData:data];
}


#warning MD5属于非对称性加密,不能解密;MD5就是把数据按照一定的编码格式转化为16 个16进制位(每个字节可以存储两个16进制数).所以最终加密的结果是有0-9、A-F组成的32为字符串.
#warning MD5只能对NSString和NSData加密,所以其他想要加密得数可以转化为Data在进行加密.



/*-------------------------------------------------------------------------------------
                                    Base64加密
 -------------------------------------------------------------------------------------*/
//iOS7正式版推出后,苹果增加的Base64编码
//可以加密、解密(对象方法类型的)--NSString&NSData
//调用base64加密方法的对象为data。返回值可以为NSString||NSData


#pragma mark - Base64加密
- (void)base64WithStr:(NSString *)str {
    //1.字符串data
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //2.base64
    //(1)返回值为字符串
    NSString *encondeStr = [strData base64EncodedStringWithOptions:0];
    //(2)返回值为data
//    NSData *encondeData = [strData base64EncodedDataWithOptions:0];
    NSLog(@"%@",encondeStr);
    
    //3.解密
    NSData *deconderData = [[NSData alloc] initWithBase64EncodedString:encondeStr options:0];
    NSString *string = [[NSString alloc] initWithData:deconderData encoding:NSUTF8StringEncoding];
    NSLog(@"解密后：%@", string);
}

/*
 + (NSString*)md5_base64: (NSString *) inPutText;
 + (NSString*)encodeBase64String:(NSString *)input;
 + (NSString*)decodeBase64String:(NSString *)input;
 + (NSString*)encodeBase64Data:(NSData *)data;
 + (NSString*)decodeBase64Data:(NSData *)data;
 */
- (void)GTMDBase64 {
    NSString * string1 = [GTMBase64 md5_base64:@"你好"];
    NSLog(@"1+:%@", string1);
    
    NSString *str2 = [GTMBase64 encodeBase64String:@"再见"];
    NSLog(@"s2+:%@", str2);
    NSString *DeStr2 = [GTMBase64 decodeBase64String:str2];
    NSLog(@"DeS2-:%@",DeStr2);
    
    
    NSString *str = @"gogo";
    //编码
    NSString *str3 = [GTMBase64 encodeBase64Data:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"str3+:%@", str3);
    //解码
    NSData *data = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    //base64解密
    NSString *deconrStr = [GTMBase64 decodeBase64Data:data];
    NSLog(@"DeStr3-:%@",deconrStr);
}

//======================================================================================
//RSA--一般用公钥加密，私钥解密（但是只要钥匙成对存在，也可以用公钥解密，私钥加密）
- (void)RSEncoderWithString:(NSString *)string {
    //公钥证书的描述信息
     NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEChqe80lJLTTkJD3X3Lyd7Fj+\nzuOhDZkjuLNPog3YR20e5JcrdqI9IFzNbACY/GQVhbnbvBqYgyql8DfPCGXpn0+X\nNSxELIUw9Vh32QuhGNr3/TBpechrVeVpFPLwyaYNEk1CawgHCeQqf5uaqiaoBDOT\nqeox88Lc1ld7MsfggQIDAQAB";
    //私钥证书的描述信息
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMQKGp7zSUktNOQk\nPdfcvJ3sWP7O46ENmSO4s0+iDdhHbR7klyt2oj0gXM1sAJj8ZBWFudu8GpiDKqXw\nN88IZemfT5c1LEQshTD1WHfZC6EY2vf9MGl5yGtV5WkU8vDJpg0STUJrCAcJ5Cp/\nm5qqJqgEM5Op6jHzwtzWV3syx+CBAgMBAAECgYEApSzqPzE3d3uqi+tpXB71oY5J\ncfB55PIjLPDrzFX7mlacP6JVKN7dVemVp9OvMTe/UE8LSXRVaFlkLsqXC07FJjhu\nwFXHPdnUf5sanLLdnzt3Mc8vMgUamGJl+er0wdzxM1kPTh0Tmq+DSlu5TlopAHd5\nIqF3DYiORIen3xIwp0ECQQDj6GFaXWzWAu5oUq6j1msTRV3mRZnx8Amxt1ssYM0+\nJLf6QYmpkGFqiQOhHkMgVUwRFqJC8A9EVR1eqabcBXbpAkEA3DQfLVr94vsIWL6+\nVrFcPJW9Xk28CNY6Xnvkin815o2Q0JUHIIIod1eVKCiYDUzZAYAsW0gefJ49sJ4Y\niRJN2QJAKuxeQX2s/NWKfz1rRNIiUnvTBoZ/SvCxcrYcxsvoe9bAi7KCMdxObJkn\nhNXFQLav39wKbV73ESCSqnx7P58L2QJABmhR2+0A5EDvvj1WpokkqPKmfv7+ELfD\nHQq33LvU4q+N3jPn8C85ZDedNHzx57kru1pyb/mKQZANNX10M1DgCQJBAMKn0lEx\nQH2GrkjeWgGVpPZkp0YC+ztNjaUMJmY5g0INUlDgqTWFNftxe8ROvt7JtUvlgtKC\nXdXQrKaEnpebeUQ=";
    //公钥加密
    NSString *encoderStr = [RSA encryptString:string publicKey:publicKey];
    NSLog(@"RSA+:%@",encoderStr);
    //私钥解密
    NSString *decoderStr = [RSA decryptString:encoderStr privateKey:privateKey];
    NSLog(@"RSA-:%@", decoderStr);
}

//======================================================================================
//钥匙串加密
- (void)keyChainEncoderWithUserName:(NSString *)userName password:(NSString *)password {
    //创建钥匙串内容的打包对象--类似字典
    //参数1：唯一标识
    //参数2：群组共享设置
    KeychainItemWrapper *wrapperItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wrapper" accessGroup:nil];
    //加密用户名
    [wrapperItem setObject:userName forKey:(id)kSecAttrAccount];
    //加密密码
    [wrapperItem setObject:password forKey:(id)kSecValueData];
    
}

//钥匙串解密
- (void)keyChainDecoder {
    KeychainItemWrapper *wrapperItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wrapper" accessGroup:nil];
    //用户名
    NSString *userName = [wrapperItem objectForKey:(id)kSecAttrAccount];
    //密码
    NSString *password = [wrapperItem objectForKey:(id)kSecValueData];
    NSLog(@"用户名:%@ 密码:%@", userName, password);
}

//钥匙串属于对称加密，主要用于账号密码加密（不做传输）。
//RSA（公钥、私钥）主要是用户（我们）和后台都需要查看数据时使用，一般在传输过程需要保证信息安全的时候使用。
//MD5（没有解密。非对称性）和base64（加，解）可用于向后台传输账号密码信息


@end
