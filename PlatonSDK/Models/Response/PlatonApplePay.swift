
import Foundation
import Alamofire

/// Base sale model of response which used for extended sale models and in callback of *PlatonApplePayAdapter* requests
public class PlatonApplePay: PlatonBaseResponseModel, PlatonSaleProtocol {
    
    public let transDate: String
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, transDate: String) {
        self.transDate = transDate
        
        super.init(action: action, result: result, orderId: orderId, transId: transId)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        transDate = try container.decode(type(of: transDate), forKey: .transDate)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case transDate = "trans_date"
    }
}

public class PlatonApplePaySuccess: PlatonApplePay, PlatonStatusProtocol {
    
    public let descriptor: String?
    
    public let status: PlatonStatus
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, descriptor: String?, status: PlatonStatus, transDate: String) {
        self.descriptor = descriptor
        self.status = status

        super.init(action: action, result: result, orderId: orderId, transId: transId, transDate: transDate)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        descriptor = try container.decode(type(of: descriptor), forKey: .descriptor)
        status = try container.decode(type(of: status), forKey: .status)

        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case descriptor, status
        case recurringToken = "recurring_token"
    }
    
}

final public class PlatonApplePayUnsuccess: PlatonApplePay, PlatonDeclineReasonProtocol, PlatonStatusProtocol {
    
    public let declineReason: String
    
    public let status: PlatonStatus
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, transDate: String, declineReason: String, status: PlatonStatus) {
        self.declineReason = declineReason
        self.status = status
        
        super.init(action: action, result: result, orderId: orderId, transId: transId, transDate: transDate)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        declineReason = try container.decode(type(of: declineReason), forKey: .declineReason)
        status = try container.decode(type(of: status), forKey: .status)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case declineReason = "decline_reason"
        case status
    }
}

/**
 After the successful request in *PlatonCalback* you should get *submit3dsDataRequest* and load this request in UIWebView where will be the button which will submit your 3ds data and verify payment
 ```
 ...
 PlatonPostPayment.applePay.pay(payer: PlatonPayerApplePay, paymentToken: paymentToken, clientKey: clientKey, channelId: channelId, orderId: orderId, orderDescription: orderDescription, amount: amountl, termsUrl3ds: termsUrl3ds) { (result) in
 
 switch result {
 ...
     case .secure3d(let sale3ds):
     if let request = sale3ds.submit3dsDataRequest?.request {
         webView?.loadRequest(request)
     }
 }
 ...
 }
 ```
 */

final public class PlatonApplePay3DS: PlatonApplePay, PlatonStatusProtocol, PlatonRedirectProtocol {
    public let status: PlatonStatus
    public let redirectUrl: String
    public let redirectParams: PlatonRedirectParams
    public let redirectMethod: PlatonHTTPMethod
    
    let queue = OperationQueue()
    
    /// Request whcich you should load in Webview for submit your 3ds data and verify payment
    public var submit3dsDataRequest: DataRequest? {
        guard let baseUrl = URL(string: "\(redirectUrl)") else {
            return nil
        }
        let httpMethod = HTTPMethod.init(rawValue: redirectMethod.rawValue)
        
        return Session.default.request(baseUrl, method: httpMethod,
                                       parameters: redirectParams.alamofireParams,
                                       encoding: URLEncoding.default, headers: nil)
    }
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, transDate: String, status: PlatonStatus, redirectUrl: String, redirectParams: PlatonRedirectParams, redirectMethod: PlatonHTTPMethod) {
        self.status = status
        self.redirectUrl = redirectUrl
        self.redirectParams = redirectParams
        self.redirectMethod = redirectMethod
        
        super.init(action: action, result: result, orderId: orderId, transId: transId, transDate: transDate)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try container.decode(type(of: status), forKey: .status)
        self.redirectUrl = try container.decode(type(of: redirectUrl), forKey: .redirectUrl)
        self.redirectParams = try container.decode(type(of: redirectParams), forKey: .redirectParams)
        self.redirectMethod = try container.decode(type(of: redirectMethod), forKey: .redirectMethod)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case redirectUrl = "redirect_url"
        case redirectParams = "redirect_params"
        case redirectMethod = "redirect_method"
    }
}
