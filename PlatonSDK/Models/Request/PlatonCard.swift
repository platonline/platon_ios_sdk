
import Foundation

/// Test cards which simulates 4 types of result
///
/// - success: Successful sale with successful result
/// - unsuccess: Unsuccessful sale/recurring payment
/// - success3d: Successful sale after 3DS verification with a manual sending of the result (HTML form)
/// - unsuccess3d: Unsuccessful sale after 3DS verification with a manual sending of the result (HTML form)
public enum Test: Int {
    case success, unsuccess, success3d, unsuccess3d
}

/// Request model that is used to store credit card data
public struct PlatonCard: PlatonParametersProtocol {
    
    /**
     [CVV/CVC2](https://www.cvvnumber.com/cvv.html) credit card verification
     - Requires: 3-4 symbols.
     */
    public var cvv2: String
    
    /**
     [Credit Card](https://en.wikipedia.org/wiki/Payment_card_number)
     - Requires: length >= 12 and length <= 19
     */
    public var number: String
    
    /**
     Month of expiry of the credit card
     - Requires: Month in the form XX (begin with 1)
     - Requires: >= 1 and <= 12
     */
    public var expireMonth: Int
    
    /**
     Year of expiry of the credit card
     - Requires: Year in the form XXXX
     - Requires: >= 1000 and <= 9999
     */
    public var expireYear: Int
    
    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.cardCvv2: cvv2,
            PlatonMethodProperty.cardNumber: number,
            PlatonMethodProperty.cardExpMonth: expireMonth < 10 ? "0\(expireMonth)" : expireMonth,
            PlatonMethodProperty.cardExpYear: expireYear,
        ]

    }
    
    public init(cvv2: String, number: String, expireMonth: Int, expireYear: Int) {
        self.cvv2 = cvv2
        self.number = number
        self.expireMonth = expireMonth
        self.expireYear = expireYear
    }
    
    /// Initiale Payment card with test data
    ///
    /// - Parameter test: Test Payment card
    public init(test: Test?) {
        let unwTest = test ?? .success
        
        let month: Int
        
        switch unwTest {
        case .success:
            month = 1
        case .unsuccess:
            month = 2
        case .success3d:
            month = 5
        case .unsuccess3d:
            month = 6
        }

        self.cvv2 = "411"
        self.number = "4111111111111111"
        self.expireMonth = month
        self.expireYear = 2020
    }
    
}
