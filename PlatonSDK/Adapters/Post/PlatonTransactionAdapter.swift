
/// API adapter to facilitate retrieving transaction data
final public class PlatonTransactionAdapter: PlatonBaseAdapter {
    
    /// Gets order status (*PlatonStatus*) from Payment Platform
    ///
    /// - Parameters:
    ///   - transactionId: PlatonTransaction ID in the Payment Platform
    ///   - payerEmail: Customer’s email
    ///   - cardNumber: Payer card number
    ///   - completion: callback that will return response
    public func getTransStatus(transactionId: String,
                               payerEmail: String,
                               cardNumber: String,
                               completion: PlatonCalback<PlatonResponse<PlatonTransactionStatus>> = nil) {
        
        let params = [
            PlatonMethodProperty.transId: transactionId,
            PlatonMethodProperty.hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: transactionId)
        ]
        
        procesedRequest(restApiMethod: .getTransStatus, parameters: [params]) { (result) in
            
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let unwStatus = try? jsonDecoder.decode(PlatonTransactionStatus.self, from: data) {
                    completion?(PlatonResponse.success(unwStatus))
                } else {
                    completion?(PlatonResponse.failure(PlatonError(type: .parse)))
                }
            case .failure(let error):
                completion?(PlatonResponse.failure(error))
            }
            
        }
        
    }
    
    /// Gets all history of transactions by the order.
    ///
    /// - Parameters:
    ///   - transactionId: PlatonTransaction ID in the Payment Platform (Required)
    ///   - payerEmail: Customer’s email
    ///   - cardNumber: Payer card number
    ///   - completion: callback that will return response (Required)
    public func getTransDetails(transactionId: String,
                                payerEmail: String,
                                cardNumber: String,
                                completion: PlatonCalback<PlatonResponse<PlatonTransactionDetails>> = nil) {
        
        let params = [
            PlatonMethodProperty.transId: transactionId,
            PlatonMethodProperty.hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: transactionId)
        ]
        
        procesedRequest(restApiMethod: .getTransDetails, parameters: [params]) { (result) in
            
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let unwStatus = try? jsonDecoder.decode(PlatonTransactionDetails.self, from: data) {
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

