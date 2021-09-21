
import Foundation

/// API adapter to facilitate Scheduling/Deschedule payments (recurring)
///
/// Payer can make next variant of payment:
/// - regular with period between payments
/// - restrict payment to specified amount (transaction)
/// - can set delay after which first and further payments with specified period starts
final public class PlatonScheduleAdapter: PlatonBaseAdapter {

    // MARK: - Schedule
    
    /// Registers a schedule for the regular SALE secondary transactions
    ///
    /// Transactions are created by Payment Platform, based on data taken from primary transaction
    ///
    /// - Parameters:
    ///   - order: platonOrder info holder for id, amount and description
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - periodDays: period in days to perform the payments. Format: Numbers in the form XXX
    ///   - payerEmail: customer’s email
    ///   - cardNumber: credit Card Number
    ///   - scheduleAdditonal: schedule info holder for init delay days and repeat times
    ///   - completion: callback that will return response
    public func schedule(order: PlatonOrder,
                         recurring: PlatonRecurring,
                         periodDays: Int,
                         payerEmail: String,
                         cardNumber: String,
                         scheduleAdditonal: PlatonScheduleAdditonal? = nil,
                         completion: PlatonCalback<PlatonResponse<PlatonBasePayment>> = nil) {
        
        schedule(order: order,
                 recurring: recurring,
                 periodDays: periodDays,
                 hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: recurring.firstTransId) ?? "",
                 scheduleAdditonal: scheduleAdditonal,
                 completion: completion)
        
    }
    
    /// Registers a schedule for the regular SALE secondary transactions
    ///
    /// Transactions are created by Payment Platform, based on data taken from primary transaction
    ///
    /// - Parameters:
    ///   - order: platonOrder info holder for id, amount and description
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - periodDays: period in days to perform the payments. Format: Numbers in the form XXX
    ///   - hash: special signature to validate your request to Payment Platform
    ///   - scheduleAdditonal: schedule info holder for init delay days and repeat times
    ///   - completion: callback that will return response
    public func schedule(order: PlatonOrder,
                         recurring: PlatonRecurring,
                         periodDays: Int,
                         hash: String,
                         scheduleAdditonal: PlatonScheduleAdditonal? = nil,
                         completion: PlatonCalback<PlatonResponse<PlatonBasePayment>> = nil) {
        
        procesedRequest(restApiMethod: .schedule,
                            parameters: [order, recurring, [PlatonMethodProperty.period: periodDays, PlatonMethodProperty.hash: hash], scheduleAdditonal]) { (result) in
                                
                                switch result {
                                case .success(let data):
                                    let jsonDecoder = JSONDecoder()
                                    
                                    if let unwStatus = try? jsonDecoder.decode(PlatonBasePayment.self, from: data) {
                                        completion?(PlatonResponse.success(unwStatus))
                                    } else {
                                        completion?(PlatonResponse.failure(PlatonError(type: .parse)))
                                    }
                                case .failure(let error):
                                    completion?(PlatonResponse.failure(error))
                                }
                                
        }
        
    }
    
    // MARK: - Deschedule
    
    /// Deschedule payment for transaction
    ///
    /// Transactions are created by Payment Platform, based on data taken from primary transaction
    ///
    /// - Parameters:
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - payerEmail: customer’s email
    ///   - cardNumber: credit Card Number
    ///   - completion: callback that will return response
    public func deschedule(recurring: PlatonRecurring,
                           payerEmail: String,
                           cardNumber: String,
                           completion: ((_ result: PlatonResponse<PlatonBasePayment>) -> Swift.Void)? = nil) {
        
        deschedule(recurring: recurring,
                   hash: PlatonHashUtils.encryptSale(email: payerEmail, cardNumber: cardNumber, transId: recurring.firstTransId) ?? "",
                   completion: completion)
    }
    
    /// Deschedule payment for transaction
    ///
    /// Transactions are created by Payment Platform, based on data taken from primary transaction
    ///
    /// - Parameters:
    ///   - recurring: platonRecurring info holder for first transaction ID and token
    ///   - hash: special signature to validate your request to Payment Platform
    ///   - completion: callback that will return response
    public func deschedule(recurring: PlatonRecurring,
                           hash: String,
                           completion: ((_ result: PlatonResponse<PlatonBasePayment>) -> Swift.Void)? = nil) {
        
        procesedRequest(restApiMethod: .deschedule,
                        parameters: [recurring, [PlatonMethodProperty.hash: hash]]) { (result) in
                            
                            switch result {
                            case .success(let data):
                                let jsonDecoder = JSONDecoder()
                                
                                if let unwStatus = try? jsonDecoder.decode(PlatonBasePayment.self, from: data) {
                                    completion?(PlatonResponse.success(unwStatus))
                                } else {
                                    completion?(PlatonResponse.failure(PlatonError(type: .parse)))
                                }
                            case .failure(let error):
                                completion?(PlatonResponse.failure(error))
                            }
                            
        }
    }
    
}
