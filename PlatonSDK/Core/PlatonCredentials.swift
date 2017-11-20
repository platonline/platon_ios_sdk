
import Foundation

/// Class which holds all Platon credentials which was passed from *PlatonSdk.config(...)* methods
final public class PlatonCredentials: NSObject, PlatonParametersProtocol {
  
    /// Unique key to identify the account in Payment Platform (used as request parameter)
    public let clientKey: String
    
    /// Password for Client authentication in Payment Platform (used for calculating hash parameter)
    public let clientPass: String
    
    /// URL to request the Payment Platform
    public let paymentUrl: String
    
    /// URL to which Customer should be returned after 3D-Secure. This field is (Required) when your account support 3DSecure (string up to 1024 symbols). Used as request parameter in *PlatonMethodAction.sale*
    public let termUrl3Ds: String?

    public var platonParams: PlatonParams {
        return [
            PlatonMethodProperty.clientKey: clientKey,
        ]
    }
    
    /// Provide Platon SDK credentials and store them here
    ///
    /// - Parameters:
    ///   - clientKey: client key
    ///   - clientPass: client password
    ///   - paymentUrl: payment url
    ///   - termUrl3Ds: url for 3DSecure supported account
    public init(clientKey: String, clientPass: String, paymentUrl: String, termUrl3Ds: String? = nil) {
        self.clientKey = clientKey
        self.clientPass = clientPass
        self.paymentUrl = paymentUrl.hasSuffix("/") ? paymentUrl : "\(paymentUrl)/"
        self.termUrl3Ds = termUrl3Ds
        
        super.init()
    }
    
    /// Provide Platon SDK credentials and store them here
    ///
    /// - Parameters:
    ///   - clientKey: client key
    ///   - clientPass: client password
    ///   - paymentUrl: payment url
    ///   - termUrl3Ds: url for 3DSecure supported account
    public init?(clientKey: String?, clientPass: String?, paymentUrl: String?, termUrl3Ds: String?) {
        guard let unwClientKey = clientKey,
            let unwClientPass = clientPass,
            let unwPaymentUrl = paymentUrl else {
            return nil
        }
        
        self.clientKey = unwClientKey
        self.clientPass = unwClientPass
        self.paymentUrl = unwPaymentUrl.hasSuffix("/") ? unwPaymentUrl : "\(unwPaymentUrl)/"
        self.termUrl3Ds = termUrl3Ds
        
        super.init()
    }
    
}
