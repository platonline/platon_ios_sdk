
/// API adapter for creating SCHEDULE and DESCHEDULE options subscriptions in web payments platform
///
/// If the Client's account supports recurring operations, the Client will be granted with special SCHEDULE_URL and DESCHEDULE_URL to which the POST request with special parameters must be sent to manage the schedule-based recurring payments
final public class PlatonWebScheduleAdapter: PlatonWebBaseAdapter {
    
    /// Schedule-based recurring payments allow you to make payments with stored cardholder data on regular basis
    ///
    /// - Parameters:
    ///   - product: info holder of platonProduct
    ///   - recurring: info holder of rc_id and rc_token
    ///   - additional: schedule options which controls delay, period and repeat times
    ///   - completion: callback which will hold Request Data which has url for web request
    public func schedule(product: PlatonProduct,
                         recurring: PlatonRecurringWeb,
                         additional: PlatonWebScheduleAdditonal,
                         completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let params: [PlatonParametersProtocol?] = [
            product,
            recurring,
            additional,
            [PlatonMethodProperty.sign: PlatonHashUtils.encryptScheduleWeb(productRecurring: product,
                                                                           recurringWeb: recurring,
                                                                           scheduleAdditional: additional)]
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
    
    /// To remove existing recurring schedule, send the POST request with the parameters listed below should be sent to the DESCHEDULE_URL
    ///
    /// - Parameters:
    ///   - recurring: info holder of rc_id and rc_token
    ///   - completion: callback which will hold Request Data which has url for web request
    public func deschedule(recurring: PlatonRecurringWeb,
                           completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        let params: [PlatonParametersProtocol?] = [
            recurring,
            [PlatonMethodProperty.sign: PlatonHashUtils.encryptDescheduleWeb(recurringWeb: recurring)]
        ]
        
        procesedWebRequest(parameters: params, completion: completion)
    }
    
}
