
import Alamofire
import PassKit


/// API adapter to complete transaction payment using ApplePay
final public class PlatonApplePayAdapter: PlatonBaseAdapter {

    /// *PlatonMethodAction.applePay* request is used to submit previously authorized transaction
    ///
    /// Hold funds will be transferred to Merchants account
    ///
    /// - Parameters:
    ///   - payer: payer data. See *PlatonPayerApplePay* for details
    ///   - paymentToken: Token received by a merchant from Apple
    ///   - clientKey:
    ///   - channelId: Payment channel (Sub-account)
    ///   - orderId: Transaction ID in the Clients system
    ///   - orderDescription: Description of the transaction (product name)
    ///   - amount: the amount for partial capture. Only one partial capture allowed
    ///   - termsUrl3ds: URL to which Customer should be returned after 3D-Secure
    ///   - completion: callback that will return response
    public func pay(payer: PlatonPayerApplePay,
                    paymentToken: String,
                    clientKey: String,
                    channelId: String?,
                    orderId: String,
                    orderDescription: String,
                    amount: Float? = nil,
                    termsUrl3ds: String,
                    completion: PlatonCalback<PlatonApplePayResponse> = nil) {
        
        let params: PlatonParams = [
            .clientKey: clientKey,
            .channelId: channelId,
            .orderId: orderId,
            .orderAmount: amount?.platonAmount,
            .orderCurrency: "UAH",
            .orderDescription: orderDescription,
            .paymentToken: paymentToken,
            .termsUrl3ds: termsUrl3ds,
            .hash: PlatonHashUtils.encryptApplePay(email: payer.email, token: paymentToken)
        ]
        
        _ = procesedRequest(restApiMethod: .applePay, parameters: [params, payer]) { (result) in
            let jsonDecoder = JSONDecoder()

            let response: PlatonApplePayResponse

            switch result {
            case .success(let data):
                
                if let decoded = try? jsonDecoder.decode(PlatonApplePay3DS.self, from: data) {
                    response = .secure3d(decoded)
                } else if let decoded = try? jsonDecoder.decode(PlatonApplePayUnsuccess.self, from: data) {
                    response = .unsuccess(decoded)
                } else if let decoded = try? jsonDecoder.decode(PlatonApplePaySuccess.self, from: data) {
                    response = .success(decoded)
                } else {
                    response = .failure(PlatonError(type: .parse))
                }
                print(String(data: data, encoding: .utf8))
            case .failure(let error):
                response = .failure(error)
            }
            completion?(response)
        }
        
    }
}

extension PKPaymentToken: Encodable {
    private enum CodingKeys: String, CodingKey {
        case paymentData
        case paymentMethod
        case transactionIdentifier
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let paymentDataStruct = try JSONDecoder().decode(PaymentData.self, from: paymentData)
        try container.encode(paymentDataStruct, forKey: .paymentData)
        try container.encode(transactionIdentifier, forKey: .transactionIdentifier)
        try container.encode(paymentMethod, forKey: .paymentMethod)
    }
}

extension PKPaymentMethod: Encodable {
    private enum CodingKeys: String, CodingKey {
        case displayName
        case network
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(network?.rawValue, forKey: .network)
        var strType = ""
        switch type {
            case .unknown: strType = "unknown"
            case .debit: strType = "debit"
            case .credit: strType = "credit"
            case .prepaid: strType = "prepaid"
            case .store: strType = "store"
            @unknown default:
            fatalError()
        }
        try container.encode(strType, forKey: .type)
    }
}

struct PaymentData: Codable {
    let version: String
    let data: String
    let signature: String
    let header: PaymentHeader
}

struct PaymentHeader: Codable {
    let ephemeralPublicKey: String
    let publicKeyHash: String
    let transactionId: String
}
