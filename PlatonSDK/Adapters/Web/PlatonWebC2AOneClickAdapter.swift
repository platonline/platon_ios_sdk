
/// API adapter for creating C2A OneClick transaction in web payments platform
final public class PlatonWebC2AOneClickAdapter: PlatonWebBaseAdapter {
    
    /// Following requests creates C2A OneClick transaction in payment platform
    ///
    /// It is used for authorization and capture at a time
    ///
    /// This operation is used for immediate web payments
    ///
    /// - Parameters:
    ///   - productSale: product for sale transaction
    ///   - successUrl: url by which you proceed after successful payment
    ///   - orderId: order id in payment system
    ///   - payerWebSale: info holder of payer
    ///   - additional: options to control web form representation
    ///   - completion: callback which will hold Request Data which has url for web request
    public func sale(productSale: PlatonProductSale,
                     successUrl: String,
                     orderId: String,
                     payerWebSale: PlatonPayerWebSale? = nil,
                     additional: PlatonWebTokenSaleAdditional,
                     completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let payment = PlatonWebPaymentType.C2AT.rawValue + "," + PlatonWebPaymentType.CCT.rawValue
        let hash = PlatonHashUtils.encryptC2AWeb(payment: payment,
                                                 productSale: productSale,
                                                 successUrl: successUrl)
        let otherParams: PlatonParams = [PlatonMethodProperty.payment: payment,
                                         PlatonMethodProperty.url: successUrl,
                                         PlatonMethodProperty.order: orderId,
                                         PlatonMethodProperty.sign: hash]
        
        let params: [PlatonParametersProtocol?] = [
            productSale,
            payerWebSale,
            additional,
            otherParams
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
}

