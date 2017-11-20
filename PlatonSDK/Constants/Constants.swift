
/// Used as meta-data name for initialization
///
/// - clientKey: Unique key to identify the account in Payment Platform (used as request parameter)
/// - clientPass: Password for Client authentication in Payment Platform (used for calculating hash parameter)
/// - paymentUrl: URL to request the Payment Platform
/// - termUrl3ds: URL to which Customer should be returned after 3D-Secure. This field is (Required) when your account support 3DSecure (string up to 1024 symbols). Used as request parameter in *PlatonMethodAction.sale*.
enum PlatonSDKConstants: String {
    case clientKey = "CLIENT_KEY"
    case clientPass = "CLIENT_PASS"
    case paymentUrl = "PAYMENT_URL"
    case termUrl3ds = "TERM_URL_3DS"
}

/// When you make request to Payment Platform, you need to specify action, that needs to be done
///
/// Note: that last 3 actions can’t be made by request, they’re created by Payment Platform in certain circumstances (e.g. issuer initiated chargeback) and you receive callback as a result
///
/// - capture: Creates CAPTURE transaction
/// - chargeback: CHARGEBACK transaction was created in Payment Platform
/// - creditvoid: Creates REVERSAL or REFUND transaction
/// - deschedule: Disables schedule for recurring transactions
/// - getTransDetails: Gets details of the order from Payment platform
/// - getTransStatus: Gets status of transaction in Payment Platform
/// - recurringSale: Creates SALE transaction using previously used cardholder data
/// - sale: Creates SALE or *PlatonMethodProperties.auth* transaction
/// - schedule: Creates schedule for recurring transactions
/// - secondChargeback: SECOND_CHARGEBACK transaction was created in Payment Platform
/// - secondPresentment: SECOND_PRESENTMENT transaction was created in Payment Platform
public enum PlatonMethodAction: String, Decodable, PlatonParametersProtocol {
    case capture = "CAPTURE"
    case chargeback = "CHARGEBACK"
    case creditvoid = "CREDITVOID"
    case deschedule = "DESCHEDULE"
    case getTransDetails = "GET_TRANS_DETAILS"
    case getTransStatus = "GET_TRANS_STATUS"
    case recurringSale = "RECURRING_SALE"
    case sale = "SALE"
    case schedule = "SCHEDULE"
    case secondChargeback = "SECOND_CHARGEBACK"
    case secondPresentment = "SECOND_PRESENTMENT"
    
    public var platonParams: [PlatonMethodProperty : Any?] {
        return [
            PlatonMethodProperty.action: self.rawValue
        ]
    }
}

