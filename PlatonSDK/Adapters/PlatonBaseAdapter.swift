
import Alamofire

/// Callback type for all Post Pament requests
public typealias PlatonCalback<T> = ((_ result: T) -> Swift.Void)?

/// Base Post Payment API adaper
public class PlatonBaseAdapter: NSObject {
    let queue = OperationQueue()
    
    /// Method for sending request and parsing data on PlatonError
    ///
    /// - Parameters:
    ///   - restApiMethod: api method (action)
    ///   - parameters: all paramters and data
    ///   - completion: callback that will return response
    func procesedRequest(restApiMethod: PlatonMethodAction? = nil,
                         parameters: [PlatonParametersProtocol?],
                         completion: PlatonCalback<PlatonResponse<Data>> = nil) {
        
        guard let credentials = PlatonSDK.shared.credentials else {
            completion?(PlatonResponse.failure(PlatonError(type: .sdkAuth)))
            return
        }
        
        let params = genereatePaymentParamters(parameters,
                                               method: restApiMethod,
                                               credentials: credentials)
        let dataRequest = Alamofire.request(credentials.paymentUrl,
                                            method: .post,
                                            parameters: params,
                                            encoding: URLEncoding.default,
                                            headers: nil).validate()
        
        queue.addOperation {
            dataRequest.responseJSON(completionHandler: { (response) in
                completion?(self.parseResponse(response))
            })
        }
    }
    
    // MARK: - Additional functions
    
    func parseResponse(_ response: DataResponse<Any>) -> PlatonResponse<Data> {
        let parsedResponse: PlatonResponse<Data>
        
        if let unwError = response.error {
            let errorCode = (unwError as NSError).code
            let error = PlatonError(message: unwError.localizedDescription, code: errorCode)
            
            parsedResponse = PlatonResponse.failure(error)
            
        } else if let unwData = response.data {
            
            if let platonError = try? JSONDecoder().decode(PlatonError.self, from: unwData) {
                parsedResponse = PlatonResponse.failure(platonError)
            } else {
                parsedResponse = PlatonResponse.success(unwData)
            }
            
        } else {
            parsedResponse = PlatonResponse.failure(PlatonError(type: .parse))
        }
        
        return parsedResponse
    }
    
    func genereatePaymentParamters(_ parameters: [PlatonParametersProtocol?],
                                   method: PlatonMethodAction?,
                                   credentials: PlatonCredentials) -> [String: Any] {
        
        let platonParams: [PlatonParametersProtocol?]
        
        if let unwMethod = method {
            platonParams = [unwMethod.platonParams,
                            parameters,
                            [PlatonMethodProperty.clientKey: credentials.clientKey]]
        } else {
            platonParams = [parameters,
                            [PlatonMethodProperty.clientKey: credentials.clientKey]]
        }
        
        return platonParams.alamofireParams
    }
    
}
