#import "wsclient.h"


@implementation EwordWebService_UserAuth

@synthesize userName;
@synthesize userPass;
@synthesize appId;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setUserName: nil];
    [self setUserPass: nil];
    [self setAppId: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:UserAuth"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(userName!=nil)
        if(userName!=nil){
            [NSWSDL addChild:e withName:@"UserName" withValue: userName asAttribute:NO];
        }
    if(userPass!=nil)
        if(userPass!=nil){
            [NSWSDL addChild:e withName:@"UserPass" withValue: userPass asAttribute:NO];
        }
    if(appId!=nil)
        if(appId!=nil){
            [NSWSDL addChild:e withName:@"AppId" withValue: appId asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setUserName: [NSWSDL getString:root:@"UserName":NO]];
    [self setUserPass: [NSWSDL getString:root:@"UserPass":NO]];
    [self setAppId: [NSWSDL getString:root:@"AppId":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_UserAuth* obj = [[EwordWebService_UserAuth alloc] init];
#else
    EwordWebService_UserAuth* obj = [[[EwordWebService_UserAuth alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService_UserAuthResponse

@synthesize authToken;
@synthesize uploadPath;
@synthesize ftpHost;
@synthesize ftpPort;
@synthesize ftpUser;
@synthesize ftpPass;
@synthesize message;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setAuthToken: nil];
    [self setUploadPath: nil];
    [self setFtpHost: nil];
    [self setFtpPort: nil];
    [self setFtpUser: nil];
    [self setFtpPass: nil];
    [self setMessage: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:UserAuthResponse"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(authToken!=nil)
        if(authToken!=nil){
            [NSWSDL addChild:e withName:@"AuthToken" withValue: authToken asAttribute:NO];
        }
    if(uploadPath!=nil)
        if(uploadPath!=nil){
            [NSWSDL addChild:e withName:@"UploadPath" withValue: uploadPath asAttribute:NO];
        }
    if(ftpHost!=nil)
        if(ftpHost!=nil){
            [NSWSDL addChild:e withName:@"FtpHost" withValue: ftpHost asAttribute:NO];
        }
    if(ftpPort!=nil)
        if(ftpPort!=nil){
            [NSWSDL addChild:e withName:@"FtpPort" withValue: [ftpPort stringValue] asAttribute:NO];
        }
    if(ftpUser!=nil)
        if(ftpUser!=nil){
            [NSWSDL addChild:e withName:@"FtpUser" withValue: ftpUser asAttribute:NO];
        }
    if(ftpPass!=nil)
        if(ftpPass!=nil){
            [NSWSDL addChild:e withName:@"FtpPass" withValue: ftpPass asAttribute:NO];
        }
    if(message!=nil)
        if(message!=nil){
            [NSWSDL addChild:e withName:@"Message" withValue: message asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setAuthToken: [NSWSDL getString:root:@"AuthToken":NO]];
    [self setUploadPath: [NSWSDL getString:root:@"UploadPath":NO]];
    [self setFtpHost: [NSWSDL getString:root:@"FtpHost":NO]];
    [self setFtpPort: [NSWSDL getNumber:root:@"FtpPort":NO]];
    [self setFtpUser: [NSWSDL getString:root:@"FtpUser":NO]];
    [self setFtpPass: [NSWSDL getString:root:@"FtpPass":NO]];
    [self setMessage: [NSWSDL getString:root:@"Message":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_UserAuthResponse* obj = [[EwordWebService_UserAuthResponse alloc] init];
#else
    EwordWebService_UserAuthResponse* obj = [[[EwordWebService_UserAuthResponse alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService_SubmitOrder

@synthesize authToken;
@synthesize fileName;
@synthesize fileContent;
@synthesize chunkCount;
@synthesize totalCunks;
@synthesize chunkHash;
@synthesize isRush;
@synthesize isEfile;
@synthesize appId;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setAuthToken: nil];
    [self setFileName: nil];
    [self setFileContent: nil];
    [self setChunkCount: nil];
    [self setTotalCunks: nil];
    [self setChunkHash: nil];
    [self setIsRush: nil];
    [self setIsEfile: nil];
    [self setAppId: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:SubmitOrder"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(authToken!=nil)
        if(authToken!=nil){
            [NSWSDL addChild:e withName:@"AuthToken" withValue: authToken asAttribute:NO];
        }
    if(fileName!=nil)
        if(fileName!=nil){
            [NSWSDL addChild:e withName:@"FileName" withValue: fileName asAttribute:NO];
        }
    if(fileContent!=nil)
        if(fileContent!=nil){
            [NSWSDL addChild:e withName:@"FileContent" withValue: fileContent asAttribute:NO];
        }
    if(chunkCount!=nil)
        if(chunkCount!=nil){
            [NSWSDL addChild:e withName:@"ChunkCount" withValue: [chunkCount stringValue] asAttribute:NO];
        }
    if(totalCunks!=nil)
        if(totalCunks!=nil){
            [NSWSDL addChild:e withName:@"TotalCunks" withValue: [totalCunks stringValue] asAttribute:NO];
        }
    if(chunkHash!=nil)
        if(chunkHash!=nil){
            [NSWSDL addChild:e withName:@"ChunkHash" withValue: chunkHash asAttribute:NO];
        }
    if(isRush!=nil)
        if(isRush!=nil){
            [NSWSDL addChild:e withName:@"IsRush" withValue: [isRush stringValue] asAttribute:NO];
        }
    if(isEfile!=nil)
        if(isEfile!=nil){
            [NSWSDL addChild:e withName:@"IsEfile" withValue: [isEfile stringValue] asAttribute:NO];
        }
    if(appId!=nil)
        if(appId!=nil){
            [NSWSDL addChild:e withName:@"AppId" withValue: appId asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setAuthToken: [NSWSDL getString:root:@"AuthToken":NO]];
    [self setFileName: [NSWSDL getString:root:@"FileName":NO]];
    [self setFileContent: [NSWSDL getString:root:@"FileContent":NO]];
    [self setChunkCount: [NSWSDL getNumber:root:@"ChunkCount":NO]];
    [self setTotalCunks: [NSWSDL getNumber:root:@"TotalCunks":NO]];
    [self setChunkHash: [NSWSDL getString:root:@"ChunkHash":NO]];
    [self setIsRush: [NSWSDL getBool:root:@"IsRush":NO]];
    [self setIsEfile: [NSWSDL getBool:root:@"IsEfile":NO]];
    [self setAppId: [NSWSDL getString:root:@"AppId":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrder* obj = [[EwordWebService_SubmitOrder alloc] init];
#else
    EwordWebService_SubmitOrder* obj = [[[EwordWebService_SubmitOrder alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService_SubmitOrderResponse

@synthesize orderID;
@synthesize message;
@synthesize sizeRecived;
@synthesize status;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setOrderID: nil];
    [self setMessage: nil];
    [self setSizeRecived: nil];
    [self setStatus: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:SubmitOrderResponse"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(orderID!=nil)
        if(orderID!=nil){
            [NSWSDL addChild:e withName:@"OrderID" withValue: orderID asAttribute:NO];
        }
    if(message!=nil)
        if(message!=nil){
            [NSWSDL addChild:e withName:@"Message" withValue: message asAttribute:NO];
        }
    if(sizeRecived!=nil)
        if(sizeRecived!=nil){
            [NSWSDL addChild:e withName:@"SizeRecived" withValue: [sizeRecived stringValue] asAttribute:NO];
        }
    if(status!=nil)
        if(status!=nil){
            [NSWSDL addChild:e withName:@"Status" withValue: status asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setOrderID: [NSWSDL getString:root:@"OrderID":NO]];
    [self setMessage: [NSWSDL getString:root:@"Message":NO]];
    [self setSizeRecived: [NSWSDL getNumber:root:@"SizeRecived":NO]];
    [self setStatus: [NSWSDL getString:root:@"Status":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrderResponse* obj = [[EwordWebService_SubmitOrderResponse alloc] init];
#else
    EwordWebService_SubmitOrderResponse* obj = [[[EwordWebService_SubmitOrderResponse alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService_SubmitFtpOrder

@synthesize authToken;
@synthesize fileName;
@synthesize isRush;
@synthesize isEfile;
@synthesize appId;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setAuthToken: nil];
    [self setFileName: nil];
    [self setIsRush: nil];
    [self setIsEfile: nil];
    [self setAppId: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:SubmitFtpOrder"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(authToken!=nil)
        if(authToken!=nil){
            [NSWSDL addChild:e withName:@"AuthToken" withValue: authToken asAttribute:NO];
        }
    if(fileName!=nil)
        if(fileName!=nil){
            [NSWSDL addChild:e withName:@"FileName" withValue: fileName asAttribute:NO];
        }
    if(isRush!=nil)
        if(isRush!=nil){
            [NSWSDL addChild:e withName:@"IsRush" withValue: [isRush stringValue] asAttribute:NO];
        }
    if(isEfile!=nil)
        if(isEfile!=nil){
            [NSWSDL addChild:e withName:@"IsEfile" withValue: [isEfile stringValue] asAttribute:NO];
        }
    if(appId!=nil)
        if(appId!=nil){
            [NSWSDL addChild:e withName:@"AppId" withValue: appId asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setAuthToken: [NSWSDL getString:root:@"AuthToken":NO]];
    [self setFileName: [NSWSDL getString:root:@"FileName":NO]];
    [self setIsRush: [NSWSDL getBool:root:@"IsRush":NO]];
    [self setIsEfile: [NSWSDL getBool:root:@"IsEfile":NO]];
    [self setAppId: [NSWSDL getString:root:@"AppId":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrder* obj = [[EwordWebService_SubmitFtpOrder alloc] init];
#else
    EwordWebService_SubmitFtpOrder* obj = [[[EwordWebService_SubmitFtpOrder alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService_SubmitFtpOrderResponse

@synthesize orderID;
@synthesize message;
@synthesize status;


#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [self setOrderID: nil];
    [self setMessage: nil];
    [self setStatus: nil];
    [super dealloc];
}
#endif


-(NSXMLElement*) toXMLElement{
    NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:SubmitFtpOrderResponse"];
    [self fillXML:e];
    return e;
}


-(void) fillXML:(NSXMLElement*) e{
    if(orderID!=nil)
        if(orderID!=nil){
            [NSWSDL addChild:e withName:@"OrderID" withValue: orderID asAttribute:NO];
        }
    if(message!=nil)
        if(message!=nil){
            [NSWSDL addChild:e withName:@"Message" withValue: message asAttribute:NO];
        }
    if(status!=nil)
        if(status!=nil){
            [NSWSDL addChild:e withName:@"Status" withValue: status asAttribute:NO];
        }
}


-(void) loadFrom: (NSXMLElement*) root{
    if(root==nil) return;
    [self setOrderID: [NSWSDL getString:root:@"OrderID":NO]];
    [self setMessage: [NSWSDL getString:root:@"Message":NO]];
    [self setStatus: [NSWSDL getString:root:@"Status":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
    if(root==nil) return nil;
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrderResponse* obj = [[EwordWebService_SubmitFtpOrderResponse alloc] init];
#else
    EwordWebService_SubmitFtpOrderResponse* obj = [[[EwordWebService_SubmitFtpOrderResponse alloc] init] autorelease];
#endif
    [obj loadFrom:root];
    return obj;
}

@end


@implementation EwordWebService

#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [super dealloc];
}
#endif


+(EwordWebService*) service{
#if __has_feature(objc_arc)
    return [[EwordWebService alloc] init];
#else
    return [[[EwordWebService alloc] init] autorelease];
#endif
}

-(id) init{
    if(!(self = [super init])) return nil;
    [self set__url: @"/appwebservice/appserver.php"];
    return self;
}

-(NSString*) getNamespaces
{
    NSString* ns = [NSString string];
    ns = [ns stringByAppendingString:@" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:ns4=\"http://client.ewordsolutions.com/EwordWebService/\" \r\n"];
    return ns;
}

-(EwordWebService_UserAuthResponse*)UserAuth : (NSString*) userName userPass: (NSString*) userPass appId: (NSString*) appId error: (NSError**)pError{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"http://client.ewordsolutions.com/EwordWebService/UserAuth" error:pError];
#if __has_feature(objc_arc)
    EwordWebService_UserAuth* ___method = [[EwordWebService_UserAuth alloc] init];
#else
    EwordWebService_UserAuth* ___method = [[[EwordWebService_UserAuth alloc] init] autorelease];
#endif
    [___method setUserName: userName];
    [___method setUserPass: userPass];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    SoapResponse* _resp = [self getSoapResponse: _req error:pError];
    if(_resp==nil) return nil;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_UserAuthResponse* __response = [[EwordWebService_UserAuthResponse alloc] init];
#else
    EwordWebService_UserAuthResponse* __response = [[[EwordWebService_UserAuthResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [NSWSDL setBusy:NO];
    return retVal;
}

-(EwordWebService_SubmitOrderResponse*)SubmitOrder : (NSString*) authToken fileName: (NSString*) fileName fileContent: (NSString*) fileContent chunkCount: (NSNumber*) chunkCount totalCunks: (NSNumber*) totalCunks chunkHash: (NSString*) chunkHash isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId error: (NSError**)pError{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"http://client.ewordsolutions.com/EwordWebService/SubmitOrder" error:pError];
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrder* ___method = [[EwordWebService_SubmitOrder alloc] init];
#else
    EwordWebService_SubmitOrder* ___method = [[[EwordWebService_SubmitOrder alloc] init] autorelease];
#endif
    [___method setAuthToken: authToken];
    [___method setFileName: fileName];
    [___method setFileContent: fileContent];
    [___method setChunkCount: chunkCount];
    [___method setTotalCunks: totalCunks];
    [___method setChunkHash: chunkHash];
    [___method setIsRush: isRush];
    [___method setIsEfile: isEfile];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    SoapResponse* _resp = [self getSoapResponse: _req error:pError];
    if(_resp==nil) return nil;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrderResponse* __response = [[EwordWebService_SubmitOrderResponse alloc] init];
#else
    EwordWebService_SubmitOrderResponse* __response = [[[EwordWebService_SubmitOrderResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [NSWSDL setBusy:NO];
    return retVal;
}

-(EwordWebService_SubmitFtpOrderResponse*)SubmitFtpOrder : (NSString*) authToken fileName: (NSString*) fileName isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId error: (NSError**)pError{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"" error:pError];
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrder* ___method = [[EwordWebService_SubmitFtpOrder alloc] init];
#else
    EwordWebService_SubmitFtpOrder* ___method = [[[EwordWebService_SubmitFtpOrder alloc] init] autorelease];
#endif
    [___method setAuthToken: authToken];
    [___method setFileName: fileName];
    [___method setIsRush: isRush];
    [___method setIsEfile: isEfile];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    SoapResponse* _resp = [self getSoapResponse: _req error:pError];
    if(_resp==nil) return nil;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrderResponse* __response = [[EwordWebService_SubmitFtpOrderResponse alloc] init];
#else
    EwordWebService_SubmitFtpOrderResponse* __response = [[[EwordWebService_SubmitFtpOrderResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [NSWSDL setBusy:NO];
    return retVal;
}

@end


@implementation EwordWebServiceAsync

#if __has_feature(objc_arc)
#else
-(void) dealloc
{
    [super dealloc];
}
#endif


+(EwordWebServiceAsync*) service{
#if __has_feature(objc_arc)
    return [[EwordWebServiceAsync alloc] init];
#else
    return [[[EwordWebServiceAsync alloc] init] autorelease];
#endif
}

-(id) init{
    if(!(self = [super init])) return nil;
    [self set__url: @"/appwebservice/appserver.php"];
    return self;
}

-(NSString*) getNamespaces
{
    NSString* ns = [NSString string];
    ns = [ns stringByAppendingString:@" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" \r\n"];
    ns = [ns stringByAppendingString:@" xmlns:ns4=\"http://client.ewordsolutions.com/EwordWebService/\" \r\n"];
    return ns;
}

-(void) onUserAuthReceived: (id) sender{
    [NSWSDL setBusy: NO];
    if(self.delegate == nil) return;
    if(![self.delegate respondsToSelector:@selector(onUserAuthReceived:  result:)]) return;
    SoapResponse* _resp = (SoapResponse*)sender;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_UserAuthResponse* __response = [[EwordWebService_UserAuthResponse alloc] init];
#else
    EwordWebService_UserAuthResponse* __response = [[[EwordWebService_UserAuthResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [delegate onUserAuthReceived: self  result: retVal];
}


-(void)UserAuth : (NSString*) userName userPass: (NSString*) userPass appId: (NSString*) appId{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"http://client.ewordsolutions.com/EwordWebService/UserAuth" error:nil];
#if __has_feature(objc_arc)
    EwordWebService_UserAuth* ___method = [[EwordWebService_UserAuth alloc] init];
#else
    EwordWebService_UserAuth* ___method = [[[EwordWebService_UserAuth alloc] init] autorelease];
#endif
    [___method setUserName: userName];
    [___method setUserPass: userPass];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    [super postSoapRequest: _req selector:@selector(onUserAuthReceived:)];
}

-(void) onSubmitOrderReceived: (id) sender{
    [NSWSDL setBusy: NO];
    if(self.delegate == nil) return;
    if(![self.delegate respondsToSelector:@selector(onSubmitOrderReceived:  result:)]) return;
    SoapResponse* _resp = (SoapResponse*)sender;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrderResponse* __response = [[EwordWebService_SubmitOrderResponse alloc] init];
#else
    EwordWebService_SubmitOrderResponse* __response = [[[EwordWebService_SubmitOrderResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [delegate onSubmitOrderReceived: self  result: retVal];
}


-(void)SubmitOrder : (NSString*) authToken fileName: (NSString*) fileName fileContent: (NSString*) fileContent chunkCount: (NSNumber*) chunkCount totalCunks: (NSNumber*) totalCunks chunkHash: (NSString*) chunkHash isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"http://client.ewordsolutions.com/EwordWebService/SubmitOrder" error:nil];
#if __has_feature(objc_arc)
    EwordWebService_SubmitOrder* ___method = [[EwordWebService_SubmitOrder alloc] init];
#else
    EwordWebService_SubmitOrder* ___method = [[[EwordWebService_SubmitOrder alloc] init] autorelease];
#endif
    [___method setAuthToken: authToken];
    [___method setFileName: fileName];
    [___method setFileContent: fileContent];
    [___method setChunkCount: chunkCount];
    [___method setTotalCunks: totalCunks];
    [___method setChunkHash: chunkHash];
    [___method setIsRush: isRush];
    [___method setIsEfile: isEfile];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    [super postSoapRequest: _req selector:@selector(onSubmitOrderReceived:)];
}

-(void) onSubmitFtpOrderReceived: (id) sender{
    [NSWSDL setBusy: NO];
    if(self.delegate == nil) return;
    if(![self.delegate respondsToSelector:@selector(onSubmitFtpOrderReceived:  result:)]) return;
    SoapResponse* _resp = (SoapResponse*)sender;
    if([_resp header]!=nil)
    {
    }
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrderResponse* __response = [[EwordWebService_SubmitFtpOrderResponse alloc] init];
#else
    EwordWebService_SubmitFtpOrderResponse* __response = [[[EwordWebService_SubmitFtpOrderResponse alloc] init] autorelease];
#endif
    [__response loadFrom: [_resp body]];
    id retVal = __response;
    [delegate onSubmitFtpOrderReceived: self  result: retVal];
}


-(void)SubmitFtpOrder : (NSString*) authToken fileName: (NSString*) fileName isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId{
    [NSWSDL setBusy:YES];
    SoapRequest* _req = [self buildSoapRequest: @"" error:nil];
#if __has_feature(objc_arc)
    EwordWebService_SubmitFtpOrder* ___method = [[EwordWebService_SubmitFtpOrder alloc] init];
#else
    EwordWebService_SubmitFtpOrder* ___method = [[[EwordWebService_SubmitFtpOrder alloc] init] autorelease];
#endif
    [___method setAuthToken: authToken];
    [___method setFileName: fileName];
    [___method setIsRush: isRush];
    [___method setIsEfile: isEfile];
    [___method setAppId: appId];
    [_req setMethod: [___method toXMLElement]];
    [super postSoapRequest: _req selector:@selector(onSubmitFtpOrderReceived:)];
}

@end

