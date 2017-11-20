
import Alamofire

/// API adapter for creating SALE transaction in web payments platform
final public class PlatonWebSaleAdapter: PlatonWebBaseAdapter {
    
    /// Following requests creates SALE transaction in payment platform
    ///
    /// It is used for authorization and capture at a time
    ///
    /// This operation is used for immediate web payments
    ///
    /// - Parameters:
    ///   - productSales: list of products for sale transaction
    ///   - successUrl: url by which you proceed after successful payment
    ///   - orderId: order id in payment system
    ///   - payerWebSale: info holder of payer
    ///   - additional: options to control web form representation
    ///   - completion: callback which will hold Alamofire Requesr Data which has url for web request
    public func sale(productSales: [PlatonProductSale]? = nil,
                     successUrl: String,
                     orderId: String,
                     payerWebSale: PlatonPayerWebSale? = nil,
                     additional: PlatonWebSaleAdditional,
                     completion: PlatonWebCalback = nil) {
        
        let payment = PlatonWebPaymentType.CC.rawValue
        let data = PlatonBase64Utils.encode(products: productSales)
        let hash = PlatonHashUtils.encryptSaleWeb(payment: payment,
                                                  data: data,
                                                  successUrl: successUrl)
        let otherParams: PlatonParams = [PlatonMethodProperty.payment: payment,
                                         PlatonMethodProperty.url: successUrl,
                                         PlatonMethodProperty.order: orderId,
                                         PlatonMethodProperty.data: data,
                                         PlatonMethodProperty.sign: hash]
        
        let params: [PlatonParametersProtocol?] = [
            payerWebSale,
            additional,
            otherParams
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
}

