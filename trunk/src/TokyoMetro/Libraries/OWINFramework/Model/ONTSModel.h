//
//  ONTSModel.h
//  ONTS
//
//  Created by ohs on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONWRequest.h"
#import "OWINAsyncXMLParser.h"
#import "OWINHttpRequest.h"
#import "OWINSocketRequest.h"
#import "OWINFilterSocketRequest.h"


typedef enum
{
    ONTSModelRequestTagNone = 0,
    ONTSModelRequestTagHttp = 1,
    ONTSModelRequestTagSocket = 2,
    
    ONTSModelRequestTagChineseStockOrderCancel  = 10,
    ONTSModelRequestTagCheckDupEmailAddress  = 11,
    ONTSModelRequestTagTopViewCustomer = 12,
    ONTSModelRequestTagTopViewIndex = 13,
    ONTSModelRequestTagTopViewMessage = 14,
    ONTSModelRequestTagChineseStockCurrentOrder = 15,
    ONTSModelRequestTagExecuteBuyOrder = 16,
    ONTSModelRequestTagConfirmBuyOrder = 17,
    ONTSModelRequestTagMoneyTransfe = 18,
    ONTSModelRequestTagAccountInfo = 19,
    ONTSModelRequestTagTransferCheck = 20,
    ONTSModelRequestTagTransferRequest = 21,
    ONTSModelRequestTagTransferCancelCheck = 22,
    ONTSModelRequestTagTransferCancel = 23,
    ONTSModelRequestTagConfirmModifingOrder = 24,
    ONTSModelRequestTagExecuteCancelOrder= 25, 
    ONTSModelRequestTagExecuteModifingOrder= 26,
    ONTSModelRequestTagCheckLogin = 27,
    ONTSModelRequestTagStockBalance = 28,
    ONTSModelRequestTagOrderHistory = 29,
    ONTSModelRequestTagConfirmSellOrder = 30,
    ONTSModelRequestTagExecuteSellOrder = 31,
    ONTSModelRequestTagBuyingLimit = 32,
    ONTSModelRequestTagCurrentOrder = 33,
    ONTSModelRequestTagStockInfo = 34,
    ONTSModelRequestTagSpecificBalance = 35,
    ONTSModelRequestTagSpecificTransferPLMonth = 36,
    ONTSModelRequestTagChangingPassword = 37,
    ONTSModelRequestTagSettlementPrevious = 38,
    ONTSModelRequestTagConfirmChineseStockBuyOrder = 39,
    ONTSModelRequestTagConfirmChineseStockSellOrder = 40,
    ONTSModelRequestTagHoldingStock = 41,
    ONTSModelRequestTagChangeOrderScrt = 42,
    ONTSModelRequestTagSpecificTransferPL = 43,
    ONTSModelRequestTagNotificationEmailSetExecute = 44,
    ONTSModelRequestTagNotificationEmailSet = 45,
    ONTSModelRequestTagChineseStockOrderRule = 46,
    ONTSModelRequestTagProfitAndLossCalcChina = 47,
    ONTSModelRequestTagProfitAndLossCalc = 48,
    ONTSModelRequestTagSystemDateTime = 49,
    ONTSModelRequestTagChineseCurrent = 50,
    ONTSModelRequestTagNewestGenerationElecDoc = 51,
    ONTSModelRequestTagElecDocValidIssueHistory = 52,
    ONTSModelRequestTagElecDocValidIssueLimit = 53,
    ONTSModelRequestTagElecDocIssueHistory = 54,
    ONTSModelRequestTagCheckDupHonEmailAddress = 55,
    ONTSModelRequestTagCustomerInfoList = 56,
    ONTSModelRequestTagChangingHonEmailAddress = 57,
    ONTSModelRequestTagExecuteChangeCustInfo = 58,
    ONTSModelRequestTagCaringPortfolioDetail = 59,
    ONTSModelRequestTagChineseExecuteBuyOrder = 60,
    ONTSModelRequestTagChineseExecuteSellOrder = 61,
    ONTSModelRequestTagOkasantradeupdate = 62,
    ONTSModelRequestTagGetChineseBuyTxtOne = 63,
    ONTSModelRequestTagGetChineseBuyTxtTwo = 64,
    ONTSModelRequestTagGetChineseSellTxtOne = 65,
    ONTSModelRequestTagGetChineseSellTxtTwo = 66,
    ONTSModelRequestTagCompanyInfoHttp = 67,
    ONTSModelRequestTagCheckSPCloseStatus = 68,
    ONTSModelRequestTagOrderCodeTable = 69,
    ONTSModelRequestTagAsknbid = 70,
    ONTSModelRequestTagStockInfoFirstMarket = 71,
    ONTSModelRequestTagChineseStockInvestInfo = 72,
    ONTSModelRequestTagStockInfoTheMarketChange = 73,
    
    
    ONTSModelRequestTagCaringPortfolioList = 1000,
    ONTSModelRequestTagSearch = 1001,
    ONTSModelRequestTagStockRank = 1002,
    ONTSModelRequestTagUserinfoMaddredit = 1003,
    ONTSModelRequestTagUserinfoMaddrlist = 1004,
    ONTSModelRequestTagUserinfoMnotylist = 1005,
    ONTSModelRequestTagUserinfoMnotyreg = 1006,
    ONTSModelRequestTagUserinfoTestmail = 1007,
    ONTSModelRequestTagStockTick = 1008,
    ONTSModelRequestTagCaringPortfolioEdit = 1008,
    ONTSModelRequestTagCaringPortfolio = 1009,
    ONTSModelRequestTagIndexExchange = 1010,
    ONTSModelRequestTagIndexInfo = 1011,
    ONTSModelRequestTagIndexExchangelist = 1012,
    ONTSModelRequestTagStockHistorical = 1013,
    ONTSModelRequestTagKeepingPortfolioList = 1014,
    ONTSModelRequestTagKeepingPortfolioEdit = 1015,
    ONTSModelRequestTagIndexAll = 1016,
    ONTSModelRequestTagIndexStocks = 1017,
    ONTSModelRequestTagNoticeNolist = 1018,
    ONTSModelRequestTagNoticeNotdetail = 1019,
    ONTSModelRequestTagCaringPortfolioDelete = 1020,
    ONTSModelRequestTagCaringPortfolioCheck = 1021,
    ONTSModelRequestTagCaringPortfolioInsert = 1022,
    ONTSModelRequestTagCaringPortfolioListEdit = 1023,
    ONTSModelRequestTagStockAskBid = 1024,
    ONTSModelRequestTagStockCurrent = 1025,
    ONTSModelRequestTagStockAll = 1026,
    ONTSModelRequestTagIndexTick = 1027,
    ONTSModelRequestTagIndexHistorical = 1028,
    ONTSModelRequestTagPortfolioGrp = 1029,
    ONTSModelRequestTagUserinfoKeepGroupList = 1030,
    ONTSModelRequestTagUserInfoKeepFolioBoard = 1031,
    ONTSModelRequestTagUserInfoFolioBoard = 1032,
    ONTSModelRequestTagUserinfoNoticecustomerdetail = 1033,
    ONTSModelRequestTagUserinfoNotdetail = 1034,
    ONTSModelRequestTagTopView = 1035,
    ONTSModelRequestTagUserinfoMnotyconlist = 1036,
    ONTSModelRequestTagUserinfoMnotyconreg = 1037,
    ONTSModelRequestTagUserInfoMnotycondel = 1038,
    ONTSModelRequestTagUserinfoLogin = 1039,
    ONTSModelRequestTagUserinfoMnotyresend = 1040,
    ONTSModelRequestTagStockMintick = 1041,
    ONTSModelRequestTagCompanyInfo = 1042,
    ONTSModelRequestTagTotallist = 1043,
    ONTSModelRequestTagCaringPortfolioSearchList = 1044,
    ONTSModelRequestTagRefreshIndexStocks = 1045,
    ONTSModelRequestTagKeepGrpList = 1046,
    ONTSModelRequestTagGroupList = 1047,
    ONTSModelRequestTagGroupCheck = 1048,
    ONTSModelRequestTagGroupInsert = 1049,
    ONTSModelRequestTagGroupEdit = 1050,
    ONTSModelRequestTagGroupDel = 1051,
    ONTSModelRequestTagFolioBoard = 1052,
    ONTSModelRequestTagKeepEdit = 1053,
    ONTSModelRequestTagFolioEdit = 1054,
    ONTSModelRequestTagIndexDaylist = 1055
}ONTSModelRequestTag;