/// against field means that it is REQUIRED by request
///
/// - action: Value : *PlatonMethodAction*
/// - address: Buyer's street address for web payments. 123 Sample Street
/// - amount:  The amount for partial capture/ partial refund. That ONLY ONE partial capture allowed in * PlatonMethodAction.capture*. That SEVERAL partial refunds allowed in *PlatonMethodAction.creditvoid*. Numbers in the form XXXX.XX (without leading zeros)
/// - async: Asynchronous or synchronous mode. Used in conjunction with *PlatonOption* only. Default *PlatonOption.no*
/// - auth: Indicates that transaction must be only authenticated, but not captured. Used in conjunction with * PlatonOption* only. Default *PlatonOption.no*
/// - cardCvv2: CVV/CVC2 credit card verification. 3-4 symbols
/// - cardExpMonth: Month of expiry of the credit card. Month in the form XX (begin with 1)
/// - cardExpYear: Year of expiry of the credit card. Year in the form XXXX
/// - cardNumber: [Credit PlatonCard](https://en.wikipedia.org/wiki/Payment_card_number)
/// - channelId: Payment channel (Sub-account)
/// - city: Buyer's city for web payments
/// - clientKey: Unique client key which is stored in *PlatonCredentials*
/// - country: Buyer's country code for web payments
/// - currency: PlatonProduct currency. Value: 3-characters string (USD,EUR, etc.)
/// - data: Properties of the product (price, title, description). Base64-encoded data
/// - description: PlatonProduct name in web payments. Value: String up to 30 characters
/// - email: Buyer's email address for web payments
/// - errorUrl: Optional URL to which the Buyer will be returned after three unsuccessful purchase attempts
/// - ext1: Client Parameter 1
/// - ext2: Client Parameter 2
/// - ext3: Client Parameter 3
/// - ext4: Client Parameter 4
/// - firstName: Buyer's first name for web payments
/// - formId: Specific payment page identifier for web payments. (In case the Client's account has multiple payment pages configured)
/// - hash: Special signature to validate your request to Payment Platform
/// - initPeriod: Delay in days before performing the first payment. Numbers in the form XXX (without leading zeros)
/// - initialDelay: Initial period in days before the first recurring payment to be created
/// - key: Key for Client identification
/// - lang: Localization language to be selected on the payment page by default. Value: en, fr, de (ISO 639-1)
/// - lastName: Buyer's last name for web payments
/// - md: Set of redirect params which used for 3DS
/// - order: PlatonOrder ID for web payments. String up to 30 characters
/// - orderAmount: The amount of the transaction. Numbers in the form XXXX.XX (without leading zeros)
/// - orderCurrency: The amount of the transaction. Currency 3-letter code (ISO 4217)
/// - orderDescription: Description of the transaction (product name). String up to 1024 characters
/// - orderId: PlatonTransaction ID in the Clients system. String up to 255 characters
/// - paReq: Set of redirect params which used for 3DS
/// - payerAddress: Customer’s address. String up to 255 characters
/// - payerCity: Customer’s city. String up to 32 characters
/// - payerCountry: Customer’s country. Country 2-letter code (ISO 3166-1 alpha-2)
/// - payerEmail: Customer’s email. String up to 256 characters
/// - payerFirstName: Customer’s first name. String up to 32 characters
/// - payerIp: IP-address of the Customer. Format XXX.XXX.XXX.XXX. [Min length IP address](https://stackoverflow.com/questions/22288483/whats-the-minimum-length-of-an-ip-address-in-string-representation) and [max length IP address](https://stackoverflow.com/questions/1076714/max-length-for-client-ip-address#answer-7477384)
/// - payerLastName: Customer’s surname. String up to 32 characters
/// - payerPhone: Customer’s phone. String up to 32 characters
/// - payerState: Customer’s state. 2-letter code for countries without states)
/// - payerZip: ZIP-code of the Customer. String up to 32 characters
/// - payment: Payment method code
/// - period: Period in days to perform the payments. Numbers in the form XXX (without leading zeros)
/// - phone: Buyer's phone number for web payments
/// - rcId: PlatonRecurring ID (will be received with the first payment) in web payments
/// - rcToken: Additional parameter for further recurring (will be received with the first payment) in web payments. String 32 characters
/// - reccuringInit: Initialization of the transaction with possible following recurring. Used in conjunction with *PlatonOption* only. Default *PlatonOption.no*
/// - recurring: Flag to initialize the possibility of the further recurring payments
/// - recurringFirstTransId: PlatonTransaction ID of the primary transaction in the Payment Platform. String up to 255 characters
/// - recurringToken: Value obtained during the primary transaction. String up to 255 characters
/// - selected: PlatonProduct, selected by default in products list
/// - sign: Special signature to validate your request to Payment Platform
/// - state: Buyer's country region code (state, provice, etc.) for web payments. Applied only for US, CA and AU. TX (ISO 3166-2)
/// - termUrl: Set of redirect params which used for 3DS
/// - termsUrl3ds: URL to which Customer should be returned after 3D-Secure. If your account support 3D-Secure this parameter is required. String up to 1024 characters
/// - times: The number of times the payments will be done. Not provided or zero value means unlimited number of payments. Numbers in the form XXX (without leading zeros)
/// - transId: PlatonTransaction ID in the Payment Platform
/// - url: URL to which the Buyer will be redirected after the successful payment
/// - zip: Buyer's zip code for web payments.
public enum PlatonMethodProperty: String, Decodable {
    case action = "action"
    case address = "address"
    case amount = "amount"
    case async = "async"
    case auth = "auth"
    case cardCvv2 = "card_cvv2"
    case cardExpMonth = "card_exp_month"
    case cardExpYear = "card_exp_year"
    case cardNumber = "card_number"
    case channelId = "channel_id"
    case city = "city"
    case clientKey = "client_key"
    case country = "country"
    case currency = "currency"
    case data = "data"
    case description = "description"
    case email = "email"
    case errorUrl = "error_url"
    case ext1 = "ext1"
    case ext2 = "ext2"
    case ext3 = "ext3"
    case ext4 = "ext4"
    case firstName = "first_name"
    case formId = "formid"
    case hash = "hash"
    case initPeriod = "init_period"
    case initialDelay = "initial_delay"
    case key = "key"
    case lang = "lang"
    case lastName = "last_name"
    case md = "MD"
    case order = "order"
    case orderAmount = "order_amount"
    case orderCurrency = "order_currency"
    case orderDescription = "order_description"
    case orderId = "order_id"
    case paReq = "PaReq"
    case payerAddress = "payer_address"
    case payerCity = "payer_city"
    case payerCountry = "payer_country"
    case payerEmail = "payer_email"
    case payerFirstName = "payer_first_name"
    case payerIp = "payer_ip"
    case payerLastName = "payer_last_name"
    case payerPhone = "payer_phone"
    case payerState = "payer_state"
    case payerZip = "payer_zip"
    case payment = "payment"
    case period = "period"
    case phone = "phone"
    case rcId = "rc_id"
    case rcToken = "rc_token"
    case reccuringInit = "recurring_init"
    case recurring = "recurring"
    case recurringFirstTransId = "recurring_first_trans_id"
    case recurringToken = "recurring_token"
    case selected = "selected"
    case sign = "sign"
    case state = "state"
    case termUrl = "TermUrl"
    case termsUrl3ds = "term_url_3ds"
    case times = "times"
    case transId = "trans_id"
    case url = "url"
    case zip = "zip"
}

