
import Foundation
import Alamofire

/// Type of platon marametees for requests
public typealias PlatonParams = [PlatonMethodProperty: Any?]

/// Protocol which your class must if you want to send custom model using *PlatonBaseAdapter*
public protocol PlatonParametersProtocol {
    
    /// Computed property which must return *PlatonParams* object which set relation of class parameters and server keys
    var platonParams: PlatonParams { get }
    
    /// Computed property which return valid params. Has a default realization. So I recommend to skip it.
    /// - Requires: Must return dictionary which contains non optional values and not empty string
    var alamofireParams: Parameters { get }
}

// MARK: - Default realization of the some functions of *PlatonParametersProtocol*
extension PlatonParametersProtocol {
    
    /// Default realization of the *alamofireParams* property. This calculated property returns *Dictionary* which not contains *nil* values and empty *String*
    public var alamofireParams: [String: Any] {
        var alamofireParams = [String: Any]()
        
        for (k, v) in self.platonParams {
            
            if let strV = v as? String, strV.count == 0 {
                continue
            }
            
            if let unwV = v {
                alamofireParams[k.rawValue] = unwV
            }
            
        }
        
        return alamofireParams
    }
}

