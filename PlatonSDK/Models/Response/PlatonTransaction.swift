
import Foundation

final public class PlatonTransaction: Decodable, PlatonCustomDescribe, PlatonAmountProtocol {

    /// Date of transaction
    /// - Requires: YYYY-MM-DD HH:mm:ss ("2012-02-06 01:11:030")
    public let date: String
    
    /// Type of transaction
    public let transType: TransactionType
    
    /// Identify status of transaction
    ///
    /// Can be either *PlatonTransactionStatus.success* or *PlatonTransactionStatus.failure*
    public let status: TransactionStatus
    
    public let amount: Float
    
    public init(date: String, type: TransactionType, status: TransactionStatus, amount: Float) {
        self.date = date
        self.transType = type
        self.status = status
        self.amount = amount
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(type(of: date), forKey: .date)
        self.transType = try container.decode(type(of: transType), forKey: .transType)
        self.status = try container.decode(type(of: status), forKey: .status)
        self.amount = Float(try container.decode(String.self, forKey: .amount)) ?? 0
    }
    
    private enum CodingKeys: String, CodingKey {
        case transType = "type"
        case date, status, amount
    }
    
}

public class PlatonTransactionStatus: PlatonBasePayment { }

final public class PlatonTransactionDetails: PlatonTransactionStatus, PlatonPayerProtocol, PlatonAmountProtocol, PlatonCurrencyProtocol, PlatonCardProtocol {
    
    public let amount: Float
    
    public let currency: String
    
    public let name: String
    
    public let mail: String
    
    public let ip: String
    
    public let card: String
    
    /// Array of transactions
    public let transactions: [PlatonTransaction]
    
    public init(action: PlatonMethodAction, result: PlatonResult, orderId: String, transId: String, status: PlatonStatus, amount: Float, currency: String, name: String, mail: String, ip: String, card: String, transactions: [PlatonTransaction]) {
        self.amount = amount
        self.currency = currency
        self.name = name
        self.mail = mail
        self.ip = ip
        self.card = card
        self.transactions = transactions
        
        super.init(action: action, result: result, orderId: orderId, transId: transId, status: status)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.amount = Float(try container.decode(String.self, forKey: .amount)) ?? 0
        self.currency = try container.decode(type(of: currency), forKey: .currency)
        self.name = try container.decode(type(of: name), forKey: .name)
        self.mail = try container.decode(type(of: mail), forKey: .mail)
        self.ip = try container.decode(type(of: ip), forKey: .ip)
        self.card = try container.decode(type(of: card), forKey: .card)
        self.transactions = try container.decode(type(of: transactions), forKey: .transactions)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case amount, currency, name, mail, ip, card, transactions
    }
}

