
import Foundation

/**
 The start point of usage Platon SDK is here
 
 Before you get an account to access Payment Platform (Platon SDK),
 you must provide the following data to the Payment Platform administrator:
 IP list       - List of your IP addresses, from which requests to Payment Platform will be sent
 Callback URL  - URL which will be receiving the notifications of the processing results of your
 Payment Platform
 Contact email - Client’s contact email
 
 Note for Post client:
 Callback URL is mandatory if you work in asynchronous mode, or if your account
 supports 3D-Secure. The length of Callback URL shouldn’t be more than 255 symbols.
 With all Payment Platform POST requests at Callback URL the Client must return the
 string "OK" if he successfully received data or return "ERROR".
 
 Note for Web client:
 The Client must provide an URL callback (Callback) to which the notifications will be sent
 in case of successfully completed payments as well as the refunds and chargeback
 notices. In any case when the system send a request to Callback URL, it should return
 HTTP 200 code, otherwise the system will try to send a request again up to 5 times.
 
 You should get the following information from administrator and
 set them in *Platon-info.plist* to begin working with the Payment Platform:
 *PlatonSDKConstants.clientKey* - client key
 *PlatonSDKConstants.clientPass* - client password
 *PlatonSDKConstants.paymentUrl* - payment url
 
 Next field is required when your account support 3DSecure:
 *PlatonSdkConstants.termUrl3ds* - user 3ds callback url
 
 Then you should write the next code to init Platon SDK:
 ````
 PlatonSDK.config()
 ````
 
 If can't on don't wont to use *Platon-info.plist*, you can configure PlatonSDK in code. You can configure PlatonSDK with following methods:
 ````
 PlatonSDK.config(credendials: PlatonCredentials(clientKey: "ClientKey",
                                                clientPass: "ClientPass",
                                                paymentUrl: "PaymentUrl"))
 ````
 **or**
 ````
 PlatonSDK.config(credendials: PlatonCredentials(clientKey: "ClientKey",
                                                clientPass: "ClientPass",
                                                paymentUrl: "PaymentUrl",
                                                termUrl3Ds: "TermUrl3Ds"))
 ````
 
 To test/simulate your requests to Platon Payment System use *PlatonCard(test: Test?)* environment
 */
final public class PlatonSDK: NSObject {
    
    /// Singletone access for PlatonSDK
    public static let shared = PlatonSDK()
    
    /// Platon credentials which will authorize application in Payment System
    public var credentials: PlatonCredentials?
    
    /// This function automatically read *PlatonCredentials* from *Platon-info.plist* and configure PlatonSDK with this credentials
    /// - Requires: Use this function for configure PlatonSDK with *Platon-info.plist* file
    public static func config() {
        let sdk = PlatonSDK.shared
        
        if let platonInfo = PlatonSDKUtils.getPlist(name: "Platon-info") as? [String: String] {
            sdk.credentials = PlatonCredentials(
                clientKey: platonInfo[PlatonSDKConstants.clientKey.rawValue],
                clientPass: platonInfo[PlatonSDKConstants.clientPass.rawValue],
                paymentUrl: platonInfo[PlatonSDKConstants.paymentUrl.rawValue],
                termUrl3Ds: platonInfo[PlatonSDKConstants.termUrl3ds.rawValue]
            )
        } else {
            sdk.credentials = nil
        }
    }
    
    /// This fuction configure PlatonSDK with your *PlatonCredentials* from code
    ///
    /// - Parameter credendials: your credentilans
    /// - Requires: Use this function for configure PlatonSDK in code
    public static func config(credendials: PlatonCredentials?) {
        PlatonSDK.shared.credentials = credendials
    }
    
    override private init() {
        super.init()
    }
    
}

/**
 Brief description of the interaction with Post Payment Platform:
 
 1. For the transaction, you must send the server to server HTTPS POST request with
 fields listed below to Payment Platform URL (PAYMENT_URL). In response
 Payment Platform will return the JSON (http://json.org/) encoded string.
 
 2. If your account supports 3D-Secure and credit card supports 3D-Secure, then
 Payment Platform will return the link to the 3D-Secure Access Control Server to
 3 perform 3D-Secure verification. In this case, you need to redirect the card-holder at
 this link. If there are also some parameters except the link in the result, you will
 need to redirect the cardholder at this link together with the parameters using the
 method of data transmitting indicated in the same result.
 
 3. In the case of 3D-Secure after verification on the side of the 3D-Secure server, the
 owner of a credit card will come back to your site using the link you specify in the
 sale request, and Payment Platform will return the result of transaction processing
 to the Callback URL action.
 */
final public class PlatonPostPayment {
    
    /// Aadapter for *PlatonMethodAction.sale* request
    public static let sale = PlatonSaleAdapter()
    
    /// Adapter for *PlatonMethodAction.capture* request
    public static let capture = PlatonCaptureAdapter()
    
    /// Adapter for *PlatonMethodAction.creditvoid* request
    public static let creditVoid = PlatonCreditVoidAdapter()
    
    /// Adapter for *PlatonMethodAction.getTransDetails*  and *PlatonMethodAction.getTransStatus* requests
    public static let transaction = PlatonTransactionAdapter()
    
    /// Adapter for *PlatonMethodAction.recurringSale* request
    public static let recurring = PlatonRecurringAdapter()
    
    /// Adapter for *PlatonMethodAction.schedule* and *PlatonMethodAction.deschedule* requests
    public static let schedule = PlatonScheduleAdapter()
}

/**
 Brief description of the interaction with Web Payment Platform:
 
 To initiate transaction Client must prepare HTML form data according to this document and
 submit these fields as POST in Payer's browser to Payment Platform URL
 (PAYMENT_URL).
 
 If transaction requires 3D-Secure or any other kind of verification procedures, Client don't
 need to change anything in request, as all verification processes would be managed using
 Hosted Payment Page on the Payment Platform's side.
 
 After the successful payment the Payer's browser will be redirected to the URL, which was
 specified during payment request and the parameter “order” will be sent to this URL by the
 GET method.
 */
final public class PlatonWebPayment {
    
    /// Adapter for web sale requests
    public static let sale = PlatonWebSaleAdapter()
    
    /// Adapter for web recurring sale requests
    public static let oneClickSale = PlatonWebOneClickSaleAdapter()
    
    
    // Will be available in next releases
    
    /// Adapter for web recurring sale requests
    private static let recurring = PlatonWebRecurringAdapter()
    
    /// Adapter for web schedule and deschedule options setting requests
    private static let schedule = PlatonWebScheduleAdapter()
}
