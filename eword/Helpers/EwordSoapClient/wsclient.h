
#import "TargetConditionals.h" 
#import "NSWSDL.h"
@class EwordWebService_UserAuth;
@class EwordWebService_UserAuthResponse;
@class EwordWebService_SubmitOrder;
@class EwordWebService_SubmitOrderResponse;
@class EwordWebService_SubmitFtpOrder;
@class EwordWebService_SubmitFtpOrderResponse;


@interface EwordWebService_UserAuth : BaseWSObject{
    NSString* userName;
    NSString* userPass;
    NSString* appId;
}

@property (readwrite,copy) NSString* userName;
@property (readwrite,copy) NSString* userPass;
@property (readwrite,copy) NSString* appId;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService_UserAuthResponse : BaseWSObject{
    NSString* authToken;
    NSString* uploadPath;
    NSString* ftpHost;
    NSNumber* ftpPort;
    NSString* ftpUser;
    NSString* ftpPass;
    NSString* message;
}

@property (readwrite,copy) NSString* authToken;
@property (readwrite,copy) NSString* uploadPath;
@property (readwrite,copy) NSString* ftpHost;
@property (readwrite,copy) NSNumber* ftpPort;
@property (readwrite,copy) NSString* ftpUser;
@property (readwrite,copy) NSString* ftpPass;
@property (readwrite,copy) NSString* message;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService_SubmitOrder : BaseWSObject{
    NSString* authToken;
    NSString* fileName;
    NSString* fileContent;
    NSNumber* chunkCount;
    NSNumber* totalCunks;
    NSString* chunkHash;
    NSNumber* isRush;
    NSNumber* isEfile;
    NSString* appId;
}

@property (readwrite,copy) NSString* authToken;
@property (readwrite,copy) NSString* fileName;
@property (readwrite,copy) NSString* fileContent;
@property (readwrite,copy) NSNumber* chunkCount;
@property (readwrite,copy) NSNumber* totalCunks;
@property (readwrite,copy) NSString* chunkHash;
@property (readwrite,copy) NSNumber* isRush;
@property (readwrite,copy) NSNumber* isEfile;
@property (readwrite,copy) NSString* appId;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService_SubmitOrderResponse : BaseWSObject{
    NSString* orderID;
    NSString* message;
    NSNumber* sizeRecived;
    NSString* status;
}

@property (readwrite,copy) NSString* orderID;
@property (readwrite,copy) NSString* message;
@property (readwrite,copy) NSNumber* sizeRecived;
@property (readwrite,copy) NSString* status;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService_SubmitFtpOrder : BaseWSObject{
    NSString* authToken;
    NSString* fileName;
    NSNumber* isRush;
    NSNumber* isEfile;
    NSString* appId;
}

@property (readwrite,copy) NSString* authToken;
@property (readwrite,copy) NSString* fileName;
@property (readwrite,copy) NSNumber* isRush;
@property (readwrite,copy) NSNumber* isEfile;
@property (readwrite,copy) NSString* appId;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService_SubmitFtpOrderResponse : BaseWSObject{
    NSString* orderID;
    NSString* message;
    NSString* status;
}

@property (readwrite,copy) NSString* orderID;
@property (readwrite,copy) NSString* message;
@property (readwrite,copy) NSString* status;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface EwordWebService: SoapWebService{
}

+(EwordWebService*) service;


-(id) init;

-(EwordWebService_UserAuthResponse*)UserAuth : (NSString*) userName userPass: (NSString*) userPass appId: (NSString*) appId error: (NSError**)pError;
-(EwordWebService_SubmitOrderResponse*)SubmitOrder : (NSString*) authToken fileName: (NSString*) fileName fileContent: (NSString*) fileContent chunkCount: (NSNumber*) chunkCount totalCunks: (NSNumber*) totalCunks chunkHash: (NSString*) chunkHash isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId error: (NSError**)pError;
-(EwordWebService_SubmitFtpOrderResponse*)SubmitFtpOrder : (NSString*) authToken fileName: (NSString*) fileName isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId error: (NSError**)pError;

@end

@interface EwordWebServiceAsync: SoapWebService {
}

+(EwordWebServiceAsync*) service;


-(id) init;

-(void)UserAuth : (NSString*) userName userPass: (NSString*) userPass appId: (NSString*) appId;
-(void)SubmitOrder : (NSString*) authToken fileName: (NSString*) fileName fileContent: (NSString*) fileContent chunkCount: (NSNumber*) chunkCount totalCunks: (NSNumber*) totalCunks chunkHash: (NSString*) chunkHash isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId;
-(void)SubmitFtpOrder : (NSString*) authToken fileName: (NSString*) fileName isRush: (NSNumber*) isRush isEfile: (NSNumber*) isEfile appId: (NSString*) appId;

@end

@protocol EwordWebServiceDelegate<NSObject>

@optional

-(void) onError: (NSError*) error;


-(void) onUserAuthReceived : (EwordWebServiceAsync*) service  result:(EwordWebService_UserAuthResponse*) result ;
-(void) onSubmitOrderReceived : (EwordWebServiceAsync*) service  result:(EwordWebService_SubmitOrderResponse*) result ;
-(void) onSubmitFtpOrderReceived : (EwordWebServiceAsync*) service  result:(EwordWebService_SubmitFtpOrderResponse*) result ;

@end
