
import Foundation

/// Request model that is used to store product data
public struct PlatonProductSale: PlatonAmountProtocol, PlatonParametersProtocol {
    
    /// PlatonProduct, selected by default in products list
    public let isSelected: Bool
    
    /// Flag to initialize the possibility of the further recurring payments
    public let isRecurring: Bool
    
    /// The amount of the transaction
    /// - Requires: Numbers in the form XXXX.XX (without leading zeros)
    public let amount: Float
    
    /// The amount of the transaction
    /// - Requires: Currency 3-letter code (ISO 4217).
    public let currencyCode: String
    
    /// Description of the transaction (product name)
    /// - Requires: String up to 1024 characters
    public let description: String
    
    public init(isSelected: Bool = false, isRecurring: Bool = false, amount: Float, currencyCode: String, description: String) {
        self.isSelected = isSelected
        self.isRecurring = isRecurring
        self.amount = amount
        self.currencyCode = currencyCode
        self.description = description
    }
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.selected: isSelected ? isSelected : nil,
            PlatonMethodProperty.recurring: isRecurring ? isRecurring : nil,
            PlatonMethodProperty.amount: amount.platonAmount,
            PlatonMethodProperty.currency: currencyCode,
            PlatonMethodProperty.description: description,
        ]
    }
}

/// Request model that is used to store product data
public struct PlatonProductRecurring: PlatonAmountProtocol, PlatonParametersProtocol {
    
    /// PlatonTransaction ID in the Clients system
    /// - Requires: String up to 255 characters
    public let id: String
    
    /// The amount of the transaction
    /// - Requires: Numbers in the form XXXX.XX (without leading zeros)
    public let amount: Float
    
    /// Description of the transaction (product name)
    /// - Requires: String up to 1024 characters
    public let description: String
    
    public init(id: String, amount: Float, description: String) {
        self.id = id
        self.amount = amount
        self.description = description
    }
    
    public var platonParams: PlatonParams {
        return [PlatonMethodProperty.order: id,
                PlatonMethodProperty.amount: amount.platonAmount,
                PlatonMethodProperty.description: description]
    }
}

/// Request model that is used to store product data
public struct PlatonProduct: PlatonParametersProtocol, PlatonAmountProtocol {
    
    /// The amount of the transaction
    /// - Requires: Numbers in the form XXXX.XX (without leading zeros)
    public let amount: Float
    
    /// Description of the transaction (product name)
    /// - Requires: String up to 1024 characters
    public let description: String
    
    public init(amount: Float, description: String) {
        self.amount = amount
        self.description = description
    }
    
    public var platonParams: PlatonParams {
        return [PlatonMethodProperty.amount: amount.platonAmount,
                PlatonMethodProperty.description: description]
    }
}
