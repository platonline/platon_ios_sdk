
/// API adapter for creating RECURRING_SALE transaction in web payments platform
///
/// PlatonRecurring payments used to create new transactions based on already stored cardholder information from previous operations
final public class PlatonWebRecurringAdapter: PlatonWebBaseAdapter {
    
    /// If the Client's account supports recurring operations, the Client will be granted with special RECURRING_URL to which the POST request with special parameters must be sent to make the direct recurring payments
    ///
    /// - Parameters:
    ///   - productRecurring: product info holder
    ///   - recurring: holder for rc_id and rc_token params
    ///   - additional: options for web form representation
    ///   - completion: callback which will hold Request Data which has url for web request
    public func recurringSale(productRecurring: PlatonProductRecurring,
                              recurring: PlatonRecurringWeb,
                              additional: PlatonWebAdditional? = nil,
                              completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let params: [PlatonParametersProtocol?] = [
            productRecurring,
            recurring,
            additional,
            [PlatonMethodProperty.sign: PlatonHashUtils.encryptRecurringWeb(productRecurring: productRecurring,
                                                                            recurring: recurring)]
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
    
}
