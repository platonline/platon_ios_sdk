
import UIKit

/// API adapter to facilitate PlatonRecurring payments commonly used to create new transactions
///
/// based on already stored cardholder information from previous operations.
final public class PlatonRecurringAdapter: PlatonBaseAdapter {
    
    /// Used for *.recurring* for both Single Message System (SMS) and Dual Message System (DMS)
    ///
    /// RECURRING SALE request has same logic as SALE request (see *PlatonSaleAdapter*), the only difference is that you need to provide primary *.transaction* ID of the primary transaction in the Payment Platform (firstTransId), and this request will create a secondary transaction with previously used cardholder data from primary transaction
    ///
    /// Response from Payment Platform is the same as by *PlatonSaleAdapter* methods
    ///
    /// - Parameters:
    ///   - order: order info holder for id, amount and description
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - hash: special signature to validate your request to Payment Platform
    ///   - auth: indicates that transaction must be only authenticated, but not captured
    ///   - async: asynchronous or synchronous mode
    ///   - completion: callback that will return response
    public func sale(order: PlatonOrder,
                     recurring: PlatonRecurring,
                     hash: String,
                     auth: PlatonOption? = nil,
                     async: PlatonOption? = nil,
                     completion: PlatonCalback<PlatonSaleResponse> = nil) {
        
        let otherParams = [PlatonMethodProperty.hash: hash,
                           PlatonMethodProperty.auth: auth?.rawValue,
                           PlatonMethodProperty.async: async?.rawValue]
        
        _ = procesedRequest(restApiMethod: .recurringSale, parameters: [order, recurring, otherParams]) { (result) in
            let jsonDecoder = JSONDecoder()
            let saleResponse: PlatonSaleResponse
            
            switch result {
            case .success(let saleData):
                
                if let sale = try? jsonDecoder.decode(PlatonSale3DS.self, from: saleData) {
                    saleResponse = PlatonSaleResponse.secure3d(sale)
                    
                } else if let sale = try? jsonDecoder.decode(PlatonSaleUnsuccess.self, from: saleData) {
                    saleResponse = PlatonSaleResponse.unsuccess(sale)
                    
                } else if let sale = try? jsonDecoder.decode(PlatonRecurringInit.self, from: saleData) {
                    saleResponse = PlatonSaleResponse.recurringInit(sale)
                    
                } else if let sale = try? jsonDecoder.decode(PlatonSaleSuccess.self, from: saleData) {
                    saleResponse = PlatonSaleResponse.async(sale)
                    
                } else if let sale = try? jsonDecoder.decode(PlatonSale.self, from: saleData) {
                    saleResponse = PlatonSaleResponse.async(sale)
                    
                } else {
                    saleResponse = PlatonSaleResponse.failure(PlatonError(type: .parse))
                }
                
            case .failure(let error):
                saleResponse = PlatonSaleResponse.failure(error)
            }
            
            completion?(saleResponse)
        }
    }
    
    /// Used for platonRecurring for both Single Message System (SMS) and Dual Message System (DMS)
    ///
    /// RECURRING SALE request has same logic as SALE request (see *PlatonSaleAdapter*), the only difference is that you need to provide primary PlatonTransaction ID of the primary transaction in the Payment Platform (firstTransId), and this request will create a secondary transaction with previously used cardholder data from primary transaction
    ///
    /// - Parameters:
    ///   - order: order info holder for id, amount and description
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - email: customer’s email
    ///   - cardNumber: credit Card Number
    ///   - auth: indicates that transaction must be only authenticated, but not captured
    ///   - async: asynchronous or synchronous mode
    ///   - completion: callback that will return response
    public func sale(order: PlatonOrder,
                     recurring: PlatonRecurring,
                     email: String,
                     cardNumber: String,
                     auth: PlatonOption? = nil,
                     async: PlatonOption? = nil,
                     completion: PlatonCalback<PlatonSaleResponse> = nil) {
        
        self.sale(order: order,
                  recurring: recurring,
                  hash: PlatonHashUtils.encryptSale(email: email, cardNumber: cardNumber) ?? "",
                  auth: auth,
                  async: async, completion: completion)
    }
    
}
