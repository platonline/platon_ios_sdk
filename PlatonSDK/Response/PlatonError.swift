
import Foundation

/// Types of error.
///
/// - noInternet: No internet connection
/// - sdkAuth: When you are not configure SDK or configure with empty fields.
/// - fromServer: When you receive error from server(about bad params, etc.)
/// - parse: When SDK can't parse server data to any Platon Models.
/// - unknown: When you receive unknown error
public enum PlatonErrorType: String, Decodable {
    case noInternet = "No internet connection"
    case sdkAuth = "SDK initialization error"
    case fromServer = "Error from server"
    case parse = "Server data parsing fail"
    case unknown = "Unowned error"
}

/// Error model which using for all failure response
public struct PlatonError: Decodable, PlatonCustomDescribe {
    
    /// Value that system returns on request
    public let result: PlatonResult
    
    /// Specified message
    public let message: String
    
    /// Types of error.
    public let type: PlatonErrorType
    
    /// Error code
    public let code: Int

    public init (result: PlatonResult = .error, message: String? = nil, type: PlatonErrorType = .unknown, code: Int = 0) {
        self.result = result
        self.code = code
        
        if type == .unknown && code == -1009 {
            self.type = .noInternet
        } else {
            self.type = type
        }
        
        if let unwMessage = message {
            self.message = unwMessage
        } else {
            self.message = type.rawValue
        }
        
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.result = try container.decode(PlatonResult.self, forKey: .result)
        self.message = try container.decode(String.self, forKey: .message)
        self.type = .fromServer
        self.code = 0
    }

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "error_message"
    }
}

