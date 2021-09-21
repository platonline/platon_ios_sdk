
import Foundation

/// Base sale model of response which used for extended sale models and in callback of *PlatonRecurringAdapter* requests
public class PlatonSale: PlatonBaseResponseModel, PlatonSaleProtocol {
    
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

public class PlatonSaleSuccess: PlatonSale, PlatonDescriptorProtocol, PlatonStatusProtocol {
    
    public let descriptor: String
    
    public let status: PlatonStatus
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, descriptor: String, status: PlatonStatus, transDate: String) {
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
    }
    
}

final public class PlatonRecurringInit: PlatonSaleSuccess, PlatonRecurringTokenProtocol {
    
    public let recurringToken: String
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, descriptor: String, status: PlatonStatus, transDate: String, recurringToken: String) {
        self.recurringToken = recurringToken
        
        super.init(action: action, result: result, orderId: orderId, transId: transId, descriptor: descriptor, status: status, transDate: transDate)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        recurringToken = try container.decode(type(of: recurringToken), forKey: .recurringToken)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case recurringToken = "recurring_token"
    }
}

final public class PlatonSaleUnsuccess: PlatonSale, PlatonDeclineReasonProtocol, PlatonStatusProtocol {
    
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
 After the successful request in *PlatonCalback* you should get *submit3dsDataRequest* and load this request in WKWebView where will be the button which will submit your 3ds data and verify payment
 ```
 ...
 PlatonPostPayment.sale.sale(order: order, card: card, payer: payer, saleOption: saleOption, auth: auth) { (result) in
 
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

final public class PlatonSale3DS: PlatonSale, PlatonStatusProtocol, PlatonRedirectProtocol {
    public let status: PlatonStatus
    public let redirectUrl: String
    public let redirectParams: PlatonRedirectParams
    public let redirectMethod: PlatonHTTPMethod
        
    /// Request whcich you should load in Webview for submit your 3ds data and verify payment
    public var submit3dsDataRequest: URLRequest? {
        guard let baseUrl = URL(string: "\(redirectUrl)") else {
            return nil
        }
        var request = URLRequest(url: baseUrl)
        request.httpMethod = redirectMethod.rawValue
        request.httpBody = redirectParams.anyParams.prepareQuery().data(using: .utf8)

        return request
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
