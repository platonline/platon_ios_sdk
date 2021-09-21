
/// API adapter to facilitate transaction payment capture during DMS
final public class PlatonCaptureAdapter: PlatonBaseAdapter {

    /// Dual Message System (DMS) - DMS is represented by AUTH and CAPTURE transactions
    ///
    /// *PlatonMethodAction.capture* request is used to submit previously authorized transaction (created by AUTH request)
    ///
    /// Hold funds will be transferred to Merchants account
    ///
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform
    ///   - payerEmail: customer’s email
    ///   - cardNumber: payer card number
    ///   - amount: the amount for partial capture. Only one partial capture allowed
    ///   - completion: callback that will return response
    public func capture(transactionId: String,
                        payerEmail: String,
                        cardNumber: String,
                        amount: Float? = nil,
                        completion: PlatonCalback<PlatonCaptureResponse> = nil) {
        
        let params: PlatonParams = [
            PlatonMethodProperty.transId: transactionId,
            PlatonMethodProperty.amount: amount?.platonAmount,
            PlatonMethodProperty.hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: transactionId)
            ]
        
        procesedRequest(restApiMethod: .capture, parameters: [params]) { (result) in
            let jsonDecoder = JSONDecoder()
            
            switch result {
            case .success(let data):
                
                if let capture = try? jsonDecoder.decode(PlatonCaptureUnsuccess.self, from: data) {
                    completion?(PlatonCaptureResponse.unsuccess(capture))
                    
                } else if let capture = try? jsonDecoder.decode(PlatonCaptureSuccess.self, from: data) {
                    completion?(PlatonCaptureResponse.success(capture))
                } else {
                    completion?(PlatonCaptureResponse.failure(PlatonError(type: .parse)))
                }
                
            case .failure(let error):
                completion?(PlatonCaptureResponse.failure(error))
            }
            
        }
        
    }
}
