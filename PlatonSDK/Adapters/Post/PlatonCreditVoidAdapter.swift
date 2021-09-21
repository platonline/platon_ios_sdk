
/// API adapter to facilitate both fund *PlatonStatus.refound* and fund *PlatonStatus.reversal* operations
final public class PlatonCreditVoidAdapter: PlatonBaseAdapter {
    
    /// *PlatonMethodAction.creditvoid* request is used to complete both *PlatonStatus.refund* and *PlatonStatus.reversal* transactions
    ///
    /// *PlatonStatus.reversal* transaction is used to cancel hold from funds on card account, previously authorized by AUTH transaction
    ///
    /// *PlatonStatus.refund* transaction is used to return funds to card account, previously submitted by *PlatonMethodAction.sale* or *PlatonMethodAction.capture* transactions
    ///
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform
    ///   - payerEmail: customer’s email
    ///   - cardNumber: payer card number
    ///   - amount: the amount for partial refund. Several partial refunds allowed
    ///   - completion: callback that will return response
    public func creditVoid(transactionId: String,
                           payerEmail: String,
                           cardNumber: String,
                           amount: Float? = nil,
                           completion: PlatonCalback<PlatonResponse<PlatonCreditVoid>> = nil) {
        
        let params: PlatonParams = [
            PlatonMethodProperty.transId: transactionId,
            PlatonMethodProperty.amount: amount?.platonAmount,
            PlatonMethodProperty.hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: transactionId)
        ]
        
        procesedRequest(restApiMethod: .creditvoid, parameters: [params])
        { (result) in
            
            switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    
                    if let unwCreditVoid = try? jsonDecoder.decode(PlatonCreditVoid.self, from: data) {
                        completion?(PlatonResponse.success(unwCreditVoid))
                    } else {
                        completion?(PlatonResponse.failure(PlatonError(type: .parse)))
                    }
                    
                case .failure(let error):
                    completion?(PlatonResponse.failure(error))
            }
            
        }
        
    }
}
