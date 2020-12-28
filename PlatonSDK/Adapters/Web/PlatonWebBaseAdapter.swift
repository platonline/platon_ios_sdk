
import Alamofire

/// Callback type for all Web Pament requests
public typealias PlatonWebCalback = ((_ result: PlatonResponse<DataResponse<String, AFError>>) -> Swift.Void)?

/// Base Web Payment API adaper
public class PlatonWebBaseAdapter: PlatonBaseAdapter {
    
    /// Method for sending request and parsing data on PlatonError
    ///
    /// - Parameters:
    ///   - parameters: all paramters and data
    ///   - completion: callback which will hold Alamofire Requesr Data which has url for web request
    func procesedWebRequest(parameters: [PlatonParametersProtocol?],
                            completion: PlatonWebCalback = nil) {
        
        guard let credentials = PlatonSDK.shared.credentials else {
            completion?(PlatonResponse.failure(PlatonError(type: .sdkAuth)))
            return
        }
        
        let params = genereatePaymentParamters(parameters,
                                               credentials: credentials)
        let dataRequest = Session.default.request(credentials.paymentUrl,
                                                  method: .post,
                                                  parameters: params,
                                                  encoding: URLEncoding.default,
                                                  headers: nil).validate()
        
        print(params.platonStringValue!)
        
        queue.addOperation {
            dataRequest.responseString(completionHandler: { (response) in
                completion?(self.parseResponse(response))
            })
        }
    }
    
    // MARK: - Addtitional fuctions
    
    func parseResponse(_ response: DataResponse<String, AFError>) -> PlatonResponse<DataResponse<String, AFError>> {
        let parsedResponse: PlatonResponse<DataResponse<String, AFError>>
        
        if let unwError = response.error {
            let errorCode = (unwError as NSError).code
            let error = PlatonError(message: unwError.localizedDescription, code: errorCode)
            
            parsedResponse = .failure(error)
            
        } else {
            parsedResponse = .success(response)
        }
        
        return parsedResponse
    }
    
    override func genereatePaymentParamters(_ parameters: [PlatonParametersProtocol?],
                                            method: PlatonMethodAction? = nil,
                                            credentials: PlatonCredentials) -> [String: Any] {
        
        let platonParams: [PlatonParametersProtocol?]
        
        if let unwMethod = method {
            platonParams = [unwMethod.platonParams,
                            parameters,
                            [PlatonMethodProperty.key: credentials.clientKey]]
        } else {
            platonParams = [parameters,
                            [PlatonMethodProperty.key: credentials.clientKey]]
        }
        
        return platonParams.alamofireParams
    }
    
    func sendRequest(_ request: DataRequest, completion: ((DataResponse<String, AFError>) -> Void)?) {
        request.responseString(completionHandler: { (response) in
            completion?(response)
        })
    }
    
}
