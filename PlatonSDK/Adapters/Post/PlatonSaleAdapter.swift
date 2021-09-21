
import Foundation

/// API adapter to facilitate transaction payment capture during SMS and first stage of DMS
final public class PlatonSaleAdapter: PlatonBaseAdapter {
    
    /// Single Message System (SMS)
    ///
    /// SMS is represented by SALE transaction. It is used for authorization and capture at a time.
    ///
    /// This operation is commonly used for immediate payments.
    ///
    /// - Parameters:
    ///   - order: order data. See *PlatonOrder* for details
    ///   - card: credit platonCard data. See *PlatonCard* for details
    ///   - payer: payer data. See *PlatonPayerSale* for details
    ///   - saleOption: sale options for your request to Payment Platform. See *PlatonSaleAdditional*
    ///   - auth: AUTH is used for authorization only, without capture. This operation used to hold the funds on platonCard account (for example to check platonCard validity). In other words this is the first step of two step transaction. Funds are deducted and held from the customer’s credit card. Note that the money is not transferred to the merchant account yet. This is when credit card capture comes in.
    ///   - completion: callback that will return response
    public func sale(order: PlatonOrder,
                     card: PlatonCard,
                     payer: PlatonPayer,
                     saleOption: PlatonSaleAdditional? = nil,
                     auth: PlatonOption? = nil,
                     ext: PlatonExtAdditional,
                     completion: PlatonCalback<PlatonSaleResponse> = nil) {
        
        let hash = [PlatonMethodProperty.hash: PlatonHashUtils.encryptSale(email: payer.email, cardNumber: card.number)]
        
        procesedRequest(restApiMethod: .sale,
                        parameters: [order, card, payer, saleOption,
                                     [PlatonMethodProperty.auth: auth?.rawValue], hash, ext]) { (result) in
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
    
}