/// Used as convenient variable while creating different requests
///
/// - no: N
/// - yes: Y
public enum PlatonOption: String {
    case no = "N"
    case yes = "Y"
}

/// Result – value that system returns on request
///
/// - accepted: Action was accepted by Payment Platform, but will be completed later
/// - declined: Result of unsuccessful action in Payment Platform
/// - error: Request has errors and was not validated by Payment Platform
/// - redirect: Additional action required from requester (redirect to 3ds)
/// - success: Action was successfully completed in Payment Platform
public enum PlatonResult: String, Decodable {
    case accepted = "ACCEPTED"
    case declined = "DECLINED"
    case error = "ERROR"
    case redirect = "REDIRECT"
    case success = "SUCCESS"
}

/// Status – actual status of transaction in Payment Platform
///
/// - chargeback: Transaction for which chargeback was made
/// - declined: Not successful transaction
/// - panding: The transaction awaits CAPTURE
/// - refound: Transaction for which refund was made
/// - reversal: Transaction for which reversal was made
/// - secondChargeback: Transaction for which second chargeback was made
/// - secondRepresentment: Transaction for which second presentment was made
/// - secure3d: The transaction awaits 3D-Secure validation
/// - settled: Successful transaction
/// - disabled: Disabled scheduling option for order (deschedule)
/// - enabled: Enabled scheduling option for order
public enum PlatonStatus: String, Decodable {
    case chargeback = "CHARGEBACK"
    case declined = "DECLINED"
    case panding = "PENDING"
    case refound = "REFUND"
    case reversal = "REVERSAL"
    case secondChargeback = "SECOND_CHARGEBACK"
    case secondRepresentment = "SECOND_PRESENTMENT"
    case secure3d = "3DS"
    case settled = "SETTLED"
    case disabled = "DISABLED"
    case enabled = "ENABLED"
}

/// Used when fetch transaction data
///
/// - failure: Transaction was failed
/// - success: Transaction was successful
public enum TransactionStatus: Int, Decodable {
    case failure = 0
    case success = 1
}

/// Used when fetch transaction data
///
/// - auth: Transaction of authentication only without capturing. Customer may authenticate many transaction (formed in batch) before they will be captured. First stage of Dual Message System (DMS). On authorization stage in processing
/// - capture: Transaction of payment capturing during second phase of DMS. Funds is transferred from Issuer Bank account through Acquiring Bank down to Merchant Commercial Bank Account. On successful approval by manager
/// - chargeback: Holds that this dispute transaction at the stage of consideration (prior to obtaining evidences and documents)
/// - initialize: Tech status when user will its data on payment page
/// - refound: Transaction of refunding cost
/// - reversal: Transaction of successfully transferring hold money back
/// - sale: Status for transaction with successful immediate payment
/// - secondChargeback: Second request for refund OR transaction is on arbitrary stage (dispute on "dispute transaction")
/// - secondPresentment: Holds that this dispute transaction at the stage of consideration (prior to obtaining evidences and documents)
/// - secure3d: 3DS verification card sending
public enum TransactionType: String, Decodable {
    case auth = "AUTH"
    case capture = "CAPTURE"
    case chargeback = "CHARGEBACK"
    case initialize = "INIT"
    case refound = "REFUND"
    case reversal = "REVERSAL"
    case sale = "SALE"
    case secondChargeback = "SECOND CHARGEBACK"
    case secondPresentment = "SECOND PRESENTMENT"
    case secure3d = "3DS"
}

/// List of typical request types
///
/// - options: OPTIONS
/// - get: GET
/// - head: HEAD
/// - post: POST
/// - put: PUT
/// - patch: PATCH
/// - delete: DELETE
/// - trace: TRACE
/// - connect: CONNECT
public enum PlatonHTTPMethod: String, Decodable {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

/// Payment method code
///
/// - CC: for payment cards
/// - RF: for one-click payment
public enum PlatonWebPaymentType: String {
    case CC = "CC"
    case RF = "RF"
}
