//
//  PlatonWebTokenSaleAdapter.swift
//  PlatonSDK
//
//  Copyright © 2019 Devlight. All rights reserved.
//


/// API adapter for creating SALE transaction in web payments platform
final public class PlatonWebTokenSaleAdapter: PlatonWebBaseAdapter {
    
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
    ///   - completion: callback which will hold Request Data which has url for web request
    public func tokenSale(productSales: [PlatonProductSale]? = nil,
                          orderId: String,
                          successUrl: String,
                          cardToken: String,
                          payerWebSale: PlatonPayerWebSale? = nil,
                          additional: PlatonWebTokenSaleAdditional,
                          completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let payment = PlatonWebPaymentType.CCT.rawValue
        let data = PlatonBase64Utils.encodeToken(products: productSales)
        let hash = PlatonHashUtils.encryptSaleTokenWeb(payment: payment,
                                                  data: data,
                                                  successUrl: successUrl,
                                                  cardToken: cardToken)
        let otherParams: PlatonParams = [PlatonMethodProperty.payment: payment,
                                         PlatonMethodProperty.order: orderId,
                                         PlatonMethodProperty.url: successUrl,
                                         PlatonMethodProperty.cardToken: cardToken,
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

