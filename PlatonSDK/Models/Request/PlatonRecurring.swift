
import Foundation

/// Request model that is used to store recurring data
public struct PlatonRecurring: PlatonParametersProtocol {
    
    /// PlatonTransaction ID of the primary transaction in the Payment Platform
    /// - Requires: Numbers in the form XXX
    public let firstTransId: String
    
    /// Value obtained during the primary transaction
    /// - Requires: Numbers in the form XXX
    public let token: String
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.recurringFirstTransId: firstTransId,
            PlatonMethodProperty.recurringToken: token
        ]
    }
}

/// Request model that is used to store recurring data
public struct PlatonRecurringWeb: PlatonParametersProtocol {
    
    /// PlatonTransaction ID of the primary transaction in the Payment Platform
    /// - Requires: Numbers in the form XXX
    public let firstTransId: String
    
    /// Value obtained during the primary transaction
    /// - Requires: Numbers in the form XXX
    public let token: String
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.rcId: firstTransId,
            PlatonMethodProperty.rcToken: token
        ]
    }
}
