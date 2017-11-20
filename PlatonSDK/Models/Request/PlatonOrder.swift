
import Foundation

/// Request model that is used to store order data
///
/// Analogue of *PlatonTransaction* in Payment System
public struct PlatonOrder: PlatonParametersProtocol {
    
    /// The amount of the transaction
    /// - Requires: Numbers in the form XXXX.XX (without leading zeros)
    public var amount: Float
    
    /// PlatonTransaction ID in the Clients system
    /// - Requires: String up to 255 characters
    public var id: String?
    
    /// Description of the transaction (product name)
    /// - Requires: String up to 1024 characters
    public var orderDescription: String
    
    /// The amount of the transaction
    /// - Requires: Currency 3-letter code (ISO 4217).
    public var currencyCode: String?
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.orderAmount: amount.platonAmount,
            PlatonMethodProperty.orderId: id,
            PlatonMethodProperty.orderDescription: orderDescription,
            PlatonMethodProperty.orderCurrency: currencyCode
            ]
    }
    
    public init(amount: Float, id: String? = nil, orderDescription: String, currencyCode: String? = nil) {
        self.amount = amount
        self.id = id
        self.orderDescription = orderDescription
        self.currencyCode = currencyCode
    }

}

