
import Foundation

/// API adapter to getting information about a transaction
final public class PlatonTransStateAdapter: PlatonBaseAdapter {
    
    ///
    /// This operation is commonly used for immediate payments.
    ///
    /// - Parameters:
    ///   - order_id: id of order
    ///   - completion: callback that will return response
    public func getState(orderId: String,
                         completion: PlatonCalback<PlatonResponse<PlatonTransactionState>> = nil) {
        
        let hash = [PlatonMethodProperty.hash: PlatonHashUtils.encryptStateTransaction(orderId: orderId)]
        
        procesedRequest(restApiMethod: .transactionState,
                        parameters: [[PlatonMethodProperty.orderId: orderId], hash]) { (result) in            
            switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    
                    if let unwStatus = try? jsonDecoder.decode(PlatonTransactionState.self, from: data) {
                        completion?(PlatonResponse.success(unwStatus))
                    } else {
                        completion?(PlatonResponse.failure(PlatonError(type: .parse)))
                    }
                case .failure(let error):
                    completion?(PlatonResponse.failure(error))
                }
            }
        }
    
}
