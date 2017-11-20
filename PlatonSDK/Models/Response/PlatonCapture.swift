
import Foundation

public class PlatonCaptureSuccess: PlatonBasePayment, PlatonCaptureProtocol {}

final public class PlatonCaptureUnsuccess: PlatonCaptureSuccess, PlatonDeclineReasonProtocol {
    public let declineReason: String
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, status: PlatonStatus, declineReason: String) {
        self.declineReason = declineReason
        
        super.init(action: action, result: result, orderId: orderId, transId: transId, status: status)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.declineReason = try container.decode(type(of: declineReason), forKey: .declineReason)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case declineReason = "decline_reason"
    }
    
}
