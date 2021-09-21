
import Foundation

/// Type of platon marametees for requests
public typealias PlatonParams = [PlatonMethodProperty: Any?]

public typealias AnyParams = [String: Any]

/// Protocol which your class must if you want to send custom model using *PlatonBaseAdapter*
public protocol PlatonParametersProtocol {
    
    /// Computed property which must return *PlatonParams* object which set relation of class parameters and server keys
    var platonParams: PlatonParams { get }
    
    /// Computed property which return valid params. Has a default realization. So I recommend to skip it.
    /// - Requires: Must return dictionary which contains non optional values and not empty string
    var anyParams: AnyParams { get }
}

// MARK: - Default realization of the some functions of *PlatonParametersProtocol*
extension PlatonParametersProtocol {
    
    /// Default realization of the *anyParams* property. This calculated property returns *Dictionary* which not contains *nil* values and empty *String*
    public var anyParams: AnyParams {
        var anyParams = AnyParams()
        
        for (k, v) in self.platonParams {
            
            if let strV = v as? String, strV.count == 0 {
                continue
            }
            
            if let unwV = v {
                anyParams[k.rawValue] = unwV
            }
            
        }
        
        return anyParams
    }
    
}

extension AnyParams {
    /// Prepare query to URL safe string
    public func prepareQuery() -> String {
        var prepared: [(String, String)] = []

        for key in self.keys.sorted(by: <) {
            let value = self[key]!
            prepared += [(key, "\(value)".addingPercentEncoding(withAllowedCharacters: .plURLQueryAllowed) ?? "\(value)")]
        }
        return prepared.map { "\($0)=\($1)" }.joined(separator: "&")
    }

}

extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    public static let plURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

