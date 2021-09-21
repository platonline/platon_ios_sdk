
/// API adapter for creating Card's verification transaction in web payments platform
final public class PlatonWebCardVerificationAdapter: PlatonWebBaseAdapter {
    
    /// Following requests creates Card's verification transaction in payment platform
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
    ///   - completion: callback which will hold Request Data which has url for web request
    public func verify(productSales: [PlatonProductSale]? = nil,
                       successUrl: String,
                       orderId: String,
                       req_token: String,
                       payerWebSale: PlatonPayerWebSale? = nil,
                       additional: PlatonWebSaleAdditional,
                       verificationAdditional: PlatonWebVerificationAdditional,
                       completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let payment = PlatonWebPaymentType.CC.rawValue
        let data = PlatonBase64Utils.encode(products: productSales)
        let hash = PlatonHashUtils.encryptSaleWeb(payment: payment,
                                                  data: data,
                                                  successUrl: successUrl)
        var additional = additional
        additional.formId = "verify"
        let otherParams: PlatonParams = [PlatonMethodProperty.payment: payment,
                                         PlatonMethodProperty.url: successUrl,
                                         PlatonMethodProperty.order: orderId,
                                         PlatonMethodProperty.req_token: req_token,
                                         PlatonMethodProperty.data: data,
                                         PlatonMethodProperty.sign: hash]
        
        let params: [PlatonParametersProtocol?] = [
            payerWebSale,
            additional,
            verificationAdditional,
            otherParams
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
}