typedef enum
{
    ONTSModelNoError = 0,
    ONTSModelSocketCFSocketError,
    ONTSModelSocketError,					
    ONTSModelSocketCanceledError,					// onSocketWillConnect: returned NO.
    ONTSModelSocketConnectTimeoutError,
    ONTSModelSocketReadMaxedOutError,               // Reached set maxLength without completing
    ONTSModelSocketReadTimeoutError,
    ONTSModelSocketWriteTimeoutError,
    ONTSModelHttpError,
    ONTSModelHttpConnectionFailureError,
    ONTSModelHttpRequestTimedOutError,
    ONTSModelHttpRequestCancelledError,
    ONTSModelHttpUnableToCreateRequestError,
    ONTSModelParseError,
    ONTSModelParseDataInvalidError,
    ONTSModelParseSsrIsFalseError,                  //<respons ssr=“fre”>
    ONTSModelParseMsgNoDataError,                   //<respons msg=“nodata”>
    
}ONTSModelError;

@protocol ONTSModelDelegate <NSObject>

@optional

//model的请求执行完成
- (void) modelAsyncDidFinished:(id) ONTSModel data:(id)data;
//model的请求执行失败
- (void) modelAsyncDidFailed:(id) ONTSModel data:(id)data;
//model带消息
- (void) modelAsyncDidWithMessage:(id) ONTSModel message:(id)message;

//设置独占请求
- (BOOL)shouldReuqestCancelOthers:(id)Request;

//连接出错
-(void) onConnectionFailure;
//连接出错
-(void) onUnableToCreateRequest;
//请求超时
-(void) onRequestTimeout;
//请求超时
-(void) onRequestCanceled;
//请求服务端注销
-(void) onServerSideLogout;
//请求结果没有任何数据
-(void) onResultNoData;
//SocketErr
-(void) onSocketReuqestError:(NSError *)err;
//HttpError
-(void) onHttpReuqestError:(NSError *)err;
//parse过程错误
-(void) onParseError:(NSError *)err;
//请求错误
-(void) onModelError:(NSError *)err;
@end

@interface ONTSModel : NSObject<ONWRequestDelegate, OWINAsyncXMLParserDelegate>
{
    id<ONTSModelDelegate> _delegate;
}

@property (assign, nonatomic) id<ONTSModelDelegate> delegate;

-(id) initWithDelegate:(id<ONTSModelDelegate>)delegate;

//取消所有活动的请求
-(void) cancelAllActiveRequest;

-(Class) parserClassForRequest:(ONWRequest *) request tag:(int)tag;
-(Class) dataClassForParser:(OAPAsyncParser *) parser tag:(int)tag;
-(NSArray *) parserClassesForRequest:(ONWRequest *) request tag:(int)tag;
-(NSArray *) dataClassesForParser:(OAPAsyncParser *) parser tag:(int)tag;

@end
