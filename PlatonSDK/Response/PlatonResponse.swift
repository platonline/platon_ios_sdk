
import Foundation

/**
 Base SDK response
 
 - success: case which will contains response data or one of Platon model
 - failure: case which contain *PlatonError*
 
 ````
 switch platonResponse {
 case .succes(let successData):
     ...
 case .failure(let platonError):
     ...
 }
 ````
 */
public enum PlatonResponse<T> {
    case success(T)
    case failure(PlatonError)
    
    /// This is parsed response object which you can use without switch
    public var responseObject: T? {
        switch self {
        case .success(let object):
            return object
        default:
            return nil
        }
    }
}

/**
 Response for Post Payment *sale* method

 - success: contains *PlatonSaleSuccess* model. When you send data for **succes** request
 - recurringInit: contains *PlatonRecurringInit*. When you send data for **recurring init** request
 - secure3d: contains *PlatonSale3DS*. When you send data for **sale 3ds** request
 - unsuccess: contains *PlatonSaleUnsuccess*. When you receive unsuccess result from server
 - async: contains *PlatonSale*. When you send data for **async** request
 - failure: contains *PlatonError*. When you receive error
 
 ````
 switch platonSaleResponse {
 case .succes(let saleSuccess):
     ...
 case .recurringInit(let recurringInit):
     ...
 case .secure3d(let sale3DS):
     ...
 case .unsuccess(let saleUnsuccess):
     ...
 case .async(let sale):
     ...
 case .failure(let platonError):
 ...
 }
 ````
 */
public enum PlatonSaleResponse {
    case success(PlatonSaleSuccess)
    case recurringInit(PlatonRecurringInit)
    case secure3d(PlatonSale3DS)
    case unsuccess(PlatonSaleUnsuccess)
    case async(PlatonSale)
    case failure(PlatonError)
    
    /// This is parsed response object which you can use without switch
    public var responseObject: PlatonSaleProtocol? {
        switch self {
        case .success(let sale):
            return sale
        case .recurringInit(let sale):
            return sale
        case .secure3d(let sale):
            return sale
        case .unsuccess(let sale):
            return sale
        case .async(let sale):
            return sale
        default:
            return nil
        }
    }
    
}

/**
 Response for Post Payment *capture* method

 - success: contains *PlatonCaptureSuccess* model. When you receive success result from server
 - unsuccess: contains *PlatonCaptureUnsuccess* model. When you receive unsuccess result from server
 - failure: contains *PlatonError*. When you receive error
 
 ````
 switch platonSaleResponse {
 case .succes(let captureSuccess):
     ...
 case .unsuccess(let captureUnsuccess):
     ...
 case .failure(let platonError):
     ...
 }
 ````
*/
public enum PlatonCaptureResponse {
    case success(PlatonCaptureSuccess)
    case unsuccess(PlatonCaptureUnsuccess)
    case failure(PlatonError)
    
    /// This is parsed response object which you can use without switch
    public var responseObject: PlatonCaptureProtocol? {
        switch self {
        case .success(let capture):
            return capture
        case .unsuccess(let capture):
            return capture
        default:
            return nil
        }
    }
}
