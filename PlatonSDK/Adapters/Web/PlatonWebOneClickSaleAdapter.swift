
/// API adapter for integration procedures and WebPaymentsOneClick protocol usage for e-commerce merchants
final public class PlatonWebOneClickSaleAdapter: PlatonWebBaseAdapter {
    
    /// If the client's account supports recurring operations, it is possible for client to make “one-click payments with CVV re-entering”. It is similar to recurring payments processing, but it requires the customer's presence to re-enter his CVC2/CVV2 at the special “reduced” hosted payment form.
    ///
    /// All other payment data like payment card number and customer's details already stored in the PCI storage of Payment Platform. To make such payments, the client should send the customer to the same URL as for normal payments, but with following POST parameters.
    ///
    /// After the successful payment the client will be redirected to the URL that was specified during payment request, as well as on this URL will be sent parameter “order” by the GET method
    ///
    /// - Parameters:
    ///   - productSale: product for one-click transaction
    ///   - recurringWeb: holder for rc_id and rc_token params
    ///   - successUrl: url by which you proceed after successful payment
    ///   - orderId: id of order
    ///   - additonal: options to control web form representation
    ///   - completion: callback which will hold Request Data which has url for web request
    public func sale(productSale: PlatonProductSale,
              recurringWeb: PlatonRecurringWeb,
              payerWebSale: PlatonPayerWebSale? = nil,
              successUrl: String,
              orderId: String? = nil,
              additonal: PlatonWebSaleAdditional? = nil,
              completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let data = PlatonBase64Utils.encode(product: productSale)
        let otherParams: PlatonParams = [
            PlatonMethodProperty.data: data,
            PlatonMethodProperty.url: successUrl,
            PlatonMethodProperty.payment: PlatonWebPaymentType.RF.rawValue,
            PlatonMethodProperty.order: orderId ?? "",
            PlatonMethodProperty.sign: PlatonHashUtils.encryptOneClickSaleWeb(data: data, recurringWeb: recurringWeb, successUrl: successUrl)
        ]
        
        let params: [PlatonParametersProtocol?] = [
            productSale,
            recurringWeb,
            payerWebSale,
            additonal,
            otherParams
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
    
}
