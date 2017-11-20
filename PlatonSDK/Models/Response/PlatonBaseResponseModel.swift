
import Foundation
import Alamofire

// MARK: - Protocols

public protocol PlatonBaseProtocol: Decodable, PlatonCustomDescribe {
    
    /// When you make request to Payment Platform, you need to specify action, that needs to be done
    var action: PlatonMethodAction { get }
    
    /// Value that system returns on request
    var result: PlatonResult { get }
    
    /// PlatonTransaction ID in the Client’s system
    var orderId: String { get }
    
    /// PlatonTransaction ID in the Payment Platform
    ///
    /// Usually can be used as main identifier when creating recurring and/or scheduled payments
    var transId: String { get }
}

// MARK: - Main Response protocols

public protocol PlatonSaleProtocol: PlatonBaseProtocol, PlatonTransactionDateProtocol { }
public protocol PlatonCaptureProtocol: PlatonBaseProtocol, PlatonStatusProtocol  { }


// MARK: - Additional

public protocol PlatonTransactionDateProtocol: Decodable {
   
    /// PlatonTransaction date in the Payment Platform
    /// - Requires: YYYY-MM-DD HH:mm:ss ("2012-04-03 16:02:02")
    var transDate: String { get }
}

public protocol PlatonDescriptorProtocol: Decodable {
    
    /// This is a string which the owner of the credit card will see in the statement from the bank
    ///
    /// In most cases, this is the Customers support web-site
    var descriptor: String { get }
}

public protocol PlatonStatusProtocol: Decodable {
    
    /// See *PlatonStatus* for main transaction and response
    ///
    /// See *PlatonTransactionStatus* for sub transactions
    var status: PlatonStatus { get }
}

public protocol PlatonRecurringTokenProtocol: Decodable {
    /// PlatonRecurring token (get if account support recurring sales and transaction was initialized for recurring)
    var recurringToken: String { get }
}

public protocol PlatonDeclineReasonProtocol: Decodable {
    /// The reason why the transaction was declined
    ///
    /// ex. "Declined by processing"
    var declineReason: String { get }
}

public protocol PlatonRedirectProtocol: Decodable {
    
    /// URL to which the Client should redirect the Customer
    var redirectUrl: String { get }
    
    /// Holder of specific 3DS redirect parameters
    var redirectParams: PlatonRedirectParams { get }
    
    /// The method of transferring parameters
    var redirectMethod: PlatonHTTPMethod { get }
}

public protocol PlatonPayerProtocol: Decodable {
    
    /// Payer name
    var name: String { get }
    
    /// Payer email
    var mail: String { get }
    
    /// Payer IP address
    var ip: String { get }
}

public protocol PlatonAmountProtocol: Decodable {
    
    /// Amount of funds that is proceeded during transaction
    /// - Requires: XXXX.XX (without leading zeros). Ex. Right - 234.97. Wrong - 0023.34, 234.345
    var amount: Float { get }
}

public protocol PlatonCurrencyProtocol: Decodable {
 
    /// Order currency
    var currency: String { get }
}

public protocol PlatonCardProtocol: Decodable {
    
    /// Card in the format XXXXXX****XXXX
    var card: String { get }
}

// MARK: - Models

public class PlatonBaseResponseModel: PlatonBaseProtocol {
    public let action: PlatonMethodAction
    
    public let result: PlatonResult
    
    public let orderId: String
    
    public let transId: String
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String) {
        self.action = action
        self.result = result
        self.orderId = orderId
        self.transId = transId
    }
    
    private enum CodingKeys: String, CodingKey {
        case action, result
        case orderId = "order_id"
        case transId = "trans_id"
    }
    
}

public class PlatonBasePayment: PlatonBaseResponseModel, PlatonStatusProtocol {
    public let status: PlatonStatus
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, status: PlatonStatus) {
        self.status = status
        
        super.init(action: action, result: result, orderId: orderId, transId: transId)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try container.decode(type(of: status), forKey: .status)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
    }
}

/// Holder of specific 3DS redirect parameters
///
/// This model only included in *PlatonSale3DS* response
public struct PlatonRedirectParams: Decodable, PlatonCustomDescribe, PlatonParametersProtocol {
    
    let paymentRequisites: String

    let md: String

    let termUrl: String
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.paReq: paymentRequisites,
            PlatonMethodProperty.md: md,
            PlatonMethodProperty.termUrl: termUrl
        ]
    }
    
    private enum CodingKeys: String, CodingKey {
        case paymentRequisites = "PaReq"
        case md = "MD"
        case termUrl = "TermUrl"
    }
}
